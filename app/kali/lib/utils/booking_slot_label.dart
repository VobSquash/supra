import 'package:middleware/middleware_clients.dart';

/// Matches Dupra `formatSlotRangeLabel` (45‑minute slot windows).
String formatSlotRangeLabel(int slotStartMinutes) {
  final duration = BookingSlotSchedule.slotDurationMinutes;
  final endTotal = slotStartMinutes + duration;
  String two(int totalMins) {
    final h = totalMins ~/ 60;
    final m = totalMins % 60;
    return '${h.toString().padLeft(2, '0')}:${m.toString().padLeft(2, '0')}';
  }

  return '${two(slotStartMinutes)}–${two(endTotal)}';
}

String formatCalendarDayHeading(DateTime d) {
  const weekdays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
  const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
  return '${weekdays[d.weekday - DateTime.monday]}, ${months[d.month - 1]} ${d.day}, ${d.year}';
}
