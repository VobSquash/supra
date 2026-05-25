import 'dart:convert';

import 'package:client_models/client_models.dart';
import 'package:client_supabase/client_supabase.dart';
import 'package:injectable/injectable.dart';
import 'package:middleware/src/injection.dart';
import 'package:middleware/src/mappers/settings/supabase_settings_mapper.dart';

import 'i_settings_facade.dart';

@LazySingleton(as: ISettingsFacade)
class SettingsFacade implements ISettingsFacade {
  SettingsFacade();

  IClientSupabase get _client => middlewareSl<IClientSupabase>();

  @override
  Future<SettingsDTO> loadSettings() async {
    final rows = await _client.settings.getSettings();
    return const SupabaseSettingsMapper().convert<List<SettingsRow>, SettingsDTO>(rows);
  }

  @override
  Future<void> updateShowLadderBreakdown(bool showLadderBreakdown) async {
    final rows = await _client.settings.getSettings();
    final name = SettingsTypeEnum.systemSettings.identifierType;
    SettingsRow? row;
    for (final r in rows) {
      if (r.name == name) {
        row = r;
        break;
      }
    }
    final decoded = <String, dynamic>{};
    final raw = row?.value?.trim();
    if (raw != null && raw.isNotEmpty) {
      try {
        final parsed = jsonDecode(raw);
        if (parsed is Map<String, dynamic>) {
          decoded.addAll(Map<String, dynamic>.from(parsed));
        }
      } on Object {
        // Corrupt legacy JSON — overwrite with minimal payload.
      }
    }
    decoded['showLadderBreakdown'] = showLadderBreakdown;
    if (row == null) {
      throw StateError('Missing SystemSettings row (expected ${SettingsTypeEnum.systemSettings.identifierType}).');
    }
    await _client.settings.patchSettingValueWhereIdEq(
      id: row.id,
      value: jsonEncode(decoded),
    );
  }

  @override
  Future<void> updateLadderTeamBreakdown(BreakdownTeamsDTO breakdown) async {
    final rows = await _client.settings.getSettings();
    SettingsRow? row;
    for (final r in rows) {
      if (r.name == SettingsTypeEnum.currentLeagueTeamBreakdown.identifierType || r.name == 'LadderBreakdown2026') {
        row = r;
        break;
      }
    }
    if (row == null) {
      throw StateError('Missing ladder breakdown settings row (expected LadderBreakdown2026).');
    }

    final merged = <String, dynamic>{};
    final rawValue = row.value?.trim();
    if (rawValue != null && rawValue.isNotEmpty) {
      try {
        final parsed = jsonDecode(rawValue);
        if (parsed is Map<String, dynamic>) {
          merged.addAll(Map<String, dynamic>.from(parsed));
        }
      } on Object {
        // Corrupt legacy JSON — overwritten by keys below.
      }
    }

    for (final e in breakdown.toJson().entries) {
      if (e.value != null) {
        merged[e.key] = e.value;
      }
    }

    await _client.settings.patchSettingValueWhereIdEq(
      id: row.id,
      value: jsonEncode(merged),
    );
  }
}
