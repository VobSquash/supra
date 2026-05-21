import 'package:app_bloc/app_bloc.dart';
import 'package:client_models/client_models.dart';
import 'package:middleware/middleware_clients.dart';
import 'package:test/test.dart';

class _FakeBookingsFacade implements IBookingsFacade {
  _FakeBookingsFacade({required this.bookings});

  final List<BookingDto> bookings;

  @override
  Future<BookingListDto> loadBookings({required DateTime forDate}) async =>
      BookingListDto(bookings: bookings);

  @override
  Future<BookingListDto> loadBookingsRange({
    required DateTime rangeStart,
    required DateTime rangeEndExclusive,
  }) async =>
      BookingListDto(bookings: bookings);

  @override
  Future<void> createBooking({required CreateBookingDto booking}) async {}

  @override
  Future<void> deleteBooking({required String bookingId}) async {}

  @override
  Future<void> createAdminBookings({required CreateAdminBookingDto dto}) async {}

  @override
  Future<void> deleteBookingAsAdmin({required String bookingId}) async {}

  @override
  Future<void> deleteAllBookingsForDateAsAdmin({required DateTime forDate}) async {}
}

class _CountingFakeBookingsFacade extends _FakeBookingsFacade {
  _CountingFakeBookingsFacade({required super.bookings});

  int rangeCallCount = 0;

  @override
  Future<BookingListDto> loadBookingsRange({
    required DateTime rangeStart,
    required DateTime rangeEndExclusive,
  }) async {
    rangeCallCount++;
    return super.loadBookingsRange(rangeStart: rangeStart, rangeEndExclusive: rangeEndExclusive);
  }
}

void main() {
  test('loadMemberMonth ends in success with memberMonth set', () async {
    final bloc = BookingHeatmapBloc(
      _FakeBookingsFacade(
        bookings: [
          BookingDto.empty().copyWith(
            isMine: true,
            courtNo: 1,
            bookingDate: DateTime.utc(2026, 5, 3, 8, 0),
          ),
        ],
      ),
    );
    bloc.add(BookingHeatmapEvent.loadMemberMonth(anyDateInMonth: DateTime(2026, 5, 15)));
    await bloc.stream.firstWhere((s) => s.status.status == BaseLoadingStatus.loadingSuccess);
    expect(bloc.state.memberMonth, isNotNull);
    expect(bloc.state.memberRolling4Week, isNotNull);
    expect(bloc.state.memberRolling4Week!.dayTotals.length, 28);
    expect(bloc.state.memberMonth!.year, 2026);
    expect(bloc.state.memberMonth!.month, 5);
    expect(bloc.state.adminDayGrid, isNull);
    await bloc.close();
  });

  test('loadMemberMonth skips network when cached snapshot matches month and today', () async {
    final facade = _CountingFakeBookingsFacade(
      bookings: [
        BookingDto.empty().copyWith(
          isMine: true,
          courtNo: 1,
          bookingDate: DateTime.utc(2026, 5, 3, 8, 0),
        ),
      ],
    );
    final bloc = BookingHeatmapBloc(facade);
    final date = DateTime(2026, 5, 15);
    bloc.add(BookingHeatmapEvent.loadMemberMonth(anyDateInMonth: date));
    await bloc.stream.firstWhere((s) => s.status.status == BaseLoadingStatus.loadingSuccess);
    expect(facade.rangeCallCount, 1);

    bloc.add(BookingHeatmapEvent.loadMemberMonth(anyDateInMonth: date));
    // Allow any microtasks from a mistaken second fetch to run.
    await Future<void>.delayed(Duration.zero);
    expect(facade.rangeCallCount, 1);
    await bloc.close();
  });

  test('loadMemberMonth refetches when month changes', () async {
    final facade = _CountingFakeBookingsFacade(bookings: const []);
    final bloc = BookingHeatmapBloc(facade);
    bloc.add(BookingHeatmapEvent.loadMemberMonth(anyDateInMonth: DateTime(2026, 5, 15)));
    await bloc.stream.firstWhere((s) => s.status.status == BaseLoadingStatus.loadingSuccess);
    expect(facade.rangeCallCount, 1);

    bloc.add(BookingHeatmapEvent.loadMemberMonth(anyDateInMonth: DateTime(2026, 6, 1)));
    await bloc.stream.firstWhere((s) =>
        s.status.status == BaseLoadingStatus.loadingSuccess && s.memberMonth?.month == 6);
    expect(facade.rangeCallCount, 2);
    await bloc.close();
  });
}
