import 'package:dio/dio.dart';

/// Calendar day (year/month/day only).
DateTime adminBookingsCalendarDay(DateTime d) => DateTime(d.year, d.month, d.day);

/// Today’s date (local timezone, no clock).
DateTime adminBookingsCalendarTodayLocal() => adminBookingsCalendarDay(DateTime.now());

/// Encode minutes since midnight as `HH:mm` for admin booking ranges.
String adminBookingsHhmm(int minutesFromMidnight) {
  final h = minutesFromMidnight ~/ 60;
  final m = minutesFromMidnight % 60;
  return '${h.toString().padLeft(2, '0')}:${m.toString().padLeft(2, '0')}';
}

/// Wall-clock hour:minute in UTC (`timestamptz` convention used by slot grid).
String adminBookingsFormatWallUtc(DateTime? d) {
  if (d == null) return '—';
  final u = d.toUtc();
  return '${u.hour.toString().padLeft(2, '0')}:${u.minute.toString().padLeft(2, '0')}';
}

/// Friendly error line for Dio / generic failures (Dupra-aligned).
String adminBookingsAdminErrorMessage(Object error) {
  if (error is DioException) {
    final t = error.error?.toString().trim();
    if (t != null && t.isNotEmpty) return t;
    final m = error.message?.trim();
    if (m != null && m.isNotEmpty) return m;
  }
  final s = error.toString().trim();
  if (s.isNotEmpty && s != 'Exception') return s;
  return 'Request failed.';
}

/// `yyyy-MM-dd` for [InputType.date].
String adminBookingsDateInputValue(DateTime d) {
  final y = d.year.toString().padLeft(4, '0');
  final m = d.month.toString().padLeft(2, '0');
  final day = d.day.toString().padLeft(2, '0');
  return '$y-$m-$day';
}

DateTime? adminBookingsParseDateInput(String? raw) {
  final s = raw?.trim();
  if (s == null || s.isEmpty) return null;
  final parts = s.split('-');
  if (parts.length != 3) return null;
  final y = int.tryParse(parts[0]);
  final m = int.tryParse(parts[1]);
  final d = int.tryParse(parts[2]);
  if (y == null || m == null || d == null) return null;
  return DateTime(y, m, d);
}

/// Normalizes Jaspr/date-input [`HTMLInputElement.valueAsDate`] to the selected calendar day.
///
/// Browser APIs expose the picker’s `yyyy-MM-dd` as a UTC midnight instant. Reading [DateTime.day]
/// in local time can move the calendar day backwards in UTC-negative zones.
DateTime adminCalendarDayFromDatePickerValue(DateTime valueAsDate) {
  final u = valueAsDate.toUtc();
  return DateTime(u.year, u.month, u.day);
}

/// Border / accent hues aligned with Dupra `DupraColors.courtBookedFill` (blue / green / orange).
String adminBookingsCourtAccentClass(int courtNo) {
  if (courtNo == 1) return 'bookings-court-accent-1';
  if (courtNo == 2) return 'bookings-court-accent-2';
  if (courtNo == 3) return 'bookings-court-accent-3';
  return 'bookings-court-accent-0';
}
