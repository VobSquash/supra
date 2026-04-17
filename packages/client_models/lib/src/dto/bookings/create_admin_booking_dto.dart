import 'package:meta/meta.dart';

/// Admin / fixture block booking: expands to one DB row per court × timeslot.
///
/// [timeslotStart] / [timeslotEnd] are `HH:mm` strings on the same 45-minute
/// slot grid as the main bookings UI (first slot starts 05:15, UTC wall clock).
@immutable
class CreateAdminBookingDto {
  const CreateAdminBookingDto({
    required this.bookingTitle,
    required this.selectedDate,
    required this.timeslotStart,
    required this.timeslotEnd,
    required this.court1,
    required this.court2,
    required this.court3,
  });

  final String bookingTitle;
  final DateTime selectedDate;

  /// e.g. `"05:15"`
  final String timeslotStart;

  /// e.g. `"21:45"` — last slot **start** included in the range (inclusive).
  final String timeslotEnd;

  final bool court1;
  final bool court2;
  final bool court3;
}
