// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'booking_row.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BookingRow _$BookingRowFromJson(Map<String, dynamic> json) => BookingRow(
  id: json['id'] as String,
  vobGuid: json['vob_guid'] as String?,
  courtNo: (json['court_no'] as num?)?.toInt(),
  bookingDate: DateTime.parse(json['booking_date'] as String),
  displayName: json['display_name'] as String?,
  groupBookingId: (json['group_booking_id'] as num?)?.toInt(),
  legacyObjectId: json['legacy_object_id'] as String?,
);

Map<String, dynamic> _$BookingRowToJson(BookingRow instance) =>
    <String, dynamic>{
      'id': instance.id,
      'vob_guid': instance.vobGuid,
      'court_no': instance.courtNo,
      'booking_date': instance.bookingDate.toIso8601String(),
      'display_name': instance.displayName,
      'group_booking_id': instance.groupBookingId,
      'legacy_object_id': instance.legacyObjectId,
    };
