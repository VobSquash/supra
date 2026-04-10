enum SettingsTypeEnum {
  currentLeagueTeamBreakdown(
      'LadderBreakdown2026', 'League Team Breakdown 2026'),
  //fees2025('Fees2025', 'Fees 2025'),
  fees2026('Fees2026', 'Fees 2026'),
  systemSettings('SystemSettings', 'System Settings');

  const SettingsTypeEnum(this.identifierType, this.friendlyName);

  final String identifierType;
  final String friendlyName;
}
