part of 'bookings_page.dart';

String _formatBookingDay(DateTime d) {
  const weekdays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
  const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
  return '${weekdays[d.weekday - 1]} ${d.day} ${months[d.month - 1]}';
}

String _formatBookingRange(DateTime start, DateTime end) {
  String t(DateTime d) =>
      '${d.hour.toString().padLeft(2, '0')}:${d.minute.toString().padLeft(2, '0')}';
  return '${t(start)}–${t(end)}';
}
