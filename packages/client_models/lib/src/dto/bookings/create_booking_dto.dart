import 'package:meta/meta.dart';

/// Payload required to create a new booking row.
@immutable
class CreateBookingDto {
  const CreateBookingDto({
    required this.courtNo,
    required this.bookingDate,
    this.vobGuid,
    this.displayName,
    this.groupBookingId,
    this.legacyObjectId,
  });

  final int courtNo;
  final DateTime bookingDate;
  final String? vobGuid;
  final String? displayName;
  final int? groupBookingId;
  final String? legacyObjectId;
}
