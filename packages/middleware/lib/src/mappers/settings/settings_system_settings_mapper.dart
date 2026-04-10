import 'dart:convert';

import 'package:auto_mappr_annotation/auto_mappr_annotation.dart';
import 'package:client_models/client_models.dart';
import 'package:client_supabase/client_supabase.dart';

import 'settings_system_settings_mapper.auto_mappr.dart';

@AutoMappr([
  MapType<SettingsRow, SystemSettingsDTO>(
    fields: [
      Field('objectId', custom: SettingsSystemSettingsMapper.getObjectId),
      Field('showLadderBreakdown', custom: SettingsSystemSettingsMapper.getShowLadderBreakdown),
    ],
  ),
])
class SettingsSystemSettingsMapper extends $SettingsSystemSettingsMapper {
  const SettingsSystemSettingsMapper() : super();

  static String getObjectId(SettingsRow? settings) {
    return settings?.legacyObjectId ?? '';
  }

  static bool getShowLadderBreakdown(SettingsRow? settings) {
    if (settings?.value == null) return false;
    try {
      final decoded = jsonDecode(settings!.value!);
      if (decoded is! Map<String, dynamic>) return false;
      final v = decoded['showLadderBreakdown'];
      return v is bool ? v : false;
    } on Object {
      return false;
    }
  }
}
