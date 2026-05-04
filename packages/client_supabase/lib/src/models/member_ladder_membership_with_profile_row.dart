import 'package:json_annotation/json_annotation.dart';

part 'member_ladder_membership_with_profile_row.g.dart';

/// Row from [public.v_member_ladder_membership_with_profile].
@JsonSerializable()
class MemberLadderMembershipWithProfileRow {
  const MemberLadderMembershipWithProfileRow({
    this.vobGuid,
    this.ladderType,
    this.ladderRank,
    this.leagueTeamNumber,
    this.rankWithinTeam,
    this.profileId,
    this.profileFirstName,
    this.profileLastName,
    this.profileEmail,
    this.profileContactNumber,
    this.profileDateOfBirth,
    this.profileIsActive,
    this.profilePictureUrl,
    this.profilePictureUpdatedAt,
    this.profileExtensionId,
    this.membershipType,
    this.emergencyContactNumber,
    this.canShowEmail,
    this.canShowContact,
    this.canShowBirthday,
    this.isCoach,
  });

  factory MemberLadderMembershipWithProfileRow.fromJson(Map<String, dynamic> json) =>
      _$MemberLadderMembershipWithProfileRowFromJson(json);

  @JsonKey(name: 'vob_guid')
  final String? vobGuid;

  @JsonKey(name: 'ladder_type')
  final String? ladderType;

  @JsonKey(name: 'ladder_rank')
  final int? ladderRank;

  @JsonKey(name: 'league_team_number')
  final int? leagueTeamNumber;

  @JsonKey(name: 'rank_within_team')
  final int? rankWithinTeam;

  @JsonKey(name: 'profile_id')
  final String? profileId;

  @JsonKey(name: 'profile_first_name')
  final String? profileFirstName;

  @JsonKey(name: 'profile_last_name')
  final String? profileLastName;

  @JsonKey(name: 'profile_email')
  final String? profileEmail;

  @JsonKey(name: 'profile_contact_number')
  final String? profileContactNumber;

  @JsonKey(name: 'profile_date_of_birth')
  final String? profileDateOfBirth;

  @JsonKey(name: 'profile_is_active')
  final bool? profileIsActive;

  @JsonKey(name: 'profile_picture_url')
  final String? profilePictureUrl;

  @JsonKey(name: 'profile_picture_updated_at')
  final String? profilePictureUpdatedAt;

  @JsonKey(name: 'profile_extension_id')
  final String? profileExtensionId;

  /// DB may return int id or string; [fromJson] keeps dynamic for mapper.
  @JsonKey(name: 'membership_type')
  final Object? membershipType;

  @JsonKey(name: 'emergency_contact_number')
  final String? emergencyContactNumber;

  @JsonKey(name: 'can_show_email')
  final bool? canShowEmail;

  @JsonKey(name: 'can_show_contact')
  final bool? canShowContact;

  @JsonKey(name: 'can_show_birthday')
  final bool? canShowBirthday;

  @JsonKey(name: 'is_coach')
  final bool? isCoach;

  Map<String, dynamic> toJson() => _$MemberLadderMembershipWithProfileRowToJson(this);
}
