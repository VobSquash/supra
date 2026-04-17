import 'package:client_models/client_models.dart';
import 'package:client_supabase/client_supabase.dart';
import 'package:injectable/injectable.dart';
import 'package:middleware/src/clients/bookings/booking_slot_schedule.dart';
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

  @override
  Future<void> createAdminBookings({required CreateAdminBookingDto dto}) async {
    final title = dto.bookingTitle.trim();
    if (title.isEmpty) {
      throw ArgumentError('bookingTitle must not be empty');
    }

    final courts = <int>[
      if (dto.court1) 1,
      if (dto.court2) 2,
      if (dto.court3) 3,
    ];
    if (courts.isEmpty) {
      throw ArgumentError('Select at least one court');
    }

    final startMin = BookingSlotSchedule.parseMinutesFromMidnight(
      dto.timeslotStart,
    );
    final endMin = BookingSlotSchedule.parseMinutesFromMidnight(
      dto.timeslotEnd,
    );
    if (startMin == null || endMin == null) {
      throw ArgumentError('timeslotStart and timeslotEnd must be HH:mm');
    }
    if (!BookingSlotSchedule.isValidSlotStartMinutes(startMin) ||
        !BookingSlotSchedule.isValidSlotStartMinutes(endMin)) {
      throw ArgumentError(
        'Start and end must align to slot boundaries (45-minute grid, first 05:15).',
      );
    }

    final slotStarts = BookingSlotSchedule.slotStartsInclusive(
      startMin,
      endMin,
    );
    if (slotStarts.isEmpty) {
      throw ArgumentError('No slots in the requested time range');
    }

    final day = DateTime(
      dto.selectedDate.year,
      dto.selectedDate.month,
      dto.selectedDate.day,
    );
    final existing = await loadBookings(forDate: day);
    final existingRows = existing.bookings ?? const <BookingDto>[];

    final groupId = (await _client.bookings.fetchMaxGroupBookingId()) + 1;

    final firstSlotUtc = BookingSlotSchedule.utcWallSlot(day, slotStarts.first);
    final memberContext = await _resolveBookingContext(
      CreateBookingDto(
        courtNo: courts.first,
        bookingDate: firstSlotUtc,
        displayName: title,
      ),
    );
    if (memberContext == null) {
      throw StateError(
        'Unable to create admin booking: no vob_guid found for current session.',
      );
    }

    for (final court in courts) {
      for (final slotMin in slotStarts) {
        final slotUtc = BookingSlotSchedule.utcWallSlot(day, slotMin);
        for (final b in existingRows) {
          if (_bookingMatchesSlot(b, court, slotUtc)) {
            final kind = _isGeneralMemberBooking(b) ? 'member' : 'existing';
            throw StateError(
              'Slot already booked ($kind): court $court at ${slotUtc.toIso8601String()}',
            );
          }
        }
      }
    }

    for (final court in courts) {
      for (final slotMin in slotStarts) {
        final slotUtc = BookingSlotSchedule.utcWallSlot(day, slotMin);
        await _client.bookings.createBooking(
          booking: CreateBookingDto(
            courtNo: court,
            bookingDate: slotUtc,
            vobGuid: memberContext.vobGuid,
            displayName: title,
            groupBookingId: groupId,
            legacyObjectId: '',
          ),
        );
      }
    }
  }

  @override
  Future<void> deleteBookingAsAdmin({required String bookingId}) async {
    final id = bookingId.trim();
    if (id.isEmpty) {
      throw ArgumentError('bookingId must not be empty');
    }
    await _client.bookings.deleteBooking(bookingId: id);
  }

  @override
  Future<void> deleteAllBookingsForDateAsAdmin({
    required DateTime forDate,
  }) async {
    final day = DateTime(forDate.year, forDate.month, forDate.day);
    final list = await loadBookings(forDate: day);
    final rows = list.bookings ?? const <BookingDto>[];
    for (final b in rows) {
      final id = b.objectId?.trim();
      if (id == null || id.isEmpty) continue;
      await _client.bookings.deleteBooking(bookingId: id);
    }
  }

  static bool _bookingMatchesSlot(BookingDto b, int court, DateTime slotUtc) {
    if ((b.courtNo ?? -1) != court) return false;
    final d = b.bookingDate?.toUtc();
    if (d == null) return false;
    return d.year == slotUtc.year &&
        d.month == slotUtc.month &&
        d.day == slotUtc.day &&
        d.hour == slotUtc.hour &&
        d.minute == slotUtc.minute;
  }

  /// General (non-admin) booking: `group_booking_id` 0 — blocks admin slot takeover.
  static bool _isGeneralMemberBooking(BookingDto b) {
    return (b.groupBookingId ?? 0) == 0;
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
