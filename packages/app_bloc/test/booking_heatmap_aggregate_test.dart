import 'package:app_bloc/bookings/booking_heatmap_aggregate.dart';
import 'package:client_models/client_models.dart';
import 'package:middleware/middleware_clients.dart';
import 'package:test/test.dart';

void main() {
  test('buildMemberMonth counts only isMine slot rows by court and weekday', () {
    final bookings = [
      BookingDto.empty().copyWith(
        isMine: true,
        courtNo: 1,
        bookingDate: DateTime.utc(2026, 5, 10, 6, 15),
      ),
      BookingDto.empty().copyWith(
        isMine: false,
        courtNo: 1,
        bookingDate: DateTime.utc(2026, 5, 10, 7, 0),
      ),
    ];
    final m = BookingHeatmapAggregate.buildMemberMonth(bookings: bookings, year: 2026, month: 5);
    final may10 = DateTime(2026, 5, 10);
    final weekdayMonday0 = may10.weekday - DateTime.monday;
    expect(m.courtWeekdayCounts[0][weekdayMonday0], 1);
    expect(m.courtWeekdayCounts[1].every((n) => n == 0), isTrue);
    expect(m.courtWeekdayCounts[2].every((n) => n == 0), isTrue);
  });

  test('buildMemberRolling4Week totals mine slots per day across courts', () {
    final anchor = DateTime(2026, 5, 15);
    final bookings = [
      BookingDto.empty().copyWith(
        isMine: true,
        courtNo: 1,
        bookingDate: DateTime.utc(2026, 5, 15, 6, 15),
      ),
      BookingDto.empty().copyWith(
        isMine: true,
        courtNo: 2,
        bookingDate: DateTime.utc(2026, 5, 15, 7, 0),
      ),
      BookingDto.empty().copyWith(
        isMine: false,
        courtNo: 1,
        bookingDate: DateTime.utc(2026, 5, 15, 8, 0),
      ),
    ];
    final r = BookingHeatmapAggregate.buildMemberRolling4Week(bookings: bookings, anchorToday: anchor);
    expect(r.dayTotals[27], 2);
    expect(r.dayTotals.where((n) => n > 0).length, 1);
  });

  test('buildAdminDaySlotGrid marks two distinct slots on same court', () {
    final day = DateTime(2026, 5, 12);
    final bookings = [
      BookingDto.empty().copyWith(
        courtNo: 1,
        displayName: 'Pat Q',
        bookingDate: DateTime.utc(2026, 5, 12, 6, 15),
      ),
      BookingDto.empty().copyWith(
        courtNo: 1,
        displayName: 'Sam R',
        bookingDate: DateTime.utc(2026, 5, 12, 7, 0),
      ),
    ];
    final g = BookingHeatmapAggregate.buildAdminDaySlotGrid(bookings: bookings, forDay: day);
    final slots = BookingSlotSchedule.allSlotStartsMinutes();
    /// 6:15 → 6:00–6:45 block; 7:00 → 6:45–7:30 block
    final idx600 = slots.indexOf(6 * 60 + 0);
    final idx645 = slots.indexOf(6 * 60 + 45);
    expect(idx600 >= 0, isTrue);
    expect(idx645 >= 0, isTrue);
    expect(g.occupantLabels[0][idx600], 'Pat Q');
    expect(g.occupantLabels[0][idx645], 'Sam R');
    expect(g.occupantLabels[1].every((o) => o == null), isTrue);
  });
}
