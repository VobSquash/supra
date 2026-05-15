/// Local-calendar day strip (year/month/day only).
DateTime adminBookingsCalendarDay(DateTime d) => DateTime(d.year, d.month, d.day);

/// Today in local timezone as a calendar date (no time-of-day).
DateTime adminBookingsCalendarTodayLocal() => adminBookingsCalendarDay(DateTime.now());

/// `HH:mm` from minutes since midnight (API encoding for admin booking ranges).
String adminBookingsHhmm(int minutesFromMidnight) {
  final h = minutesFromMidnight ~/ 60;
  final m = minutesFromMidnight % 60;
  return '${h.toString().padLeft(2, '0')}:${m.toString().padLeft(2, '0')}';
}

/// UTC wall clock hour:minute for list subtitles (aligned with stored `timestamptz` convention).
String adminBookingsFormatWallUtc(DateTime? d) {
  if (d == null) return '—';
  final u = d.toUtc();
  return '${u.hour.toString().padLeft(2, '0')}:${u.minute.toString().padLeft(2, '0')}';
}
