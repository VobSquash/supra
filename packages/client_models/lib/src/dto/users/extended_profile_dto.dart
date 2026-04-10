import 'package:client_models/client_models.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'extended_profile_dto.freezed.dart';

@freezed
class ExtendedProfileDTO with _$ExtendedProfileDTO {
  const ExtendedProfileDTO._();
  const factory ExtendedProfileDTO({
    required String? objectId,
    required String? vobGuid,
    required bool? isCoach,
    required bool? canShowEmail,
    required bool? canShowContactNumber,
    required bool? canShowDateOfBirth,
    // ignore: non_constant_identifier_names
    required String? SSANumber,
    required MembershipTypeEnum? membershipType,
    required String? emergencyContactNumber,
  }) = _ExtendedProfileDTO;
}
