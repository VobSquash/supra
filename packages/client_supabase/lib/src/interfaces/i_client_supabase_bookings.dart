import '../models/booking_with_profile_row.dart';

abstract class IClientSupabaseBookings {
  /// [public.bookings] — Parse `Bookings`, with embedded profile (FK `vob_guid`).
  ///
  /// Returns rows whose [booking_date] falls on the same **calendar day** as
  /// [forDate], using that date’s year/month/day in the **local** timezone
  /// (start inclusive, next day exclusive), then converted to UTC for the query.
  Future<List<BookingWithProfileRow>> getBookings({required DateTime forDate});
}
