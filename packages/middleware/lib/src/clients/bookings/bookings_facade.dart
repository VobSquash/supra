import 'package:client_models/client_models.dart';
import 'package:client_supabase/client_supabase.dart';
import 'package:injectable/injectable.dart';
import 'package:middleware/src/clients/bookings/i_bookings_facade.dart';
import 'package:middleware/src/injection.dart';
import 'package:middleware/src/mappers/bookings/booking_with_profile.dart';
import 'package:middleware/src/mappers/bookings/supabase_booking_mapper.dart';
import 'package:middleware/src/mappers/profiles/supabase_profile_mapper.dart';
import 'package:middleware/src/utils/vob_guid_normalize.dart';

@LazySingleton(as: IBookingsFacade)
class BookingsFacade implements IBookingsFacade {
  BookingsFacade();

  IClientSupabase get _client => middlewareSl<IClientSupabase>();

  static const _mapper = SupabaseBookingMapper();

  @override
  Future<BookingListDto> loadBookings({required DateTime forDate}) async {
    final bookingRows = await _client.bookings.getBookings(forDate: forDate);
    final profileRows = await _client.profiles.getProfiles();

    final byNormalizedVob = <String, BasicProfileDTO>{};
    for (final p in profileRows) {
      final basic = const SupabaseProfileMapper().convert<ProfileFull, BasicProfileDTO>(p);
      final key = normalizeVobGuid(basic.vobGuid);
      if (key != null && key.isNotEmpty) {
        byNormalizedVob[key] = basic;
      }
    }

    final items = <BookingDto>[];
    for (final row in bookingRows) {
      final v = normalizeVobGuid(row.vobGuid);
      final prof = v != null ? byNormalizedVob[v] : null;
      items.add(
        _mapper.convert<BookingWithProfile, BookingDto>(
          BookingWithProfile(booking: row, profile: prof),
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
}
