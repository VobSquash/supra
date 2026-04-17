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
}
