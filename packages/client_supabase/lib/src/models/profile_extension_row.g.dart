// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile_extension_row.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProfileExtensionRow _$ProfileExtensionRowFromJson(Map<String, dynamic> json) =>
    ProfileExtensionRow(
      id: json['id'] as String,
      vobGuid: json['vob_guid'] as String?,
      ssaNumber: json['ssa_number'] as String?,
      emergencyContactNumber: json['emergency_contact_number'] as String?,
      firebaseNumber: json['firebase_number'] as String?,
      membershipType: json['membership_type'] as String?,
      canShowBirthday: json['can_show_birthday'] as bool?,
      canShowEmail: json['can_show_email'] as bool?,
      canShowContact: json['can_show_contact'] as bool?,
      isCoach: json['is_coach'] as bool?,
    );

Map<String, dynamic> _$ProfileExtensionRowToJson(
  ProfileExtensionRow instance,
) => <String, dynamic>{
  'id': instance.id,
  'vob_guid': instance.vobGuid,
  'ssa_number': instance.ssaNumber,
  'emergency_contact_number': instance.emergencyContactNumber,
  'firebase_number': instance.firebaseNumber,
  'membership_type': instance.membershipType,
  'can_show_birthday': instance.canShowBirthday,
  'can_show_email': instance.canShowEmail,
  'can_show_contact': instance.canShowContact,
  'is_coach': instance.isCoach,
};
