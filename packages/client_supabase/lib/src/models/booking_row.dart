import 'package:json_annotation/json_annotation.dart';

part 'booking_row.g.dart';

/// Supabase `bookings` row (Parse `Bookings`).
@JsonSerializable()
class BookingRow {
  const BookingRow({
    required this.id,
    this.vobGuid,
    this.courtNo,
    required this.bookingDate,
    this.displayName,
    this.groupBookingId,
    this.legacyObjectId,
  });

  factory BookingRow.fromJson(Map<String, dynamic> json) => _$BookingRowFromJson(json);

  final String id;

  @JsonKey(name: 'vob_guid')
  final String? vobGuid;

  @JsonKey(name: 'court_no')
  final int? courtNo;

  @JsonKey(name: 'booking_date')
  final DateTime bookingDate;

  @JsonKey(name: 'display_name')
  final String? displayName;

  @JsonKey(name: 'group_booking_id')
  final int? groupBookingId;

  @JsonKey(name: 'legacy_object_id')
  final String? legacyObjectId;

  Map<String, dynamic> toJson() => _$BookingRowToJson(this);
}
