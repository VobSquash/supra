import 'package:json_annotation/json_annotation.dart';

import 'profile_extension.dart';

part 'profile_extension_row.g.dart';

/// Supabase `profile_extensions` table row (PostgREST / JSON).
///
/// Mirrors the former `DatabaseProfileExtended` shape (Parse `ProfileFk` / `Id`
/// maps to [vobGuid] for legacy correlation with [ProfileRow.vobGuid]).
@JsonSerializable()
class ProfileExtensionRow implements IProfileExtension {
  const ProfileExtensionRow({
    required this.id,
    this.vobGuid,
    this.ssaNumber,
    this.emergencyContactNumber,
    this.firebaseNumber,
    this.membershipType,
    this.canShowBirthday,
    this.canShowEmail,
    this.canShowContact,
    this.isCoach,
  });

  factory ProfileExtensionRow.fromJson(Map<String, dynamic> json) =>
      _$ProfileExtensionRowFromJson(json);

  @override
  final String id;

  @override
  @JsonKey(name: 'vob_guid')
  final String? vobGuid;

  @override
  @JsonKey(name: 'ssa_number')
  final String? ssaNumber;

  @override
  @JsonKey(name: 'emergency_contact_number')
  final String? emergencyContactNumber;

  @override
  @JsonKey(name: 'firebase_number')
  final String? firebaseNumber;

  @override
  @JsonKey(name: 'membership_type')
  final String? membershipType;

  @override
  @JsonKey(name: 'can_show_birthday')
  final bool? canShowBirthday;

  @override
  @JsonKey(name: 'can_show_email')
  final bool? canShowEmail;

  @override
  @JsonKey(name: 'can_show_contact')
  final bool? canShowContact;

  @override
  @JsonKey(name: 'is_coach')
  final bool? isCoach;

  Map<String, dynamic> toJson() => _$ProfileExtensionRowToJson(this);

  static ProfileExtensionRow empty({String id = ''}) =>
      ProfileExtensionRow(id: id);
}
