import 'package:json_annotation/json_annotation.dart';

import 'location.dart';

part 'location_row.g.dart';

/// Supabase `locations` table row (PostgREST / JSON).
///
/// Mirrors the legacy `DatabaseLocation` shape from Parse.
@JsonSerializable()
class LocationRow implements ILocation {
  const LocationRow({
    required this.id,
    this.vobGuid,
    this.name,
    this.latitude,
    this.longitude,
    this.lookup,
  });

  factory LocationRow.fromJson(Map<String, dynamic> json) => _$LocationRowFromJson(json);

  @override
  final String id;

  @override
  @JsonKey(name: 'vob_guid')
  final String? vobGuid;

  @override
  final String? name;

  @override
  final String? latitude;

  @override
  final String? longitude;

  @override
  final String? lookup;

  Map<String, dynamic> toJson() => _$LocationRowToJson(this);

  static LocationRow empty({String id = ''}) => LocationRow(id: id);
}
