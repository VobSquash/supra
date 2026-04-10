import 'package:client_models/src/extensions/export_extensions.dart';

enum MembershipTypeEnum {
  unknown('unknown', 'Unknown', 0),
  leagueMen('leagueMen', 'League', 1),
  leagueAndMasters('leagueAndMasters', 'League and Masters', 2),
  leagueStudent('leagueStudent', 'League Student', 3),
  leagueScholar('leagueScholar', 'League Scholar', 4),
  ladiesLeague('ladiesLeague', 'Ladies League', 9),
  mastersOnly('mastersOnly', 'Masters Only', 5),
  social('social', 'Social', 6),
  socialStudent('socialStudent', 'Social Student', 7),
  socialScholar('socialScholar', 'Social Scholar', 8);

  const MembershipTypeEnum(this.identifierType, this.friendlyName, this.id);

  final String identifierType;
  final String friendlyName;
  final int id;

  static MembershipTypeEnum get(dynamic id) {
    if (id is int) {
      return MembershipTypeEnum.values.firstWhere((el) => el.id == id, orElse: () => MembershipTypeEnum.unknown);
    } else if (id is String) {
      return MembershipTypeEnum.values.firstWhere(
        (el) => el.identifierType == id.toString().lowerFirstLetter(),
        orElse: () => MembershipTypeEnum.unknown,
      );
    }
    return MembershipTypeEnum.unknown;
  }
}
