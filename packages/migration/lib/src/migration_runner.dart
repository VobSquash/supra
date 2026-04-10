import 'dart:convert';
import 'dart:io';

import 'package:client_models/client_models.dart';
import 'package:client_supabase/client_supabase.dart';

import 'back4app/back4app_bookings_extractor.dart';
import 'back4app/back4app_ladder_extractor.dart';
import 'back4app/back4app_league_captains_extractor.dart';
import 'back4app/back4app_league_fixture_extractor.dart';
import 'back4app/back4app_location_extractor.dart';
import 'back4app/back4app_profile_extractor.dart';
import 'back4app/back4app_settings_extractor.dart';
import 'map/parse_to_supabase_mapper.dart';
import 'merge/merge_profiles.dart';
import 'migration_config_io.dart';
import 'supabase/supabase_bookings_loader.dart';
import 'supabase/supabase_ladder_loader.dart';
import 'supabase/supabase_league_captains_loader.dart';
import 'supabase/supabase_league_fixtures_loader.dart';
import 'supabase/supabase_location_loader.dart';
import 'supabase/supabase_profile_loader.dart';
import 'supabase/supabase_settings_loader.dart';

/// Loads [AppConfig] from disk, pulls Parse data, optionally writes to Supabase.
///
/// Use [locationsOnly] / [settingsOnly] / [laddersOnly] / [clubCaptainsOnly] / [leagueFixturesOnly] / [bookingsOnly] to migrate those tables instead of profiles.
class MigrationRunner {
  MigrationRunner({
    required this.configFile,
    required this.dryRun,
    required this.activeProfilesOnly,
    this.supabaseApiKey,
    this.locationsOnly = false,
    this.settingsOnly = false,
    this.laddersOnly = false,
    this.clubCaptainsOnly = false,
    this.leagueFixturesOnly = false,
    this.bookingsOnly = false,
  });

  final File configFile;
  final bool dryRun;
  final bool activeProfilesOnly;

  /// When `true`, runs the Location → Supabase `locations` pipeline only.
  final bool locationsOnly;

  /// When `true`, runs Parse `Settings` → Supabase `settings` pipeline only.
  final bool settingsOnly;

  /// When `true`, runs Parse ladder classes → Supabase `ladder_mens` / `ladder_ladies` / `ladder_masters` only.
  final bool laddersOnly;

  /// When `true`, runs Parse `LeagueCaptains` → Supabase `league_captains` only.
  final bool clubCaptainsOnly;

  /// When `true`, runs Parse `LeagueFixture` → Supabase `league_fixtures` only.
  final bool leagueFixturesOnly;

  /// When `true`, runs Parse `Bookings` → Supabase `bookings` only.
  final bool bookingsOnly;

  /// Overrides config file / env (use service role for bulk upsert / RLS bypass).
  final String? supabaseApiKey;

