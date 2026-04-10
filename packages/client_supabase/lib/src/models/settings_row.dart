import 'package:json_annotation/json_annotation.dart';

import 'settings_kv.dart';

part 'settings_row.g.dart';

/// Supabase `settings` table: one row per Parse `Settings` (Name / Value).
@JsonSerializable()
class SettingsRow implements ISettingsKv {
  const SettingsRow({
    required this.id,
    required this.name,
    this.value,
    this.legacyObjectId,
  });

  factory SettingsRow.fromJson(Map<String, dynamic> json) => _$SettingsRowFromJson(json);

  @override
  final String id;

  @override
  final String name;

  @override
  final String? value;

  @override
  @JsonKey(name: 'legacy_object_id')
  final String? legacyObjectId;

  Map<String, dynamic> toJson() => _$SettingsRowToJson(this);
}
