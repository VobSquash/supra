// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'location_row.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LocationRow _$LocationRowFromJson(Map<String, dynamic> json) => LocationRow(
  id: json['id'] as String,
  vobGuid: json['vob_guid'] as String?,
  name: json['name'] as String?,
  latitude: json['latitude'] as String?,
  longitude: json['longitude'] as String?,
  lookup: json['lookup'] as String?,
);

Map<String, dynamic> _$LocationRowToJson(LocationRow instance) =>
    <String, dynamic>{
      'id': instance.id,
      'vob_guid': instance.vobGuid,
      'name': instance.name,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'lookup': instance.lookup,
    };
