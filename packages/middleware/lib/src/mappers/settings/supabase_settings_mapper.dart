import 'package:auto_mappr_annotation/auto_mappr_annotation.dart';
import 'package:client_models/client_models.dart';
import 'package:client_supabase/client_supabase.dart';

import 'settings_fees_mapper.dart';
import 'settings_ladder_breakdown_mapper.dart';
import 'settings_system_settings_mapper.dart';
import 'supabase_settings_mapper.auto_mappr.dart';

@AutoMappr([
  MapType<List<SettingsRow>, SettingsDTO>(
    fields: [
      Field('ladderBreakdown', custom: SupabaseSettingsMapper.getLeagueTeams),
      Field('systemSettings', custom: SupabaseSettingsMapper.getSystemSettings),
      Field('fees', custom: SupabaseSettingsMapper.getFees),
    ],
  ),
])
class SupabaseSettingsMapper extends $SupabaseSettingsMapper {
  const SupabaseSettingsMapper() : super();

  static SettingsRow? _findByName(List<SettingsRow> rows, bool Function(SettingsRow) match) {
    for (final r in rows) {
      if (match(r)) {
        return r;
      }
    }
    return null;
  }

  static FeesDTO getFees(List<SettingsRow> settings) {
    final row = _findByName(
      settings,
      (e) => e.name == SettingsTypeEnum.fees2026.identifierType,
    );
    if (row == null || row.value == null) {
      return FeesDTO.empty();
    }
    return const SettingsFeesMapper().convert<SettingsRow, FeesDTO>(row);
  }

  static BreakdownTeamsDTO getLeagueTeams(List<SettingsRow> settings) {
    final row = _findByName(
      settings,
      (e) =>
          e.name == SettingsTypeEnum.currentLeagueTeamBreakdown.identifierType ||
          e.name == 'LadderBreakdown2026',
    );
    if (row == null || row.value == null) {
      return BreakdownTeamsDTO.empty();
    }
    return const SettingsLadderBreakdownMapper().convert<SettingsRow, BreakdownTeamsDTO>(row);
  }

  static SystemSettingsDTO getSystemSettings(List<SettingsRow> settings) {
    final row = _findByName(
      settings,
      (e) => e.name == SettingsTypeEnum.systemSettings.identifierType,
    );
    if (row == null || row.value == null) {
      return SystemSettingsDTO.empty();
    }
    return const SettingsSystemSettingsMapper().convert<SettingsRow, SystemSettingsDTO>(row);
  }
}
