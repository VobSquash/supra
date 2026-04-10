import 'package:client_models/client_models.dart';

abstract class IBookingsFacade {
  /// Loads bookings for the calendar day of [forDate] (local date, same rules as Supabase client).
  Future<BookingListDto> loadBookings({required DateTime forDate});
}
