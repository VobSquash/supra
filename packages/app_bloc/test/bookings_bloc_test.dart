import 'package:app_bloc/app_bloc.dart';
import 'package:client_models/client_models.dart';
import 'package:middleware/middleware_clients.dart';
import 'package:test/test.dart';

class _FakeBookingsFacade implements IBookingsFacade {
  @override
  Future<BookingListDto> loadBookings({required DateTime forDate}) async =>
      BookingListDto(
        bookings: [
          BookingDto.empty().copyWith(
            displayName: 'Court user',
            courtNo: 2,
            bookingDate: DateTime.utc(
              forDate.year,
              forDate.month,
              forDate.day,
              14,
              30,
            ),
            groupBookingId: 0,
          ),
        ],
      );

  @override
  Future<void> createBooking({required CreateBookingDto booking}) async {}

  @override
  Future<void> deleteBooking({required String bookingId}) async {}
}

void main() {
  test(
    'onLoadBookings ends in loadingSuccess and keeps selected date',
    () async {
      final bloc = BookingsBloc(_FakeBookingsFacade());
      final day = DateTime(2026, 4, 9);

      bloc.add(BookingsEvent.onLoadBookings(forDate: day));
      await bloc.stream.firstWhere(
        (s) => s.status.status == BaseLoadingStatus.loadingSuccess,
      );
      expect(bloc.state.bookings.length, 1);
      expect(bloc.state.bookings.single.displayName, 'Court user');
      expect(bloc.state.selectedDate, DateTime(2026, 4, 9));
      await bloc.close();
    },
  );
}
