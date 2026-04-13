// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'member_ladder_membership_with_profile_row.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MemberLadderMembershipWithProfileRow
_$MemberLadderMembershipWithProfileRowFromJson(Map<String, dynamic> json) =>
    MemberLadderMembershipWithProfileRow(
      vobGuid: json['vob_guid'] as String?,
      ladderType: json['ladder_type'] as String?,
      ladderRank: (json['ladder_rank'] as num?)?.toInt(),
      leagueTeamNumber: (json['league_team_number'] as num?)?.toInt(),
      rankWithinTeam: (json['rank_within_team'] as num?)?.toInt(),
      profileId: json['profile_id'] as String?,
      profileFirstName: json['profile_first_name'] as String?,
      profileLastName: json['profile_last_name'] as String?,
      profileEmail: json['profile_email'] as String?,
      profileContactNumber: json['profile_contact_number'] as String?,
      profileDateOfBirth: json['profile_date_of_birth'] as String?,
      profileIsActive: json['profile_is_active'] as bool?,
      profileExtensionId: json['profile_extension_id'] as String?,
      membershipType: json['membership_type'],
      emergencyContactNumber: json['emergency_contact_number'] as String?,
      canShowEmail: json['can_show_email'] as bool?,
      canShowContact: json['can_show_contact'] as bool?,
      canShowBirthday: json['can_show_birthday'] as bool?,
      isCoach: json['is_coach'] as bool?,
    );

Map<String, dynamic> _$MemberLadderMembershipWithProfileRowToJson(
  MemberLadderMembershipWithProfileRow instance,
) => <String, dynamic>{
  'vob_guid': instance.vobGuid,
  'ladder_type': instance.ladderType,
  'ladder_rank': instance.ladderRank,
  'league_team_number': instance.leagueTeamNumber,
  'rank_within_team': instance.rankWithinTeam,
  'profile_id': instance.profileId,
  'profile_first_name': instance.profileFirstName,
  'profile_last_name': instance.profileLastName,
  'profile_email': instance.profileEmail,
  'profile_contact_number': instance.profileContactNumber,
  'profile_date_of_birth': instance.profileDateOfBirth,
  'profile_is_active': instance.profileIsActive,
  'profile_extension_id': instance.profileExtensionId,
  'membership_type': instance.membershipType,
  'emergency_contact_number': instance.emergencyContactNumber,
  'can_show_email': instance.canShowEmail,
  'can_show_contact': instance.canShowContact,
  'can_show_birthday': instance.canShowBirthday,
  'is_coach': instance.isCoach,
};