  Future<void> run() async {
    final raw = await configFile.readAsString();
    final decoded = jsonDecode(raw);
    if (decoded is! Map<String, dynamic>) {
      throw const FormatException('Config root must be a JSON object');
    }
    final migrationFile = MigrationConfigFile.fromJson(decoded);
    final appConfig = migrationFile.appConfig;

    if (settingsOnly) {
      await _runSettings(migrationFile: migrationFile, appConfig: appConfig);
      return;
    }

    if (laddersOnly) {
      await _runLadders(migrationFile: migrationFile, appConfig: appConfig);
      return;
    }

    if (locationsOnly) {
      await _runLocations(migrationFile: migrationFile, appConfig: appConfig);
      return;
    }

    if (clubCaptainsOnly) {
      await _runClubCaptains(migrationFile: migrationFile, appConfig: appConfig);
      return;
    }

    if (leagueFixturesOnly) {
      await _runLeagueFixtures(migrationFile: migrationFile, appConfig: appConfig);
      return;
    }

    if (bookingsOnly) {
      await _runBookings(migrationFile: migrationFile, appConfig: appConfig);
      return;
    }

    final extractor = Back4appProfileExtractor(
      baseUrl: appConfig.back4AppBaseUrl.trim().replaceAll(RegExp(r'/+$'), ''),
      applicationId: appConfig.back4AppAppId,
      clientKey: appConfig.back4AppClientId,
      masterKey: appConfig.back4AppMasterKey,
    );

    try {
      final profiles = await extractor.fetchProfiles(
        activeOnly: activeProfilesOnly,
        limit: 300,
      );
      final objectIds = profiles.map((p) => p['objectId'] as String).toList(growable: false);

      final extensions = await extractor.fetchProfileExtensionsForProfiles(
        objectIds,
        limit: 300,
      );

      if (profiles.length != extensions.length) {
        stderr.writeln(
          'Warning: Profile count (${profiles.length}) != ProfileExtensions count (${extensions.length}).',
        );
      }

      final merged = mergeProfilesAndExtensions(
        profiles: profiles,
        extensions: extensions,
      );

      stdout.writeln('Fetched ${profiles.length} profiles, merged ${merged.length} rows.');

      final payloads = <({Map<String, dynamic> ext, Map<String, dynamic> prof})>[];
      var skipped = 0;
      for (final m in merged) {
        try {
          payloads.add(mapToSupabasePayloads(m));
        } on StateError catch (e) {
          skipped++;
          stderr.writeln('SKIP: $e');
        }
      }
      if (skipped > 0) {
        stderr.writeln('Skipped $skipped profile(s) with invalid vob_guid.');
      }

      if (dryRun) {
        stdout.writeln('Dry run: no Supabase writes.');
        final sample = payloads.take(3).toList();
        for (var i = 0; i < sample.length; i++) {
          stdout.writeln('--- sample ${i + 1} ---');
          stdout.writeln('extension: ${sample[i].ext}');
          stdout.writeln('profile: ${_redactForLog(sample[i].prof)}');
        }
        return;
      }

      final key = _firstNonEmpty([
        supabaseApiKey,
        migrationFile.supabaseServiceRoleKey,
        Platform.environment['SUPABASE_SERVICE_ROLE_KEY'],
      ]);
      if (key == null || key.isEmpty) {
        throw StateError(
          'No Supabase API key for writes: set migration_config.json '
          '`supabase_service_role_key`, or use --supabase-key, or env SUPABASE_SERVICE_ROLE_KEY.',
        );
      }

      final dio = createSupabaseDio(
        SupabaseConfig(
          supabaseUrl: appConfig.supabaseUrl,
          anonKey: key,
        ),
      );
      final loader = SupabaseProfileLoader(dio: dio);

      // Order matters: `profile_extensions.vob_guid` FKs to `profiles`, but `profiles.profile_extension_id`
      // FKs to `profile_extensions`. Insert profile without the extension link, then extension, then link.
      for (final p in payloads) {
        final profWithoutFk = Map<String, dynamic>.from(p.prof)..remove('profile_extension_id');
        await loader.upsertProfile(profWithoutFk);
        await loader.upsertExtension(p.ext);
        await loader.upsertProfile(p.prof);
      }

      stdout.writeln(
        'Migration complete: ${payloads.length} profile pairs upserted'
        '${skipped > 0 ? ' ($skipped skipped)' : ''}.',
      );
    } finally {
      extractor.close();
    }
  }

  Future<void> _runLocations({
    required MigrationConfigFile migrationFile,
    required AppConfig appConfig,
  }) async {
    final extractor = Back4appLocationExtractor(
      baseUrl: appConfig.back4AppBaseUrl.trim().replaceAll(RegExp(r'/+$'), ''),
      applicationId: appConfig.back4AppAppId,
      clientKey: appConfig.back4AppClientId,
      masterKey: appConfig.back4AppMasterKey,
    );

    try {
      final parseRows = await extractor.fetchLocations(limit: 500);
      stdout.writeln('Fetched ${parseRows.length} Parse Locations row(s).');

      final rows = <Map<String, dynamic>>[];
      var skipped = 0;
      for (final r in parseRows) {
        try {
          rows.add(mapParseLocationToSupabaseRow(r));
        } on StateError catch (e) {
          skipped++;
          stderr.writeln('SKIP: $e');
        }
      }
      if (skipped > 0) {
        stderr.writeln('Skipped $skipped location(s) with invalid Id (vob_guid).');
      }

      if (dryRun) {
        stdout.writeln('Dry run: no Supabase writes.');
        final sample = rows.take(3).toList();
        for (var i = 0; i < sample.length; i++) {
          stdout.writeln('--- sample ${i + 1} ---');
          stdout.writeln(jsonEncode(sample[i]));
        }
        return;
      }

      final key = _firstNonEmpty([
        supabaseApiKey,
        migrationFile.supabaseServiceRoleKey,
        Platform.environment['SUPABASE_SERVICE_ROLE_KEY'],
      ]);
      if (key == null || key.isEmpty) {
        throw StateError(
          'No Supabase API key for writes: set migration_config.json '
          '`supabase_service_role_key`, or use --supabase-key, or env SUPABASE_SERVICE_ROLE_KEY.',
        );
      }

      final dio = createSupabaseDio(
        SupabaseConfig(
          supabaseUrl: appConfig.supabaseUrl,
          anonKey: key,
        ),
      );
      final loader = SupabaseLocationLoader(dio: dio);

      for (final row in rows) {
        await loader.upsertLocation(row);
      }

      stdout.writeln(
        'Locations migration complete: ${rows.length} row(s) upserted'
        '${skipped > 0 ? ' ($skipped skipped)' : ''}.',
      );
    } finally {
      extractor.close();
    }
  }

