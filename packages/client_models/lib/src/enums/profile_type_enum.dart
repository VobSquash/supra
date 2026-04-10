enum ProfileTypeEnum {
  user('user', 1),
  administrator('administrator', 2),
  elivated('elivated', 3),
  unknown('unknown', -1);

  const ProfileTypeEnum(this.identifierType, this.id);

  final String identifierType;
  final int id;

  static ProfileTypeEnum get(Object querier) {
    if (querier is String) {
      return ProfileTypeEnum.values.firstWhere(
          (el) => el.identifierType == querier.toLowerCase(),
          orElse: () => ProfileTypeEnum.unknown);
    }
    return ProfileTypeEnum.values.firstWhere((el) => el.id == querier,
        orElse: () => ProfileTypeEnum.unknown);
  }

  bool get isAdminOrElevated {
    //return false;
    return this == ProfileTypeEnum.administrator ||
        this == ProfileTypeEnum.elivated;
  }

  bool get isAdmin {
    return this == ProfileTypeEnum.administrator;
  }
}
