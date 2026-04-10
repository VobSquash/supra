import 'package:client_models/client_models.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'booking_dto.freezed.dart';

@freezed
class BookingDto with _$BookingDto {
  const BookingDto._();
  const factory BookingDto({
    required String? objectId,
    required int? courtNo,
    required DateTime? bookingDate,
    required String? displayName,
    required BasicProfileDTO? profile,
    required int? groupBookingId,
    required bool isMine,
    required int? index,
    String? profilePictureUrl,
  }) = _BookingDto;

  factory BookingDto.empty() => const BookingDto(
    objectId: null,
    courtNo: null,
    bookingDate: null,
    displayName: null,
    profile: null,
    groupBookingId: null,
    isMine: false,
    index: null,
    profilePictureUrl: null,
  );

  @override
  String toString() {
    final formattedDate = bookingDate != null ? bookingDate!.toYYYYMMDDHHMM() : 'null';
    return 'Court $courtNo: $formattedDate';
  }
}
