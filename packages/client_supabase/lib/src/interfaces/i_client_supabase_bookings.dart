import '../models/booking_with_profile_row.dart';
import 'package:client_models/client_models.dart';

abstract class IClientSupabaseBookings {
  /// [public.bookings] — Parse `Bookings`, with embedded profile (FK `vob_guid`).
  ///
  /// Returns rows whose [booking_date] falls on the same **calendar day** as
  /// [forDate], using that date’s year/month/day in the **local** timezone
  /// (start inclusive, next day exclusive), then converted to UTC for the query.
  Future<List<BookingWithProfileRow>> getBookings({required DateTime forDate});

  /// Half-open local range: each row whose `booking_date` is
  /// `>= rangeStartLocal (midnight)` and `< rangeEndExclusiveLocal (midnight)`, UTC query bounds.
  Future<List<BookingWithProfileRow>> getBookingsInRange({
    required DateTime rangeStartLocal,
    required DateTime rangeEndExclusiveLocal,
  });

  /// Creates a booking row in `public.bookings`.
  Future<void> createBooking({required CreateBookingDto booking});

  /// Deletes a single row by primary key `id`.
  Future<void> deleteBooking({required String bookingId});

  /// Largest existing `group_booking_id` for admin rows (`> 0`), or `0` if none.
  Future<int> fetchMaxGroupBookingId();
}
