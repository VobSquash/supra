import 'dart:io';

import 'package:args/args.dart';
import 'package:migration/src/migration_runner.dart';

Future<void> main(List<String> arguments) async {
  final parser = ArgParser()
    ..addFlag(
      'help',
      abbr: 'h',
      negatable: false,
      help: 'Print usage.',
    )
    ..addOption(
      'config',
      abbr: 'c',
      defaultsTo: 'migration_config.json',
      help: 'Path to migration JSON (see migration_config.example.json): AppConfig fields '
          'plus optional supabase_service_role_key.',
    )
    ..addFlag(
      'migrate',
      help: 'Upsert into Supabase. Without this flag, only fetches from Parse and prints a sample.',
      defaultsTo: false,
    )
    ..addFlag(
      'locations',
      help: 'Migrate Parse class Locations → Supabase public.locations (instead of profiles).',
      defaultsTo: false,
    )
    ..addFlag(
      'settings',
      help: 'Migrate Parse class Settings → Supabase public.settings (instead of profiles).',
      defaultsTo: false,
    )
    ..addFlag(
      'ladders',
      help: 'Migrate Parse ladder classes → Supabase public.ladder_mens, ladder_ladies, ladder_masters (instead of profiles).',
      defaultsTo: false,
    )
    ..addFlag(
      'club-captains',
      help: 'Migrate Parse LeagueCaptains → Supabase public.league_captains (instead of profiles).',
      defaultsTo: false,
    )
    ..addFlag(
      'league-fixtures',
      help: 'Migrate Parse LeagueFixture → Supabase public.league_fixtures (instead of profiles).',
      defaultsTo: false,
    )
    ..addFlag(
      'bookings',
      help: 'Migrate Parse Bookings → Supabase public.bookings (instead of profiles).',
      defaultsTo: false,
    )
    ..addFlag(
      'active-only',
      help: 'Only migrate Parse profiles where IsActive is true (ignored with single-table migration flags).',
      defaultsTo: false,
    )
    ..addOption(
      'supabase-key',
      help: 'Supabase API key for writes (overrides migration_config / env).',
    );

  final results = parser.parse(arguments);

  if (results['help'] as bool) {
    stdout.writeln('Usage: dart run migration [options]');
    stdout.writeln(parser.usage);
    return;
  }

  final configPath = results['config'] as String;
  final configFile = File(configPath);
  if (!configFile.existsSync()) {
    stderr.writeln('Config file not found: $configPath');
    exitCode = 2;
    return;
  }

  final supabaseKeyOpt = results['supabase-key'] as String?;
  final supabaseKey = (supabaseKeyOpt != null && supabaseKeyOpt.isNotEmpty)
      ? supabaseKeyOpt
      : null;

  final locationsOnly = results['locations'] as bool;
  final settingsOnly = results['settings'] as bool;
  final laddersOnly = results['ladders'] as bool;
  final clubCaptainsOnly = results['club-captains'] as bool;
  final leagueFixturesOnly = results['league-fixtures'] as bool;
  final bookingsOnly = results['bookings'] as bool;
  final modeCount = (locationsOnly ? 1 : 0) +
      (settingsOnly ? 1 : 0) +
      (laddersOnly ? 1 : 0) +
      (clubCaptainsOnly ? 1 : 0) +
      (leagueFixturesOnly ? 1 : 0) +
      (bookingsOnly ? 1 : 0);
  if (modeCount > 1) {
    stderr.writeln(
      'Use only one of --locations, --settings, --ladders, --club-captains, --league-fixtures, or --bookings.',
    );
    exitCode = 2;
    return;
  }

  final runner = MigrationRunner(
    configFile: configFile,
    dryRun: !(results['migrate'] as bool),
    activeProfilesOnly: results['active-only'] as bool,
    supabaseApiKey: supabaseKey,
    locationsOnly: locationsOnly,
    settingsOnly: settingsOnly,
    laddersOnly: laddersOnly,
    clubCaptainsOnly: clubCaptainsOnly,
    leagueFixturesOnly: leagueFixturesOnly,
    bookingsOnly: bookingsOnly,
  );

  try {
    await runner.run();
  } on Object catch (e, st) {
    stderr.writeln(e);
    stderr.writeln(st);
    exitCode = 1;
  }
}
