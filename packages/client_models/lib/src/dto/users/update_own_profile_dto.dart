/// Payload for a signed-in member updating their own [profiles] + [profile_extensions] fields.
class UpdateOwnProfileDto {
  const UpdateOwnProfileDto({
    required this.firstName,
    required this.lastName,
    required this.contactNumber,
    required this.dateOfBirth,
    required this.emergencyContactNumber,
    required this.canShowEmail,
    required this.canShowContactNumber,
    required this.canShowDateOfBirth,
    required this.ssaNumber,
  });

  final String firstName;
  final String lastName;
  final String contactNumber;

  /// Stored as UTC date only in Supabase (`yyyy-MM-dd`).
  final DateTime dateOfBirth;
  final String emergencyContactNumber;

  /// [profile_extensions] visibility flags for directory / public profile.
  final bool canShowEmail;
  final bool canShowContactNumber;
  final bool canShowDateOfBirth;

  /// Squash South Africa identifier; stored in [profile_extensions.ssa_number].
  final String ssaNumber;
}
