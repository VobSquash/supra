import 'package:client_models/client_models.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'member_ladder_membership_with_profile_dto.freezed.dart';

/// One row from [v_member_ladder_membership_with_profile] for a member (per ladder type).
@freezed
class MemberLadderMembershipWithProfileDTO with _$MemberLadderMembershipWithProfileDTO {
  const factory MemberLadderMembershipWithProfileDTO({
    required String? vobGuid,
    required LadderTypeEnum? ladderType,
    required int? ladderRank,
    required int? leagueTeamNumber,
    required int? rankWithinTeam,
    required String? profileId,
    required String? profileFirstName,
    required String? profileLastName,
    required String? profileEmail,
    required String? profileContactNumber,
    required String? profileDateOfBirth,
    required bool? profileIsActive,
    required String? profileExtensionId,
    required MembershipTypeEnum? membershipType,
    required String? emergencyContactNumber,
    required bool? canShowEmail,
    required bool? canShowContact,
    required bool? canShowBirthday,
    required bool? isCoach,
  }) = _MemberLadderMembershipWithProfileDTO;
}
