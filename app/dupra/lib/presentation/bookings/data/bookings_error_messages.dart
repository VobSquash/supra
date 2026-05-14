import 'package:dio/dio.dart';

/// Maps API / network errors surfaced by bloc facade calls into user-facing copy.
abstract final class BookingsErrorMessages {
  static String deleteBooking(Object error) {
    if (error is DioException) {
      final text = error.error?.toString().trim();
      if (text != null && text.isNotEmpty) return text;
      final message = error.message?.trim();
      if (message != null && message.isNotEmpty) return message;
    }
    final raw = error.toString().trim();
    if (raw.isNotEmpty && raw != 'Exception') return raw;
    return 'Unable to delete this booking.';
  }

  static String createBooking(Object error) {
    if (error is DioException) {
      final text = error.error?.toString().trim();
      if (text != null &&
          (text.contains('bookings_slot_unique_idx') ||
              text.contains('already booked') ||
              text.contains('already exists'))) {
        return 'That slot is already booked.';
      }
      if (text != null && text.contains('already have a booking for this day')) {
        return 'You already have a booking for this day.';
      }
      if (text != null && text.isNotEmpty) return text;
      final message = error.message?.trim();
      if (message != null && message.isNotEmpty) return message;
    }
    final raw = error.toString().trim();
    if (raw.isNotEmpty && raw != 'Exception') return raw;
    return 'Unable to create booking for this slot.';
  }
}
