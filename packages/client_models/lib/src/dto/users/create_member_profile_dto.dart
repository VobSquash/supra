import '../../enums/membership_types.dart';

/// Admin-only create payload: core identity + extension fields members fill in at signup.
///
/// Other profile / extension columns use defaults in the Supabase client (flags, null SSA, etc.).
class CreateMemberProfileDto {
  const CreateMemberProfileDto({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.contactNumber,
    required this.emergencyContactNumber,
    required this.dateOfBirth,
    required this.membershipType,
  });

  final String firstName;
  final String lastName;
  final String email;
  final String contactNumber;
  final String emergencyContactNumber;
  final DateTime dateOfBirth;
  final MembershipTypeEnum membershipType;
}
