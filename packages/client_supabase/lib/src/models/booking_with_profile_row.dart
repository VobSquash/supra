import 'booking_row.dart';
import 'profile_full.dart';

/// One booking row from PostgREST with embedded `profiles(*,profile_extensions(*))`.
class BookingWithProfileRow {
  const BookingWithProfileRow({
    required this.booking,
    this.profile,
  });

  final BookingRow booking;
  final ProfileFull? profile;

  factory BookingWithProfileRow.fromPostgrestJson(Map<String, dynamic> json) {
    final raw = json['profiles'];
    ProfileFull? profile;
    if (raw is Map<String, dynamic>) {
      profile = ProfileFull.fromPostgrestJson(raw);
    }
    return BookingWithProfileRow(
      booking: BookingRow.fromJson(json),
      profile: profile,
    );
  }
}
