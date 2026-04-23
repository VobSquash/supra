/// Admin update: account flags on [profiles] plus the same member fields as [UpdateOwnProfileDto]
/// (names, contact, DOB, extension visibility + SSA).
class UpdateAdminProfileDto {
  const UpdateAdminProfileDto({
    required this.email,
    required this.isActive,
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

  final String email;
  final bool isActive;

  final String firstName;
  final String lastName;
  final String contactNumber;

  /// Stored as UTC date only in Supabase (`yyyy-MM-dd`).
  final DateTime dateOfBirth;
  final String emergencyContactNumber;

  final bool canShowEmail;
  final bool canShowContactNumber;
  final bool canShowDateOfBirth;

  final String ssaNumber;
}
