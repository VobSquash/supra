import 'package:client_models/client_models.dart';
import 'package:middleware/middleware_clients.dart';

/// Mini-tabs: Peak (default), Afternoon, Morning — aligned with Dupra [`BookingTimeBand`].
enum MemberBookingTimeBand {
  peak,
  afternoon,
  morning,
}

extension MemberBookingTimeBandX on MemberBookingTimeBand {
  String get label => switch (this) {
    MemberBookingTimeBand.peak => 'Peak',
    MemberBookingTimeBand.afternoon => 'Afternoon',
    MemberBookingTimeBand.morning => 'Morning',
  };

  String get rangeLabel => switch (this) {
    MemberBookingTimeBand.peak => '14:15–21:45',
    MemberBookingTimeBand.afternoon => '12:00–18:00',
    MemberBookingTimeBand.morning => '05:15–11:15',
  };
}

bool memberSlotInBand(int slotStartMinutes, MemberBookingTimeBand band) {
  switch (band) {
    case MemberBookingTimeBand.peak:
      const s = 14 * 60 + 15;
      const e = 21 * 60 + 45;
      return slotStartMinutes >= s && slotStartMinutes <= e;
    case MemberBookingTimeBand.afternoon:
      const s = 12 * 60;
      const e = 18 * 60;
      return slotStartMinutes >= s && slotStartMinutes < e;
    case MemberBookingTimeBand.morning:
      const s = 5 * 60 + 15;
      const e = 11 * 60 + 15;
      return slotStartMinutes >= s && slotStartMinutes <= e;
  }
}

List<int> memberSlotStartsForBand(MemberBookingTimeBand band) {
  return BookingSlotSchedule.allSlotStartsMinutes().where((m) => memberSlotInBand(m, band)).toList();
}

/// First booking wins per (slot minute, court). Dupra-aligned UTC wall-clock + calendar day matching.
Map<(int, int), BookingDto> memberBookingBySlotAndCourt({
  required List<BookingDto> bookings,
  required DateTime selectedDay,
}) {
  final day = DateTime(selectedDay.year, selectedDay.month, selectedDay.day);
  final map = <(int, int), BookingDto>{};
  for (final b in bookings) {
    final dt = b.bookingDate;
    final courtRaw = b.courtNo;
    if (dt == null) continue;
    final court = BookingSlotSchedule.courtNoOneBased(courtRaw);
    if (court == null) continue;
    final u = dt.toUtc();
    if (!BookingSlotSchedule.sameCalendarDayUtc(u, day)) continue;
    final slotStart = BookingSlotSchedule.slotStartForWallClockUtc(u.hour, u.minute);
    if (slotStart == null) continue;
    final key = (slotStart, court);
    map.putIfAbsent(key, () => b);
  }
  return map;
}
