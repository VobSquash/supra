import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:client_models/src/dto/users/extended_profile_dto.dart';

part 'basic_profile_dto.freezed.dart';

@freezed
class BasicProfileDTO with _$BasicProfileDTO {
  const BasicProfileDTO._();
  const factory BasicProfileDTO({
    required String? objectId,
    required String? vobGuid,
    required String? firstName,
    required String? lastName,
    required String? email,
    required String? contactNumber,
    required String? dateOfBirth,
    required String? emergencyContactNumber,
    required bool? isActive,
    required ExtendedProfileDTO? extendedProfile,
    String? profilePictureUrl,
  }) = _BasicProfileDTO;

  String get displayName => '$firstName $lastName';
  factory BasicProfileDTO.empty() => const BasicProfileDTO(
        objectId: '',
        vobGuid: '',
        firstName: '',
        lastName: '',
        email: '',
        contactNumber: '',
        dateOfBirth: '',
        emergencyContactNumber: '',
        isActive: false,
        extendedProfile: null,
        profilePictureUrl: null,
      );
}
