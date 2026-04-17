import 'package:client_models/client_models.dart';
import 'package:client_supabase/client_supabase.dart';

/// Joins a [BookingRow] with the resolved [BasicProfileDTO] for AutoMappr.
class BookingWithProfile {
  const BookingWithProfile({
    required this.booking,
    this.profile,
    this.currentUserVobGuid,
  });

  final BookingRow booking;
  final BasicProfileDTO? profile;

  /// Session member id; used to compute [BookingDto.isMine].
  final String? currentUserVobGuid;
}
