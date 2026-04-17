import 'package:app_bloc/base/base_bloc.dart';
import 'package:client_models/client_models.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:middleware/middleware_clients.dart';

part 'bookings_bloc.freezed.dart';
part 'bookings_events.dart';
part 'bookings_state.dart';

DateTime _calendarDay(DateTime d) => DateTime(d.year, d.month, d.day);

/// Loads [BookingDto] rows for a selected day via [IBookingsFacade].
@injectable
class BookingsBloc extends BaseBloc<BookingsEvent, BookingsState> {
  BookingsBloc(this._facade) : super(initialState1: BookingsState.initial()) {
    on<BookingsEvent>((event, emit) async {
      await event.map(
        onLoadBookings: (e) async {
          final day = _calendarDay(e.forDate);
          await handleLoadingState<BookingListDto>(
            emit,
            initialState: BookingsState(
              selectedDate: day,
              bookings: const [],
              status: BaseLoading.initial(),
            ),
            onLoading: () => state.copyWith(
              selectedDate: day,
              bookings: const [],
              status: BaseLoading.loading(),
            ),
            action: () => _facade.loadBookings(forDate: day),
            onSuccess: (result) => state.copyWith(
              selectedDate: day,
              bookings: result?.bookings ?? const [],
              status: BaseLoading.success(),
            ),
            onError: (error) => state.copyWith(
              bookings: const [],
              status: BaseLoading.error(
                error ?? 'Unknown error while loading bookings',
              ),
            ),
          );
        },
        onResetBookings: (_) async {
          emit(BookingsState.initial());
        },
      );
    });
  }

  final IBookingsFacade _facade;

  Future<void> createBooking({required CreateBookingDto booking}) {
    return _facade.createBooking(booking: booking);
  }

  Future<void> deleteBooking({required String bookingId}) {
    return _facade.deleteBooking(bookingId: bookingId);
  }
}
