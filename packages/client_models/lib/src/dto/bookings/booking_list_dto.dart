import 'package:freezed_annotation/freezed_annotation.dart';

import 'booking_dto.dart';

part 'booking_list_dto.freezed.dart';

@freezed
class BookingListDto with _$BookingListDto {
  const BookingListDto._();
  const factory BookingListDto({required List<BookingDto>? bookings}) = _BookingListDto;

  factory BookingListDto.empty() => const BookingListDto(bookings: []);
}
