/// Abstract row for ladder tables (`ladder_mens`, `ladder_ladies`, `ladder_masters`).
abstract class ILadderEntry {
  String get id;

  int? get sortOrder;

  int? get year;

  String? get vobGuid;

  int? get team;

  bool? get canBeChallenged;

  String? get legacyObjectId;
}
