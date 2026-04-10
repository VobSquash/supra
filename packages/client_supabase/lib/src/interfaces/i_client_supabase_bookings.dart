import '../models/booking_row.dart';

abstract class IClientSupabaseBookings {
  /// [public.bookings] — Parse `Bookings`.
  ///
  /// Returns rows whose [booking_date] falls on the same **calendar day** as
  /// [forDate], using that date’s year/month/day in the **local** timezone
  /// (start inclusive, next day exclusive), then converted to UTC for the query.
  Future<List<BookingRow>> getBookings({required DateTime forDate});
}
