import 'package:auto_mappr_annotation/auto_mappr_annotation.dart';
import 'package:client_models/client_models.dart';

import 'booking_with_profile.dart';
import 'supabase_booking_mapper.auto_mappr.dart';

@AutoMappr([
  MapType<BookingWithProfile, BookingDto>(
    fields: [
      Field('objectId', custom: SupabaseBookingMapper.mapObjectId),
      Field('courtNo', custom: SupabaseBookingMapper.mapCourtNo),
      Field('bookingDate', custom: SupabaseBookingMapper.mapBookingDate),
      Field('displayName', custom: SupabaseBookingMapper.mapDisplayName),
      Field('profile', custom: SupabaseBookingMapper.mapProfile),
      Field('groupBookingId', custom: SupabaseBookingMapper.mapGroupBookingId),
      Field('isMine', custom: SupabaseBookingMapper.mapIsMine),
      Field('index', custom: SupabaseBookingMapper.mapIndex),
      Field('profilePictureUrl', custom: SupabaseBookingMapper.mapProfilePictureUrl),
    ],
  ),
])
class SupabaseBookingMapper extends $SupabaseBookingMapper {
  const SupabaseBookingMapper() : super();

  static String? mapObjectId(BookingWithProfile w) => w.booking.legacyObjectId;

  static int? mapCourtNo(BookingWithProfile w) => w.booking.courtNo;

  static DateTime? mapBookingDate(BookingWithProfile w) => w.booking.bookingDate;

  static String? mapDisplayName(BookingWithProfile w) => w.booking.displayName;

  static BasicProfileDTO? mapProfile(BookingWithProfile w) => w.profile;

  static int? mapGroupBookingId(BookingWithProfile w) => w.booking.groupBookingId;

  static bool mapIsMine(BookingWithProfile w) => false;

  static int? mapIndex(BookingWithProfile w) => null;

  static String? mapProfilePictureUrl(BookingWithProfile w) => null;
}
