// ignore_for_file: constant_identifier_names

enum BookingTypeEnum {
  ADMIN('admin'),
  COACH('coach'),
  GENERAL('general user');

  const BookingTypeEnum(this.identifierType);

  final String identifierType;
}

enum GridTypeEnum {
  AddDay('AllDay', 0),
  Peak('Peak', 56),
  Morning('Morning', 0),
  Afternoon('Afternoon', 36);

  const GridTypeEnum(this.identifierType, this.multiplierOf4Cells);

  final String identifierType;
  final int multiplierOf4Cells;
}

enum BookingUserTypeEnum {
  Coaching('Coaching'),
  Personal('Personal');

  const BookingUserTypeEnum(this.identifierType);

  final String identifierType;
}
