import 'package:client_models/client_models.dart';
import 'package:middleware/middleware_clients.dart';

/// Member month heat-map: [courtWeekdayCounts] is indexed
/// [courtIndex 0..courtCount-1][weekdayIndex 0..6] where weekday 0 = Monday.
/// Each cell is the number of **your** slot rows in that month on that weekday on that court
/// (e.g. all Tuesdays in May on court 2 summed).
final class BookingHeatmapMemberMonth {
  const BookingHeatmapMemberMonth({
    required this.year,
    required this.month,
    required this.courtWeekdayCounts,
  });

  final int year;
  final int month;
  final List<List<int>> courtWeekdayCounts;
}

/// Exactly 28 consecutive calendar days ending on [anchorToday] (date-only);
/// [dayTotals[i]] is your total slot count on day (anchorToday − 27 + i), any court.
final class BookingHeatmapMemberRolling4Week {
  const BookingHeatmapMemberRolling4Week({
    required this.anchorToday,
    required this.dayTotals,
  });

  final DateTime anchorToday;
  final List<int> dayTotals;
}

/// Admin: one calendar day, all schedule slots as columns, courts as rows.
/// [slotStartMinutes] matches indices in [occupantLabels][court][slot].
/// `occupantLabels[c][s] == null` means free; otherwise holds the booking holder label for tooltips.
final class BookingHeatmapAdminDayGrid {
  const BookingHeatmapAdminDayGrid({
    required this.day,
    required this.slotStartMinutes,
    required this.occupantLabels,
  });

  final DateTime day;
  final List<int> slotStartMinutes;
  final List<List<String?>> occupantLabels;
}

abstract final class BookingHeatmapAggregate {
  static DateTime? _slotEventDayKey(BookingDto b) {
    final dt = b.bookingDate;
    if (dt == null) return null;
    if (BookingSlotSchedule.courtNoOneBased(b.courtNo) == null) return null;
    final u = dt.toUtc();
    if (BookingSlotSchedule.slotStartForWallClockUtc(u.hour, u.minute) == null) {
      return null;
    }
    return DateTime(u.year, u.month, u.day);
  }

  static bool _isSlotEvent(BookingDto b) => _slotEventDayKey(b) != null;

  static BookingHeatmapMemberMonth buildMemberMonth({
    required List<BookingDto> bookings,
    required int year,
    required int month,
  }) {
    final grid = List.generate(
      BookingSlotSchedule.courtCount,
      (_) => List<int>.filled(7, 0, growable: false),
    );
    for (final b in bookings) {
      if (!b.isMine) continue;
      final key = _slotEventDayKey(b);
      if (key == null) continue;
      if (key.year != year || key.month != month) continue;
      final court = BookingSlotSchedule.courtNoOneBased(b.courtNo);
      if (court == null) continue;
      final localDay = DateTime(key.year, key.month, key.day);
      final weekdayMonday0 = localDay.weekday - DateTime.monday;
      grid[court - 1][weekdayMonday0]++;
    }

    return BookingHeatmapMemberMonth(
      year: year,
      month: month,
      courtWeekdayCounts: grid,
    );
  }

  /// Last 28 calendar days ending on [anchorToday] (inclusive); each total is **mine** slots that day (any court).
  static BookingHeatmapMemberRolling4Week buildMemberRolling4Week({
    required List<BookingDto> bookings,
    required DateTime anchorToday,
  }) {
    final today = DateTime(anchorToday.year, anchorToday.month, anchorToday.day);
    final firstDay = today.subtract(const Duration(days: 27));
    final totals = List<int>.filled(28, 0, growable: false);
    for (final b in bookings) {
      if (!b.isMine) continue;
      final key = _slotEventDayKey(b);
      if (key == null) continue;
      final keyDay = DateTime(key.year, key.month, key.day);
      final offset = keyDay.difference(firstDay).inDays;
      if (offset < 0 || offset > 27) continue;
      totals[offset]++;
    }
    return BookingHeatmapMemberRolling4Week(anchorToday: today, dayTotals: totals);
  }

  /// All bookings for [forDay]’s calendar day (local y/m/d); typically pass a one-day fetch.
  static BookingHeatmapAdminDayGrid buildAdminDaySlotGrid({
    required List<BookingDto> bookings,
    required DateTime forDay,
  }) {
    String labelFor(BookingDto b) {
      final direct = b.displayName?.trim();
      if (direct != null && direct.isNotEmpty) return direct;
      final p = b.profile;
      if (p != null) {
        final fromProfile = p.displayName.trim();
        if (fromProfile.isNotEmpty) return fromProfile;
      }
      return 'Unknown member';
    }

    final day = DateTime(forDay.year, forDay.month, forDay.day);
    final slots = BookingSlotSchedule.allSlotStartsMinutes();
    final grid = List.generate(
      BookingSlotSchedule.courtCount,
      (_) => List<String?>.filled(slots.length, null, growable: false),
    );

    for (final b in bookings) {
      if (!_isSlotEvent(b)) continue;
      final k = _slotEventDayKey(b);
      if (k == null) continue;
      if (k.year != day.year || k.month != day.month || k.day != day.day) continue;
      final court = BookingSlotSchedule.courtNoOneBased(b.courtNo);
      if (court == null) continue;
      final u = b.bookingDate!.toUtc();
      final slotStart = BookingSlotSchedule.slotStartForWallClockUtc(u.hour, u.minute);
      if (slotStart == null) continue;
      final slotIdx = slots.indexOf(slotStart);
      if (slotIdx < 0) continue;
      final ci = court - 1;
      final next = labelFor(b);
      final existing = grid[ci][slotIdx];
      grid[ci][slotIdx] = existing == null
          ? next
          : existing == next
              ? existing
              : '$existing, $next';
    }

    return BookingHeatmapAdminDayGrid(day: day, slotStartMinutes: slots, occupantLabels: grid);
  }
}
