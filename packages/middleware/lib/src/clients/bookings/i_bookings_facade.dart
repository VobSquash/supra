import 'package:client_models/client_models.dart';

abstract class IBookingsFacade {
  /// Loads bookings for the calendar day of [forDate] (local date, same rules as Supabase client).
  Future<BookingListDto> loadBookings({required DateTime forDate});

  /// Creates a single booking for a selected court/slot/profile.
  Future<void> createBooking({required CreateBookingDto booking});

  /// Deletes a single booking row by [bookingId] (Supabase `bookings.id`).
  Future<void> deleteBooking({required String bookingId});
}
