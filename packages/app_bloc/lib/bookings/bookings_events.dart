part of 'bookings_bloc.dart';

@freezed
class BookingsEvent with _$BookingsEvent {
  const factory BookingsEvent.onLoadBookings({required DateTime forDate}) = OnLoadBookings;

  const factory BookingsEvent.onResetBookings() = OnResetBookings;
}
