// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'settings_row.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SettingsRow _$SettingsRowFromJson(Map<String, dynamic> json) => SettingsRow(
  id: json['id'] as String,
  name: json['name'] as String,
  value: json['value'] as String?,
  legacyObjectId: json['legacy_object_id'] as String?,
);

Map<String, dynamic> _$SettingsRowToJson(SettingsRow instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'value': instance.value,
      'legacy_object_id': instance.legacyObjectId,
    };
