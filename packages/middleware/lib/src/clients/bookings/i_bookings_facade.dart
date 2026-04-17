import 'package:client_models/client_models.dart';

abstract class IBookingsFacade {
  /// Loads bookings for the calendar day of [forDate] (local date, same rules as Supabase client).
  Future<BookingListDto> loadBookings({required DateTime forDate});

  /// Creates a single booking for a selected court/slot/profile.
  Future<void> createBooking({required CreateBookingDto booking});

  /// Deletes a single booking row by [bookingId] (Supabase `bookings.id`).
  Future<void> deleteBooking({required String bookingId});

  /// Admin: creates one row per selected court × slot in [dto] range; assigns next
  /// `group_booking_id` and fails if any slot is already occupied (member or admin).
  Future<void> createAdminBookings({required CreateAdminBookingDto dto});

  /// Admin: delete one row — same HTTP as [deleteBooking]; requires RLS that allows admins.
  Future<void> deleteBookingAsAdmin({required String bookingId});

  /// Admin: deletes every booking on the calendar day of [forDate] (local date).
  Future<void> deleteAllBookingsForDateAsAdmin({required DateTime forDate});
}
