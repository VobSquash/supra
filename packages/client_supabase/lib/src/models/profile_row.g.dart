// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile_row.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProfileRow _$ProfileRowFromJson(Map<String, dynamic> json) => ProfileRow(
  id: json['id'] as String,
  vobGuid: json['vob_guid'] as String?,
  firstName: json['first_name'] as String?,
  lastName: json['last_name'] as String?,
  email: json['email'] as String?,
  contactNumber: json['contact_number'] as String?,
  password: json['password'] as String?,
  profileType: json['profile_type'] as String?,
  isActive: json['is_active'] as bool?,
  dateOfBirth: json['date_of_birth'] as String?,
  dateCreated: json['date_created'] as String?,
  passwordHashed: json['password_hashed'] as bool?,
  profileExtensionId: json['profile_extension_id'] as String?,
  profilePictureUrl: json['profile_picture_url'] as String?,
  profilePictureUpdatedAt: json['profile_picture_updated_at'] as String?,
);

Map<String, dynamic> _$ProfileRowToJson(ProfileRow instance) =>
    <String, dynamic>{
      'id': instance.id,
      'vob_guid': instance.vobGuid,
      'first_name': instance.firstName,
      'last_name': instance.lastName,
      'email': instance.email,
      'contact_number': instance.contactNumber,
      'password': instance.password,
      'profile_type': instance.profileType,
      'is_active': instance.isActive,
      'date_of_birth': instance.dateOfBirth,
      'date_created': instance.dateCreated,
      'password_hashed': instance.passwordHashed,
      'profile_extension_id': instance.profileExtensionId,
      'profile_picture_url': instance.profilePictureUrl,
      'profile_picture_updated_at': instance.profilePictureUpdatedAt,
    };
