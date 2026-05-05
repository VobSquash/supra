import 'package:dupra/presentation/bookings/data/sample_booking.dart';

/// Placeholder list until bookings are loaded from the API.
final kSampleBookings = <SampleBooking>[
  SampleBooking(
    courtLabel: 'Court 3',
    start: DateTime(2026, 5, 4, 10),
    end: DateTime(2026, 5, 4, 11, 30),
    organizer: 'You',
    statusLabel: 'Confirmed',
    statusKind: BookingStatusKind.confirmed,
  ),
  SampleBooking(
    courtLabel: 'Court 1',
    start: DateTime(2026, 5, 4, 18),
    end: DateTime(2026, 5, 4, 19),
    organizer: 'Club ladder',
    statusLabel: 'Pending',
    statusKind: BookingStatusKind.pending,
  ),
  SampleBooking(
    courtLabel: 'Court 2',
    start: DateTime(2026, 5, 4, 12, 30),
    end: DateTime(2026, 5, 4, 14),
    organizer: 'Social doubles',
    statusLabel: 'Confirmed',
    statusKind: BookingStatusKind.confirmed,
  ),
  SampleBooking(
    courtLabel: 'Court 4',
    start: DateTime(2026, 5, 4, 9),
    end: DateTime(2026, 5, 4, 10),
    organizer: 'Coaching',
    statusLabel: 'Cancelled',
    statusKind: BookingStatusKind.cancelled,
  ),
];
