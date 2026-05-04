import 'package:json_annotation/json_annotation.dart';

import 'profile.dart';

part 'profile_row.g.dart';

/// Supabase `profiles` table row (PostgREST / JSON).
///
/// Mirrors the former `DatabaseProfile` shape: core identity and auth fields, plus
/// [profileExtensionId] as FK to [ProfileExtensionRow].
@JsonSerializable()
class ProfileRow implements IProfile {
  const ProfileRow({
    required this.id,
    this.vobGuid,
    this.firstName,
    this.lastName,
    this.email,
    this.contactNumber,
    this.password,
    this.profileType,
    this.isActive,
    this.dateOfBirth,
    this.dateCreated,
    this.passwordHashed,
    this.profileExtensionId,
    this.profilePictureUrl,
    this.profilePictureUpdatedAt,
  });

  factory ProfileRow.fromJson(Map<String, dynamic> json) => _$ProfileRowFromJson(json);

  @override
  final String id;

  @override
  @JsonKey(name: 'vob_guid')
  final String? vobGuid;

  @override
  @JsonKey(name: 'first_name')
  final String? firstName;

  @override
  @JsonKey(name: 'last_name')
  final String? lastName;

  @override
  final String? email;

  @override
  @JsonKey(name: 'contact_number')
  final String? contactNumber;

  @override
  final String? password;

  @override
  @JsonKey(name: 'profile_type')
  final String? profileType;

  @override
  @JsonKey(name: 'is_active')
  final bool? isActive;

  @override
  @JsonKey(name: 'date_of_birth')
  final String? dateOfBirth;

  @override
  @JsonKey(name: 'date_created')
  final String? dateCreated;

  @override
  @JsonKey(name: 'password_hashed')
  final bool? passwordHashed;

  @override
  @JsonKey(name: 'profile_extension_id')
  final String? profileExtensionId;

  @override
  @JsonKey(name: 'profile_picture_url')
  final String? profilePictureUrl;

  @override
  @JsonKey(name: 'profile_picture_updated_at')
  final String? profilePictureUpdatedAt;

  Map<String, dynamic> toJson() => _$ProfileRowToJson(this);

  /// Empty row for forms / defaults (all nullable fields null).
  static ProfileRow empty({String id = ''}) => ProfileRow(id: id);
}