  Future<void> _runSettings({
    required MigrationConfigFile migrationFile,
    required AppConfig appConfig,
  }) async {
    final extractor = Back4appSettingsExtractor(
      baseUrl: appConfig.back4AppBaseUrl.trim().replaceAll(RegExp(r'/+$'), ''),
      applicationId: appConfig.back4AppAppId,
      clientKey: appConfig.back4AppClientId,
      masterKey: appConfig.back4AppMasterKey,
    );

    try {
      final parseRows = await extractor.fetchSettings(limit: 500);
      stdout.writeln('Fetched ${parseRows.length} Parse Settings row(s).');

      final rows = <Map<String, dynamic>>[];
      var skipped = 0;
      for (final r in parseRows) {
        try {
          rows.add(mapParseSettingsToSupabaseRow(r));
        } on StateError catch (e) {
          skipped++;
          stderr.writeln('SKIP: $e');
        }
      }
      if (skipped > 0) {
        stderr.writeln('Skipped $skipped settings row(s).');
      }

      if (dryRun) {
        stdout.writeln('Dry run: no Supabase writes.');
        final sample = rows.take(3).toList();
        for (var i = 0; i < sample.length; i++) {
          stdout.writeln('--- sample ${i + 1} ---');
          stdout.writeln(jsonEncode(sample[i]));
        }
        return;
      }

      final key = _firstNonEmpty([
        supabaseApiKey,
        migrationFile.supabaseServiceRoleKey,
        Platform.environment['SUPABASE_SERVICE_ROLE_KEY'],
      ]);
      if (key == null || key.isEmpty) {
        throw StateError(
          'No Supabase API key for writes: set migration_config.json '
          '`supabase_service_role_key`, or use --supabase-key, or env SUPABASE_SERVICE_ROLE_KEY.',
        );
      }

      final dio = createSupabaseDio(
        SupabaseConfig(
          supabaseUrl: appConfig.supabaseUrl,
          anonKey: key,
        ),
      );
      final loader = SupabaseSettingsLoader(dio: dio);

      for (final row in rows) {
        await loader.upsertSetting(row);
      }

      stdout.writeln(
        'Settings migration complete: ${rows.length} row(s) upserted'
        '${skipped > 0 ? ' ($skipped skipped)' : ''}.',
      );
    } finally {
      extractor.close();
    }
  }

  Future<void> _runLadders({
    required MigrationConfigFile migrationFile,
    required AppConfig appConfig,
  }) async {
    final extractor = Back4appLadderExtractor(
      baseUrl: appConfig.back4AppBaseUrl.trim().replaceAll(RegExp(r'/+$'), ''),
      applicationId: appConfig.back4AppAppId,
      clientKey: appConfig.back4AppClientId,
      masterKey: appConfig.back4AppMasterKey,
    );

    try {
      SupabaseLadderLoader? loader;
      if (!dryRun) {
        final key = _firstNonEmpty([
          supabaseApiKey,
          migrationFile.supabaseServiceRoleKey,
          Platform.environment['SUPABASE_SERVICE_ROLE_KEY'],
        ]);
        if (key == null || key.isEmpty) {
          throw StateError(
            'No Supabase API key for writes: set migration_config.json '
            '`supabase_service_role_key`, or use --supabase-key, or env SUPABASE_SERVICE_ROLE_KEY.',
          );
        }

        final dio = createSupabaseDio(
          SupabaseConfig(
            supabaseUrl: appConfig.supabaseUrl,
            anonKey: key,
          ),
        );
        loader = SupabaseLadderLoader(dio: dio);
      }

      final dryRunSamples = <Map<String, dynamic>>[];
      var skipped = 0;
      var upserted = 0;

      for (final lt in LadderTypeEnum.values) {
        final parseRows = await extractor.fetchLadderClass(lt.databaseClassName);
        stdout.writeln('Fetched ${parseRows.length} Parse ${lt.databaseClassName} row(s).');
        for (final r in parseRows) {
          try {
            final row = mapParseLadderRowToSupabase(
              parseRow: r,
              ladderTypeIdentifier: lt.identifierType,
            );
            if (dryRun) {
              if (dryRunSamples.length < 50) {
                dryRunSamples.add(row);
              }
            } else {
              await loader!.upsert(lt.postgresTableName, row);
              upserted++;
            }
          } on StateError catch (e) {
            skipped++;
            stderr.writeln('SKIP: $e');
          }
        }
      }
      if (skipped > 0) {
        stderr.writeln('Skipped $skipped ladder row(s).');
      }

      if (dryRun) {
        stdout.writeln('Dry run: no Supabase writes.');
        final sample = dryRunSamples.take(3).toList();
        for (var i = 0; i < sample.length; i++) {
          stdout.writeln('--- sample ${i + 1} ---');
          stdout.writeln(jsonEncode(sample[i]));
        }
        return;
      }

      stdout.writeln(
        'Ladders migration complete: $upserted row(s) upserted'
        '${skipped > 0 ? ' ($skipped skipped)' : ''}.',
      );
    } finally {
      extractor.close();
    }
  }

