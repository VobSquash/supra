enum LadderTypeEnum {
  mens('mens', 'LadderMens', 'Mens'),
  ladies('ladies', 'LadderLadies', 'Ladies'),
  masters('masters', 'LadderMasters', 'Masters');

  const LadderTypeEnum(
      this.identifierType, this.databaseClassName, this.friendlyName);

  final String identifierType;
  final String databaseClassName;
  final String friendlyName;
}

/// Supabase `public` table names (snake_case): one table per Parse ladder class.
extension LadderTypeEnumPostgresTable on LadderTypeEnum {
  String get postgresTableName {
    switch (this) {
      case LadderTypeEnum.mens:
        return 'ladder_mens';
      case LadderTypeEnum.ladies:
        return 'ladder_ladies';
      case LadderTypeEnum.masters:
        return 'ladder_masters';
    }
  }
}

/// Parse `LadderType` is stored as enum index (0 → mens …).
LadderTypeEnum? ladderTypeEnumFromIndex(int? index) {
  if (index == null) return null;
  if (index < 0 || index >= LadderTypeEnum.values.length) return null;
  return LadderTypeEnum.values[index];
}
