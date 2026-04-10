// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ladder_entry_row.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LadderEntryRow _$LadderEntryRowFromJson(Map<String, dynamic> json) =>
    LadderEntryRow(
      id: json['id'] as String,
      sortOrder: (json['sort_order'] as num?)?.toInt(),
      year: (json['year'] as num?)?.toInt(),
      vobGuid: json['vob_guid'] as String?,
      team: (json['team'] as num?)?.toInt(),
      canBeChallenged: json['can_be_challenged'] as bool?,
      legacyObjectId: json['legacy_object_id'] as String?,
    );

Map<String, dynamic> _$LadderEntryRowToJson(LadderEntryRow instance) =>
    <String, dynamic>{
      'id': instance.id,
      'sort_order': instance.sortOrder,
      'year': instance.year,
      'vob_guid': instance.vobGuid,
      'team': instance.team,
      'can_be_challenged': instance.canBeChallenged,
      'legacy_object_id': instance.legacyObjectId,
    };