  Future<void> _runClubCaptains({
    required MigrationConfigFile migrationFile,
    required AppConfig appConfig,
  }) async {
    final extractor = Back4appLeagueCaptainsExtractor(
      baseUrl: appConfig.back4AppBaseUrl.trim().replaceAll(RegExp(r'/+$'), ''),
      applicationId: appConfig.back4AppAppId,
      clientKey: appConfig.back4AppClientId,
      masterKey: appConfig.back4AppMasterKey,
    );

    try {
      final parseRows = await extractor.fetchLeagueCaptains(limit: 1000);
      stdout.writeln('Fetched ${parseRows.length} Parse LeagueCaptains row(s).');

      final rows = <Map<String, dynamic>>[];
      var skipped = 0;
      for (final r in parseRows) {
        try {
          rows.add(mapParseLeagueCaptainToSupabaseRow(r));
        } on StateError catch (e) {
          skipped++;
          stderr.writeln('SKIP: $e');
        }
      }
      if (skipped > 0) {
        stderr.writeln('Skipped $skipped league captain row(s).');
      }

      if (dryRun) {
        stdout.writeln('Dry run: no Supabase writes.');
        final sample = rows.take(3).toList();
        for (var i = 0; i < sample.length; i++) {
          stdout.writeln('--- sample ${i + 1} ---');
          stdout.writeln(jsonEncode(sample[i]));
        }
        return;
      }

      final key = _firstNonEmpty([
        supabaseApiKey,
        migrationFile.supabaseServiceRoleKey,
        Platform.environment['SUPABASE_SERVICE_ROLE_KEY'],
      ]);
      if (key == null || key.isEmpty) {
        throw StateError(
          'No Supabase API key for writes: set migration_config.json '
          '`supabase_service_role_key`, or use --supabase-key, or env SUPABASE_SERVICE_ROLE_KEY.',
        );
      }

      final dio = createSupabaseDio(
        SupabaseConfig(
          supabaseUrl: appConfig.supabaseUrl,
          anonKey: key,
        ),
      );
      final loader = SupabaseLeagueCaptainsLoader(dio: dio);

      for (final row in rows) {
        await loader.upsertLeagueCaptain(row);
      }

      stdout.writeln(
        'League captains migration complete: ${rows.length} row(s) upserted'
        '${skipped > 0 ? ' ($skipped skipped)' : ''}.',
      );
    } finally {
      extractor.close();
    }
  }

