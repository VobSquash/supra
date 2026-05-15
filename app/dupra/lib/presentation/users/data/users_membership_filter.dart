import 'package:client_models/client_models.dart';

/// Directory membership segment (subset of [MembershipTypeEnum] groupings).
enum UsersMembershipFilter { all, league, social, masters }

String usersMembershipFilterLabel(UsersMembershipFilter f) {
  switch (f) {
    case UsersMembershipFilter.all:
      return 'All';
    case UsersMembershipFilter.league:
      return 'League';
    case UsersMembershipFilter.social:
      return 'Social';
    case UsersMembershipFilter.masters:
      return 'Masters';
  }
}

bool usersMembershipMatches(BasicProfileDTO p, UsersMembershipFilter f) {
  if (f == UsersMembershipFilter.all) {
    return true;
  }
  final t = p.extendedProfile?.membershipType;
  if (t == null || t == MembershipTypeEnum.unknown) {
    return false;
  }
  switch (f) {
    case UsersMembershipFilter.all:
      return true;
    case UsersMembershipFilter.league:
      return t == MembershipTypeEnum.leagueMen ||
          t == MembershipTypeEnum.ladiesLeague ||
          t == MembershipTypeEnum.leagueStudent ||
          t == MembershipTypeEnum.leagueScholar ||
          t == MembershipTypeEnum.leagueAndMasters;
    case UsersMembershipFilter.social:
      return t == MembershipTypeEnum.social ||
          t == MembershipTypeEnum.socialStudent ||
          t == MembershipTypeEnum.socialScholar;
    case UsersMembershipFilter.masters:
      return t == MembershipTypeEnum.mastersOnly || t == MembershipTypeEnum.leagueAndMasters;
  }
}

List<BasicProfileDTO> filterUsersProfilesForDirectory({
  required List<BasicProfileDTO> profiles,
  required String rawQuery,
  required UsersMembershipFilter membership,
}) {
  final query = rawQuery.trim().toLowerCase();
  return profiles.where((p) {
    if (!usersMembershipMatches(p, membership)) {
      return false;
    }
    if (query.isEmpty) {
      return true;
    }
    final name = p.displayName.toLowerCase();
    final first = (p.firstName ?? '').toLowerCase();
    final last = (p.lastName ?? '').toLowerCase();
    final email = (p.email ?? '').toLowerCase();
    final phone = (p.contactNumber ?? '').toLowerCase();
    final emergency = (p.emergencyContactNumber ?? '').toLowerCase();
    return name.contains(query) ||
        first.contains(query) ||
        last.contains(query) ||
        email.contains(query) ||
        phone.contains(query) ||
        emergency.contains(query);
  }).toList(growable: false);
}
