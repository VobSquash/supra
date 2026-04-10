/// Abstract row shape for the `profiles` table.
///
/// [profileExtensionId] references [ProfileExtension.id] in `profile_extensions`.
abstract class IProfile {
  String get id;

  String? get vobGuid;

  String? get firstName;

  String? get lastName;

  String? get email;

  String? get contactNumber;

  String? get password;

  String? get profileType;

  bool? get isActive;

  /// Stored as ISO date string or DB text, depending on column type.
  String? get dateOfBirth;

  String? get dateCreated;

  bool? get passwordHashed;

  /// FK to `profile_extensions.id` when present.
  String? get profileExtensionId;
}
