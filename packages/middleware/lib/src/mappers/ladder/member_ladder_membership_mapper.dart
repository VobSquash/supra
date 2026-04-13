import 'package:client_models/client_models.dart';
import 'package:client_supabase/client_supabase.dart';

/// Maps [MemberLadderMembershipWithProfileRow] → [MemberLadderMembershipWithProfileDTO].
MemberLadderMembershipWithProfileDTO mapMemberLadderMembershipWithProfileRow(
  MemberLadderMembershipWithProfileRow r,
) {
  return MemberLadderMembershipWithProfileDTO(
    vobGuid: r.vobGuid,
    ladderType: ladderTypeEnumFromView(r.ladderType),
    ladderRank: r.ladderRank,
    leagueTeamNumber: r.leagueTeamNumber,
    rankWithinTeam: r.rankWithinTeam,
    profileId: r.profileId,
    profileFirstName: r.profileFirstName,
    profileLastName: r.profileLastName,
    profileEmail: r.profileEmail,
    profileContactNumber: r.profileContactNumber,
    profileDateOfBirth: r.profileDateOfBirth,
    profileIsActive: r.profileIsActive,
    profileExtensionId: r.profileExtensionId,
    membershipType: MembershipTypeEnum.get(r.membershipType),
    emergencyContactNumber: r.emergencyContactNumber,
    canShowEmail: r.canShowEmail,
    canShowContact: r.canShowContact,
    canShowBirthday: r.canShowBirthday,
    isCoach: r.isCoach,
  );
}

/// View uses `men` / `ladies` / `masters`; [LadderTypeEnum] uses `mens` for the men’s ladder.
LadderTypeEnum? ladderTypeEnumFromView(String? ladderType) {
  switch (ladderType) {
    case 'men':
      return LadderTypeEnum.mens;
    case 'ladies':
      return LadderTypeEnum.ladies;
    case 'masters':
      return LadderTypeEnum.masters;
    default:
      return null;
  }
}
