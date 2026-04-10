import 'package:client_models/client_models.dart';
import 'package:client_supabase/client_supabase.dart';

/// Joins a [BookingRow] with the resolved [BasicProfileDTO] for AutoMappr.
class BookingWithProfile {
  const BookingWithProfile({
    required this.booking,
    this.profile,
  });

  final BookingRow booking;
  final BasicProfileDTO? profile;
}
