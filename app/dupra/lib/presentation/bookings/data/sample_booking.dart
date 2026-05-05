/// Presentation models for the bookings route (not domain/API DTOs).
enum BookingStatusKind {
  confirmed,
  pending,
  cancelled,
}

class SampleBooking {
  const SampleBooking({
    required this.courtLabel,
    required this.start,
    required this.end,
    required this.organizer,
    required this.statusLabel,
    required this.statusKind,
  });

  final String courtLabel;
  final DateTime start;
  final DateTime end;
  final String organizer;
  final String statusLabel;
  final BookingStatusKind statusKind;
}
