import 'package:app_bloc/base/base_bloc.dart';
import 'package:app_bloc/bookings/booking_heatmap_aggregate.dart';
import 'package:client_models/client_models.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:middleware/middleware_clients.dart';

part 'booking_heatmap_bloc.freezed.dart';
part 'booking_heatmap_events.dart';
part 'booking_heatmap_state.dart';

bool _sameCalendarDay(DateTime a, DateTime b) =>
    a.year == b.year && a.month == b.month && a.day == b.day;

/// Loads bookings for a **range** and builds heat-map payloads for home/overview UIs.
@injectable
class BookingHeatmapBloc extends BaseBloc<BookingHeatmapEvent, BookingHeatmapState> {
  BookingHeatmapBloc(this._facade) : super(initialState1: BookingHeatmapState.initial()) {
    on<BookingHeatmapEvent>((event, emit) async {
      await event.map(
        loadMemberMonth: (e) async {
          final y = e.anyDateInMonth.year;
          final m = e.anyDateInMonth.month;
          final monthStart = DateTime(y, m, 1);
          final monthEndExclusive = DateTime(y, m + 1, 1);
          final now = DateTime.now();
          final today = DateTime(now.year, now.month, now.day);
          final rollingStart = today.subtract(const Duration(days: 27));
          final rollingEndExclusive = today.add(const Duration(days: 1));
          final rangeStart = monthStart.isBefore(rollingStart) ? monthStart : rollingStart;
          final rangeEndExclusive =
              monthEndExclusive.isAfter(rollingEndExclusive) ? monthEndExclusive : rollingEndExclusive;

          final cachedMonth = state.memberMonth;
          final cachedRolling = state.memberRolling4Week;
          if (cachedMonth != null &&
              cachedRolling != null &&
              cachedMonth.year == y &&
              cachedMonth.month == m &&
              _sameCalendarDay(cachedRolling.anchorToday, today) &&
              state.status.status == BaseLoadingStatus.loadingSuccess) {
            return;
          }

          await handleLoadingState<BookingListDto>(
            emit,
            initialState: BookingHeatmapState(
              status: BaseLoading.initial(),
              mode: BookingHeatmapMode.member,
              memberMonth: null,
              memberRolling4Week: null,
              adminDayGrid: null,
            ),
            onLoading: () => state.copyWith(
              status: BaseLoading.loading(),
              mode: BookingHeatmapMode.member,
              memberMonth: null,
              memberRolling4Week: null,
              adminDayGrid: null,
            ),
            action: () => _facade.loadBookingsRange(
              rangeStart: rangeStart,
              rangeEndExclusive: rangeEndExclusive,
            ),
            onSuccess: (result) => state.copyWith(
              status: BaseLoading.success(),
              mode: BookingHeatmapMode.member,
              memberMonth: BookingHeatmapAggregate.buildMemberMonth(
                bookings: result?.bookings ?? const [],
                year: y,
                month: m,
              ),
              memberRolling4Week: BookingHeatmapAggregate.buildMemberRolling4Week(
                bookings: result?.bookings ?? const [],
                anchorToday: today,
              ),
              adminDayGrid: null,
            ),
            onError: (error) => state.copyWith(
              status: BaseLoading.error(error),
              memberMonth: null,
              memberRolling4Week: null,
              adminDayGrid: null,
            ),
          );
        },
        loadAdminDay: (e) async {
          final d = DateTime(e.forDay.year, e.forDay.month, e.forDay.day);
          final endExclusive = d.add(const Duration(days: 1));
          await handleLoadingState<BookingListDto>(
            emit,
            initialState: BookingHeatmapState(
              status: BaseLoading.initial(),
              mode: BookingHeatmapMode.admin,
              memberMonth: null,
              memberRolling4Week: null,
              adminDayGrid: null,
            ),
            onLoading: () => state.copyWith(
              status: BaseLoading.loading(),
              mode: BookingHeatmapMode.admin,
              memberMonth: null,
              memberRolling4Week: null,
              adminDayGrid: null,
            ),
            action: () => _facade.loadBookingsRange(
              rangeStart: d,
              rangeEndExclusive: endExclusive,
            ),
            onSuccess: (result) => state.copyWith(
              status: BaseLoading.success(),
              mode: BookingHeatmapMode.admin,
              memberMonth: null,
              memberRolling4Week: null,
              adminDayGrid: BookingHeatmapAggregate.buildAdminDaySlotGrid(
                bookings: result?.bookings ?? const [],
                forDay: e.forDay,
              ),
            ),
            onError: (error) => state.copyWith(
              status: BaseLoading.error(error),
              memberMonth: null,
              memberRolling4Week: null,
              adminDayGrid: null,
            ),
          );
        },
      );
    });
  }

  final IBookingsFacade _facade;
}
