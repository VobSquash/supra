/// Mirrors `app/supra/.../booking_schedule.dart` [CourtSchedule] so middleware
/// can expand admin ranges without depending on Flutter.
abstract final class BookingSlotSchedule {
  static const int slotDurationMinutes = 45;
  static const int courtCount = 3;
  static const int firstSlotStartMinutes = 5 * 60 + 15;
  static const int lastSlotStartMinutes = 21 * 60 + 45;

  static List<int> allSlotStartsMinutes() {
    final out = <int>[];
    for (
      var m = firstSlotStartMinutes;
      m <= lastSlotStartMinutes;
      m += slotDurationMinutes
    ) {
      out.add(m);
    }
    return out;
  }

  /// Parses `"HH:mm"` into minutes from midnight; returns null if invalid.
  static int? parseMinutesFromMidnight(String raw) {
    final s = raw.trim();
    final parts = s.split(':');
    if (parts.length != 2) return null;
    final h = int.tryParse(parts[0]);
    final mi = int.tryParse(parts[1]);
    if (h == null || mi == null) return null;
    if (h < 0 || h > 23 || mi < 0 || mi > 59) return null;
    return h * 60 + mi;
  }

  /// Returns true if [minutesFromMidnight] is a valid slot **start** time.
  static bool isValidSlotStartMinutes(int minutesFromMidnight) {
    return allSlotStartsMinutes().contains(minutesFromMidnight);
  }

  /// Inclusive list of slot start minutes between [startMin] and [endMin] (both bounds).
  static List<int> slotStartsInclusive(int startMin, int endMin) {
    if (startMin > endMin) return const [];
    return allSlotStartsMinutes()
        .where((s) => s >= startMin && s <= endMin)
        .toList(growable: false);
  }

  /// UTC [DateTime] for [day] calendar parts + slot start (wall clock in UTC).
  static DateTime utcWallSlot(DateTime day, int slotStartMinutes) {
    final h = slotStartMinutes ~/ 60;
    final m = slotStartMinutes % 60;
    return DateTime.utc(day.year, day.month, day.day, h, m);
  }

  /// Same calendar day as Dupra `booking_schedule._sameCalendarDayUtc`.
  static bool sameCalendarDayUtc(DateTime bookingUtc, DateTime selectedCalendarDay) {
    final u = bookingUtc.toUtc();
    return u.year == selectedCalendarDay.year &&
        u.month == selectedCalendarDay.month &&
        u.day == selectedCalendarDay.day;
  }

  /// Maps DB/API court number to 1–3 (supports 0-based 0,1,2).
  static int? courtNoOneBased(int? court) {
    if (court == null) return null;
    if (court >= 1 && court <= courtCount) return court;
    if (court >= 0 && court < courtCount) return court + 1;
    return null;
  }

  static int _minutesFromMidnight(int hour, int minute) => hour * 60 + minute;

  /// Slot start minutes for UTC wall-clock hour/minute on the 45‑minute grid.
  static int? slotStartForWallClockUtc(int hour, int minute) {
    final mins = _minutesFromMidnight(hour, minute);
    const lastWindowEnd = lastSlotStartMinutes + slotDurationMinutes;
    if (mins == lastWindowEnd) {
      return lastSlotStartMinutes;
    }
    if (mins < firstSlotStartMinutes || mins > lastWindowEnd) {
      return null;
    }
    for (final s in allSlotStartsMinutes()) {
      if (mins >= s && mins < s + slotDurationMinutes) {
        return s;
      }
    }
    return null;
  }
}
