import 'package:client_models/client_models.dart';
import 'package:client_supabase/client_supabase.dart';
import 'package:injectable/injectable.dart';
import 'package:middleware/src/clients/bookings/i_bookings_facade.dart';
import 'package:middleware/src/injection.dart';
import 'package:middleware/src/mappers/bookings/booking_with_profile.dart';
import 'package:middleware/src/mappers/bookings/supabase_booking_mapper.dart';
import 'package:middleware/src/mappers/profiles/supabase_profile_mapper.dart';
import 'package:session_storage/session_storage.dart';

@LazySingleton(as: IBookingsFacade)
class BookingsFacade implements IBookingsFacade {
  BookingsFacade();

  IClientSupabase get _client => middlewareSl<IClientSupabase>();

  static const _mapper = SupabaseBookingMapper();

  @override
  Future<BookingListDto> loadBookings({required DateTime forDate}) async {
    final bookingRows = await _client.bookings.getBookings(forDate: forDate);
    const profileMapper = SupabaseProfileMapper();
    final session = await middlewareSl<SessionStore>().read();
    final currentUserVobGuid = session?.vobGuid?.trim();

    final items = <BookingDto>[];
    for (final row in bookingRows) {
      final prof = row.profile != null
          ? profileMapper.convert<ProfileFull, BasicProfileDTO>(row.profile!)
          : null;
      items.add(
        _mapper.convert<BookingWithProfile, BookingDto>(
          BookingWithProfile(
            booking: row.booking,
            profile: prof,
            currentUserVobGuid: currentUserVobGuid,
          ),
        ),
      );
    }

    items.sort((a, b) {
      final da = a.bookingDate;
      final db = b.bookingDate;
      if (da == null && db == null) return 0;
      if (da == null) return 1;
      if (db == null) return -1;
      final c = da.compareTo(db);
      if (c != 0) return c;
      final ca = a.courtNo ?? 0;
      final cb = b.courtNo ?? 0;
      return ca.compareTo(cb);
    });

    return BookingListDto(bookings: items);
  }

  @override
  Future<void> createBooking({required CreateBookingDto booking}) async {
    final context = await _resolveBookingContext(booking);
    if (context == null) {
      throw StateError(
        'Unable to create booking: no vob_guid found in current session.',
      );
    }
    await _client.bookings.createBooking(
      booking: CreateBookingDto(
        courtNo: booking.courtNo,
        bookingDate: booking.bookingDate,
        vobGuid: context.vobGuid,
        displayName: context.displayName,
        groupBookingId: 0,
        legacyObjectId: '',
      ),
    );
  }

  @override
  Future<void> deleteBooking({required String bookingId}) async {
    final id = bookingId.trim();
    if (id.isEmpty) {
      throw ArgumentError('bookingId must not be empty');
    }
    await _client.bookings.deleteBooking(bookingId: id);
  }

  Future<_BookingCreateContext?> _resolveBookingContext(
    CreateBookingDto booking,
  ) async {
    final session = await middlewareSl<SessionStore>().read();
    final explicitGuid = booking.vobGuid?.trim();
    final fromSessionGuid = session?.vobGuid?.trim();
    final guid = (explicitGuid != null && explicitGuid.isNotEmpty)
        ? explicitGuid
        : ((fromSessionGuid != null && fromSessionGuid.isNotEmpty)
              ? fromSessionGuid
              : null);
    final sessionName = session?.displayName?.trim();
    final explicitName = booking.displayName?.trim();
    if (guid != null) {
      final profileByGuid = await _client.profiles.getByVobGuid(guid);
      final profileName = _profileDisplayName(profileByGuid);
      return _BookingCreateContext(
        vobGuid: guid,
        displayName: _firstNonEmpty(explicitName, profileName, sessionName),
      );
    }

    final email = session?.email?.trim();
    if (email != null && email.isNotEmpty) {
      final profile = await _client.profiles.getByEmail(email);
      final fromProfile = profile?.profile.vobGuid?.trim();
      if (fromProfile != null && fromProfile.isNotEmpty) {
        return _BookingCreateContext(
          vobGuid: fromProfile,
          displayName: _firstNonEmpty(
            explicitName,
            _profileDisplayName(profile),
            sessionName,
          ),
        );
      }
    }
    return null;
  }
}

String? _profileDisplayName(ProfileFull? profile) {
  if (profile == null) return null;
  final first = profile.profile.firstName?.trim();
  final last = profile.profile.lastName?.trim();
  final full = [
    if (first != null && first.isNotEmpty) first,
    if (last != null && last.isNotEmpty) last,
  ].join(' ');
  if (full.isNotEmpty) return full;
  return null;
}

String? _firstNonEmpty(String? a, String? b, String? c) {
  for (final value in [a, b, c]) {
    final trimmed = value?.trim();
    if (trimmed != null && trimmed.isNotEmpty) {
      return trimmed;
    }
  }
  return null;
}

class _BookingCreateContext {
  const _BookingCreateContext({required this.vobGuid, this.displayName});

  final String vobGuid;
  final String? displayName;
}
