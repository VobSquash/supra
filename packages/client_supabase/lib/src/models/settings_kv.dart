/// Abstract row shape for the `settings` key-value table (legacy Parse `Settings`).
abstract class ISettingsKv {
  String get id;

  String get name;

  String? get value;

  /// Original Parse `objectId`, if migrated.
  String? get legacyObjectId;
}
