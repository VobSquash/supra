import 'dart:convert';

import 'package:auto_mappr_annotation/auto_mappr_annotation.dart';
import 'package:client_models/client_models.dart';
import 'package:client_supabase/client_supabase.dart';

import 'settings_fees_mapper.auto_mappr.dart';

@AutoMappr([
  MapType<SettingsRow, FeesDTO>(
    fields: [
      Field('items', custom: SettingsFeesMapper.getItems),
    ],
  ),
])
class SettingsFeesMapper extends $SettingsFeesMapper {
  const SettingsFeesMapper() : super();

  /// Matches legacy `FeesMapper.getItems` (`Fees` key) plus array / `items` shapes.
  static List<FeesItemDTO> getItems(SettingsRow settings) {
    final raw = settings.value;
    if (raw == null || raw.trim().isEmpty) {
      return [];
    }
    try {
      final decoded = jsonDecode(raw);
      if (decoded is List) {
        return decoded
            .whereType<Map<String, dynamic>>()
            .map(FeesItemDTO.fromJson)
            .toList(growable: false);
      }
      if (decoded is Map<String, dynamic>) {
        final feesList = decoded['Fees'] as List<dynamic>? ??
            decoded['items'] as List<dynamic>? ??
            decoded['fees'] as List<dynamic>?;
        if (feesList == null) {
          return [];
        }
        return feesList
            .whereType<Map<String, dynamic>>()
            .map(FeesItemDTO.fromJson)
            .toList(growable: false);
      }
    } on Object {
      return [];
    }
    return [];
  }
}
