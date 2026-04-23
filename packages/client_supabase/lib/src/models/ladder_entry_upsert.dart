class LadderEntryUpsert {
  const LadderEntryUpsert({
    required this.vobGuid,
    required this.sortOrder,
    this.team,
    this.canBeChallenged,
  });

  final String vobGuid;
  final int sortOrder;
  final int? team;
  final bool? canBeChallenged;
}
