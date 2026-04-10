import 'dart:convert';

import 'package:auto_mappr_annotation/auto_mappr_annotation.dart';
import 'package:client_models/client_models.dart';
import 'package:client_supabase/client_supabase.dart';

import 'settings_ladder_breakdown_mapper.auto_mappr.dart';

@AutoMappr([
  MapType<SettingsRow, BreakdownTeamsDTO>(
    fields: [
      Field('objectId', custom: SettingsLadderBreakdownMapper.getObjectId),
      Field('mensteams', custom: SettingsLadderBreakdownMapper.getMensTeams),
      Field('ladiesTeams', custom: SettingsLadderBreakdownMapper.getLadiesTeams),
      Field('mastersTeams', custom: SettingsLadderBreakdownMapper.getMastersTeams),
    ],
  ),
])
class SettingsLadderBreakdownMapper extends $SettingsLadderBreakdownMapper {
  const SettingsLadderBreakdownMapper() : super();

  static String getObjectId(SettingsRow? settings) {
    return settings?.legacyObjectId ?? '';
  }

  static List<BreakdownItemDTO>? getMensTeams(SettingsRow? settings) {
    return _teams(settings, 'LeagueTeams');
  }

  static List<BreakdownItemDTO>? getLadiesTeams(SettingsRow? settings) {
    return _teams(settings, 'LeagueLadiesTeams');
  }

  static List<BreakdownItemDTO>? getMastersTeams(SettingsRow? settings) {
    return _teams(settings, 'LeagueMastersTeams');
  }

  static List<BreakdownItemDTO>? _teams(SettingsRow? settings, String key) {
    if (settings?.value == null) return null;
    try {
      final decoded = jsonDecode(settings!.value!);
      if (decoded is! Map<String, dynamic>) return null;
      final league = decoded[key];
      if (league is! List<dynamic>) return null;
      return List<BreakdownItemDTO>.from(
        league.map((item) => BreakdownItemDTO.fromJson(item as Map<String, dynamic>)),
      );
    } on Object {
      return null;
    }
  }
}