  Future<void> _runLeagueFixtures({
    required MigrationConfigFile migrationFile,
    required AppConfig appConfig,
  }) async {
    final extractor = Back4appLeagueFixtureExtractor(
      baseUrl: appConfig.back4AppBaseUrl.trim().replaceAll(RegExp(r'/+$'), ''),
      applicationId: appConfig.back4AppAppId,
      clientKey: appConfig.back4AppClientId,
      masterKey: appConfig.back4AppMasterKey,
    );

    try {
      final parseRows = await extractor.fetchLeagueFixtures(limit: 2000);
      stdout.writeln('Fetched ${parseRows.length} Parse LeagueFixture row(s).');

      final rows = <Map<String, dynamic>>[];
      var skipped = 0;
      for (final r in parseRows) {
        try {
          rows.add(mapParseLeagueFixtureToSupabaseRow(r));
        } on StateError catch (e) {
          skipped++;
          stderr.writeln('SKIP: $e');
        }
      }
      if (skipped > 0) {
        stderr.writeln('Skipped $skipped league fixture row(s).');
      }

      if (dryRun) {
        stdout.writeln('Dry run: no Supabase writes.');
        final sample = rows.take(3).toList();
        for (var i = 0; i < sample.length; i++) {
          stdout.writeln('--- sample ${i + 1} ---');
          stdout.writeln(jsonEncode(sample[i]));
        }
        return;
      }

      final key = _firstNonEmpty([
        supabaseApiKey,
        migrationFile.supabaseServiceRoleKey,
        Platform.environment['SUPABASE_SERVICE_ROLE_KEY'],
      ]);
      if (key == null || key.isEmpty) {
        throw StateError(
          'No Supabase API key for writes: set migration_config.json '
          '`supabase_service_role_key`, or use --supabase-key, or env SUPABASE_SERVICE_ROLE_KEY.',
        );
      }

      final dio = createSupabaseDio(
        SupabaseConfig(
          supabaseUrl: appConfig.supabaseUrl,
          anonKey: key,
        ),
      );
      final loader = SupabaseLeagueFixturesLoader(dio: dio);

      for (final row in rows) {
        await loader.upsertLeagueFixture(row);
      }

      stdout.writeln(
        'League fixtures migration complete: ${rows.length} row(s) upserted'
        '${skipped > 0 ? ' ($skipped skipped)' : ''}.',
      );
    } finally {
      extractor.close();
    }
  }

  Future<void> _runBookings({
    required MigrationConfigFile migrationFile,
    required AppConfig appConfig,
  }) async {
    final extractor = Back4appBookingsExtractor(
      baseUrl: appConfig.back4AppBaseUrl.trim().replaceAll(RegExp(r'/+$'), ''),
      applicationId: appConfig.back4AppAppId,
      clientKey: appConfig.back4AppClientId,
      masterKey: appConfig.back4AppMasterKey,
    );

    try {
      const minBookingYear = 2026;
      final parseRows = await extractor.fetchBookings(minBookingYear: minBookingYear);
      stdout.writeln(
        'Fetched ${parseRows.length} Parse Bookings row(s) (BookingDate ≥ 1 Jan $minBookingYear UTC).',
      );

      final rows = <Map<String, dynamic>>[];
      var skipped = 0;
      for (final r in parseRows) {
        try {
          rows.add(mapParseBookingToSupabaseRow(r));
        } on StateError catch (e) {
          skipped++;
          stderr.writeln('SKIP: $e');
        }
      }
      if (skipped > 0) {
        stderr.writeln('Skipped $skipped booking row(s).');
      }

      if (dryRun) {
        stdout.writeln('Dry run: no Supabase writes.');
        final sample = rows.take(3).toList();
        for (var i = 0; i < sample.length; i++) {
          stdout.writeln('--- sample ${i + 1} ---');
          stdout.writeln(jsonEncode(sample[i]));
        }
        return;
      }

      final key = _firstNonEmpty([
        supabaseApiKey,
        migrationFile.supabaseServiceRoleKey,
        Platform.environment['SUPABASE_SERVICE_ROLE_KEY'],
      ]);
      if (key == null || key.isEmpty) {
        throw StateError(
          'No Supabase API key for writes: set migration_config.json '
          '`supabase_service_role_key`, or use --supabase-key, or env SUPABASE_SERVICE_ROLE_KEY.',
        );
      }

      final dio = createSupabaseDio(
        SupabaseConfig(
          supabaseUrl: appConfig.supabaseUrl,
          anonKey: key,
        ),
      );
      final loader = SupabaseBookingsLoader(dio: dio);

      for (final row in rows) {
        await loader.upsertBooking(row);
      }

      stdout.writeln(
        'Bookings migration complete: ${rows.length} row(s) upserted'
        '${skipped > 0 ? ' ($skipped skipped)' : ''}.',
      );
    } finally {
      extractor.close();
    }
  }
}

Map<String, dynamic> _redactForLog(Map<String, dynamic> profileRow) {
  final out = Map<String, dynamic>.from(profileRow);
  if (out.containsKey('password')) {
    out['password'] = '***';
  }
  return out;
}

String? _firstNonEmpty(List<String?> candidates) {
  for (final c in candidates) {
    final t = c?.trim();
    if (t != null && t.isNotEmpty) {
      return t;
    }
  }
  return null;
}
