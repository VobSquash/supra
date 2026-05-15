import 'package:client_models/client_models.dart';

/// Membership types that may appear on a ladder (admin add-member picker).
bool ladderMembershipEligibleForAdmin(MembershipTypeEnum? t) {
  if (t == null) return false;
  return switch (t) {
    MembershipTypeEnum.leagueMen ||
    MembershipTypeEnum.leagueStudent ||
    MembershipTypeEnum.leagueScholar ||
    MembershipTypeEnum.ladiesLeague ||
    MembershipTypeEnum.leagueAndMasters ||
    MembershipTypeEnum.mastersOnly =>
      true,
    MembershipTypeEnum.unknown ||
    MembershipTypeEnum.social ||
    MembershipTypeEnum.socialStudent ||
    MembershipTypeEnum.socialScholar =>
      false,
  };
}
