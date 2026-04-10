/// Abstract row shape for the `profile_extensions` table.
///
/// Linked from [Profile.profileExtensionId].
abstract class IProfileExtension {
  String get id;

  String? get vobGuid;

  String? get ssaNumber;

  String? get emergencyContactNumber;

  String? get firebaseNumber;

  String? get membershipType;

  bool? get canShowBirthday;

  bool? get canShowEmail;

  bool? get canShowContact;

  bool? get isCoach;
}
