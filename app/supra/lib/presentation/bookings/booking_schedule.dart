import 'package:client_models/client_models.dart';
import 'package:flutter/material.dart';

/// 45-minute court slots: first starts 05:15, last starts 21:45 (ends 22:30).
abstract final class CourtSchedule {
  static const int slotDurationMinutes = 45;
  static const int courtCount = 3;
  static const int firstSlotStartMinutes = 5 * 60 + 15;
  static const int lastSlotStartMinutes = 21 * 60 + 45;

  static List<int> allSlotStartsMinutes() {
    final out = <int>[];
    for (var m = firstSlotStartMinutes; m <= lastSlotStartMinutes; m += slotDurationMinutes) {
      out.add(m);
    }
    return out;
  }

  static List<int> slotStartsForBand(BookingTimeBand band) {
    return allSlotStartsMinutes().where((m) => slotInBand(m, band)).toList();
  }
}

/// Mini-tabs: Peak (default), Afternoon, Morning — labels match product copy.
enum BookingTimeBand {
  peak,
  afternoon,
  morning,
}

extension BookingTimeBandX on BookingTimeBand {
  String get label => switch (this) {
        BookingTimeBand.peak => 'Peak',
        BookingTimeBand.afternoon => 'Afternoon',
        BookingTimeBand.morning => 'Morning',
      };

  String get rangeLabel => switch (this) {
        BookingTimeBand.peak => '14:15–21:45',
        BookingTimeBand.afternoon => '12:00–18:00',
        BookingTimeBand.morning => '05:15–11:15',
      };
}

bool slotInBand(int slotStartMinutes, BookingTimeBand band) {
  switch (band) {
    case BookingTimeBand.peak:
      const s = 14 * 60 + 15;
      const e = 21 * 60 + 45;
      return slotStartMinutes >= s && slotStartMinutes <= e;
    case BookingTimeBand.afternoon:
      const s = 12 * 60;
      const e = 18 * 60;
      return slotStartMinutes >= s && slotStartMinutes < e;
    case BookingTimeBand.morning:
      const s = 5 * 60 + 15;
      const e = 11 * 60 + 15;
      return slotStartMinutes >= s && slotStartMinutes <= e;
  }
}

/// Whether [bookingUtc] falls on the same **calendar day** as [selectedCalendarDay]
/// using **UTC date parts** (y/m/d).
///
/// Bookings in Supabase are `timestamptz`; migrated rows often store the **intended
/// court wall time** with a `+00` offset rather than a shifted UTC instant. Using
/// [DateTime.toLocal] then maps e.g. `20:15+00` to 22:15 in SAST and the wrong row
/// (21:45). Matching on UTC wall clock keeps the grid aligned with stored values.
bool _sameCalendarDayUtc(DateTime bookingUtc, DateTime selectedCalendarDay) {
  final u = bookingUtc.toUtc();
  return u.year == selectedCalendarDay.year &&
      u.month == selectedCalendarDay.month &&
      u.day == selectedCalendarDay.day;
}

/// Maps DB/API [courtNo] to grid columns 1–3 (supports 0-based 0,1,2).
int? courtNoOneBased(int? court) {
  if (court == null) return null;
  if (court >= 1 && court <= CourtSchedule.courtCount) return court;
  if (court >= 0 && court < CourtSchedule.courtCount) return court + 1;
  return null;
}

/// Time-of-day in minutes from midnight (hour/minute only).
int _minutesFromMidnight(int hour, int minute) => hour * 60 + minute;

/// Which schedule row (slot **start** minutes) this booking belongs to.
///
/// Uses [hour] and [minute] as **court schedule wall time** (we pass UTC components
/// from DB — see [_sameCalendarDayUtc]).
///
/// Aligned to **[start, start + 45)** (e.g. 14:30 → 14:15 row).
int? slotStartForWallClock(int hour, int minute) {
  final mins = _minutesFromMidnight(hour, minute);
  final lastWindowEnd = CourtSchedule.lastSlotStartMinutes + CourtSchedule.slotDurationMinutes;
  // Exact end-of-day stamp (e.g. 22:30) still belongs to the last 45‑minute block.
  if (mins == lastWindowEnd) {
    return CourtSchedule.lastSlotStartMinutes;
  }
  if (mins < CourtSchedule.firstSlotStartMinutes || mins > lastWindowEnd) {
    return null;
  }
  for (final s in CourtSchedule.allSlotStartsMinutes()) {
    if (mins >= s && mins < s + CourtSchedule.slotDurationMinutes) {
      return s;
    }
  }
  return null;
}

/// First booking wins per (slot minute, court).
///
/// [bookingDate] is interpreted using **UTC wall-clock** hour/minute and UTC calendar
/// date so it matches how rows are stored after migration (`20:15+00` → 20:15 slot).
Map<(int, int), BookingDto> bookingBySlotAndCourt({
  required List<BookingDto> bookings,
  required DateTime selectedDay,
}) {
  final day = DateTime(selectedDay.year, selectedDay.month, selectedDay.day);
  final map = <(int, int), BookingDto>{};
  for (final b in bookings) {
    final dt = b.bookingDate;
    final courtRaw = b.courtNo;
    if (dt == null) continue;
    final court = courtNoOneBased(courtRaw);
    if (court == null) continue;
    final u = dt.toUtc();
    if (!_sameCalendarDayUtc(u, day)) continue;
    final slotStart = slotStartForWallClock(u.hour, u.minute);
    if (slotStart == null) continue;
    final key = (slotStart, court);
    map.putIfAbsent(key, () => b);
  }
  return map;
}

String formatSlotRangeLabel(int slotStartMinutes) {
  final start = TimeOfDay(hour: slotStartMinutes ~/ 60, minute: slotStartMinutes % 60);
  final endTotal = slotStartMinutes + CourtSchedule.slotDurationMinutes;
  final end = TimeOfDay(hour: endTotal ~/ 60, minute: endTotal % 60);
  String two(TimeOfDay t) =>
      '${t.hour.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(2, '0')}';
  return '${two(start)}–${two(end)}';
}
