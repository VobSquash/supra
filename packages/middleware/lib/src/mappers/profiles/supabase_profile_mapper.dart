import 'package:auto_mappr_annotation/auto_mappr_annotation.dart';
import 'package:client_models/client_models.dart';
import 'package:client_supabase/client_supabase.dart';

import 'supabase_profile_mapper.auto_mappr.dart';

@AutoMappr([
  MapType<ProfileExtensionRow, ExtendedProfileDTO>(
    fields: [
      Field('objectId', from: 'id'),
      Field('SSANumber', from: 'ssaNumber'),
      Field('canShowContactNumber', from: 'canShowContact'),
      Field('canShowDateOfBirth', from: 'canShowBirthday'),
      Field('membershipType', custom: SupabaseProfileMapper.mapMembershipType),
    ],
  ),
  MapType<ProfileFull, BasicProfileDTO>(
    fields: [
      Field('objectId', custom: SupabaseProfileMapper.mapProfileObjectId),
      Field('vobGuid', custom: SupabaseProfileMapper.mapProfileVobGuid),
      Field('firstName', custom: SupabaseProfileMapper.mapFirstName),
      Field('lastName', custom: SupabaseProfileMapper.mapLastName),
      Field('email', custom: SupabaseProfileMapper.mapEmail),
      Field('contactNumber', custom: SupabaseProfileMapper.mapContactNumber),
      Field('dateOfBirth', custom: SupabaseProfileMapper.mapDateOfBirth),
      Field('isActive', custom: SupabaseProfileMapper.mapIsActive),
      Field('extendedProfile', custom: SupabaseProfileMapper.mapExtendedProfile),
      Field(
        'emergencyContactNumber',
        custom: SupabaseProfileMapper.mapEmergencyContactNumber,
      ),
      Field('profilePictureUrl', custom: null),
    ],
  ),
])
class SupabaseProfileMapper extends $SupabaseProfileMapper {
  const SupabaseProfileMapper() : super();

  static MembershipTypeEnum? mapMembershipType(ProfileExtensionRow input) {
    return MembershipTypeEnum.get(input.membershipType);
  }

  static String? mapProfileObjectId(ProfileFull input) => input.profile.id;
  static String? mapProfileVobGuid(ProfileFull input) => input.profile.vobGuid;
  static String? mapFirstName(ProfileFull input) => input.profile.firstName;
  static String? mapLastName(ProfileFull input) => input.profile.lastName;
  static String? mapEmail(ProfileFull input) => input.profile.email;
  static String? mapContactNumber(ProfileFull input) => input.profile.contactNumber;
  static String? mapDateOfBirth(ProfileFull input) => input.profile.dateOfBirth;
  static bool? mapIsActive(ProfileFull input) => input.profile.isActive;

  static ExtendedProfileDTO? mapExtendedProfile(ProfileFull input) {
    final ext = input.extension;
    if (ext == null) return null;
    return const SupabaseProfileMapper().convert<ProfileExtensionRow, ExtendedProfileDTO>(ext);
  }

  static String? mapEmergencyContactNumber(ProfileFull input) =>
      input.extension?.emergencyContactNumber;
}

