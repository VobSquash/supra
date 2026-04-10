part of 'bookings_bloc.dart';

@freezed
class BookingsState with _$BookingsState {
  const factory BookingsState({
    required DateTime selectedDate,
    required List<BookingDto> bookings,
    required BaseLoading status,
  }) = _BookingsState;

  factory BookingsState.initial() => BookingsState(
        selectedDate: _calendarDay(DateTime.now()),
        bookings: const [],
        status: BaseLoading.initial(),
      );
}
