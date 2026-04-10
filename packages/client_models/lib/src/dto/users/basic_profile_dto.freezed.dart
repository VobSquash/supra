// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'basic_profile_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$BasicProfileDTO {
  String? get objectId => throw _privateConstructorUsedError;
  String? get vobGuid => throw _privateConstructorUsedError;
  String? get firstName => throw _privateConstructorUsedError;
  String? get lastName => throw _privateConstructorUsedError;
  String? get email => throw _privateConstructorUsedError;
  String? get contactNumber => throw _privateConstructorUsedError;
  String? get dateOfBirth => throw _privateConstructorUsedError;
  String? get emergencyContactNumber => throw _privateConstructorUsedError;
  bool? get isActive => throw _privateConstructorUsedError;
  ExtendedProfileDTO? get extendedProfile => throw _privateConstructorUsedError;
  String? get profilePictureUrl => throw _privateConstructorUsedError;

  /// Create a copy of BasicProfileDTO
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $BasicProfileDTOCopyWith<BasicProfileDTO> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BasicProfileDTOCopyWith<$Res> {
  factory $BasicProfileDTOCopyWith(
    BasicProfileDTO value,
    $Res Function(BasicProfileDTO) then,
  ) = _$BasicProfileDTOCopyWithImpl<$Res, BasicProfileDTO>;
  @useResult
  $Res call({
    String? objectId,
    String? vobGuid,
    String? firstName,
    String? lastName,
    String? email,
    String? contactNumber,
    String? dateOfBirth,
    String? emergencyContactNumber,
    bool? isActive,
    ExtendedProfileDTO? extendedProfile,
    String? profilePictureUrl,
  });

  $ExtendedProfileDTOCopyWith<$Res>? get extendedProfile;
}

/// @nodoc
class _$BasicProfileDTOCopyWithImpl<$Res, $Val extends BasicProfileDTO>
    implements $BasicProfileDTOCopyWith<$Res> {
  _$BasicProfileDTOCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of BasicProfileDTO
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? objectId = freezed,
    Object? vobGuid = freezed,
    Object? firstName = freezed,
    Object? lastName = freezed,
    Object? email = freezed,
    Object? contactNumber = freezed,
    Object? dateOfBirth = freezed,
    Object? emergencyContactNumber = freezed,
    Object? isActive = freezed,
    Object? extendedProfile = freezed,
    Object? profilePictureUrl = freezed,
  }) {
    return _then(
      _value.copyWith(
            objectId: freezed == objectId
                ? _value.objectId
                : objectId // ignore: cast_nullable_to_non_nullable
                      as String?,
            vobGuid: freezed == vobGuid
                ? _value.vobGuid
                : vobGuid // ignore: cast_nullable_to_non_nullable
                      as String?,
            firstName: freezed == firstName
                ? _value.firstName
                : firstName // ignore: cast_nullable_to_non_nullable
                      as String?,
            lastName: freezed == lastName
                ? _value.lastName
                : lastName // ignore: cast_nullable_to_non_nullable
                      as String?,
            email: freezed == email
                ? _value.email
                : email // ignore: cast_nullable_to_non_nullable
                      as String?,
            contactNumber: freezed == contactNumber
                ? _value.contactNumber
                : contactNumber // ignore: cast_nullable_to_non_nullable
                      as String?,
            dateOfBirth: freezed == dateOfBirth
                ? _value.dateOfBirth
                : dateOfBirth // ignore: cast_nullable_to_non_nullable
                      as String?,
            emergencyContactNumber: freezed == emergencyContactNumber
                ? _value.emergencyContactNumber
                : emergencyContactNumber // ignore: cast_nullable_to_non_nullable
                      as String?,
            isActive: freezed == isActive
                ? _value.isActive
                : isActive // ignore: cast_nullable_to_non_nullable
                      as bool?,
            extendedProfile: freezed == extendedProfile
                ? _value.extendedProfile
                : extendedProfile // ignore: cast_nullable_to_non_nullable
                      as ExtendedProfileDTO?,
            profilePictureUrl: freezed == profilePictureUrl
                ? _value.profilePictureUrl
                : profilePictureUrl // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }

  /// Create a copy of BasicProfileDTO
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ExtendedProfileDTOCopyWith<$Res>? get extendedProfile {
    if (_value.extendedProfile == null) {
      return null;
    }

    return $ExtendedProfileDTOCopyWith<$Res>(_value.extendedProfile!, (value) {
      return _then(_value.copyWith(extendedProfile: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$BasicProfileDTOImplCopyWith<$Res>
    implements $BasicProfileDTOCopyWith<$Res> {
  factory _$$BasicProfileDTOImplCopyWith(
    _$BasicProfileDTOImpl value,
    $Res Function(_$BasicProfileDTOImpl) then,
  ) = __$$BasicProfileDTOImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String? objectId,
    String? vobGuid,
    String? firstName,
    String? lastName,
    String? email,
    String? contactNumber,
    String? dateOfBirth,
    String? emergencyContactNumber,
    bool? isActive,
    ExtendedProfileDTO? extendedProfile,
    String? profilePictureUrl,
  });

  @override
  $ExtendedProfileDTOCopyWith<$Res>? get extendedProfile;
}

/// @nodoc
class __$$BasicProfileDTOImplCopyWithImpl<$Res>
    extends _$BasicProfileDTOCopyWithImpl<$Res, _$BasicProfileDTOImpl>
    implements _$$BasicProfileDTOImplCopyWith<$Res> {
  __$$BasicProfileDTOImplCopyWithImpl(
    _$BasicProfileDTOImpl _value,
    $Res Function(_$BasicProfileDTOImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of BasicProfileDTO
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? objectId = freezed,
    Object? vobGuid = freezed,
    Object? firstName = freezed,
    Object? lastName = freezed,
    Object? email = freezed,
    Object? contactNumber = freezed,
    Object? dateOfBirth = freezed,
    Object? emergencyContactNumber = freezed,
    Object? isActive = freezed,
    Object? extendedProfile = freezed,
    Object? profilePictureUrl = freezed,
  }) {
    return _then(
      _$BasicProfileDTOImpl(
        objectId: freezed == objectId
            ? _value.objectId
            : objectId // ignore: cast_nullable_to_non_nullable
                  as String?,
        vobGuid: freezed == vobGuid
            ? _value.vobGuid
            : vobGuid // ignore: cast_nullable_to_non_nullable
                  as String?,
        firstName: freezed == firstName
            ? _value.firstName
            : firstName // ignore: cast_nullable_to_non_nullable
                  as String?,
        lastName: freezed == lastName
            ? _value.lastName
            : lastName // ignore: cast_nullable_to_non_nullable
                  as String?,
        email: freezed == email
            ? _value.email
            : email // ignore: cast_nullable_to_non_nullable
                  as String?,
        contactNumber: freezed == contactNumber
            ? _value.contactNumber
            : contactNumber // ignore: cast_nullable_to_non_nullable
                  as String?,
        dateOfBirth: freezed == dateOfBirth
            ? _value.dateOfBirth
            : dateOfBirth // ignore: cast_nullable_to_non_nullable
                  as String?,
        emergencyContactNumber: freezed == emergencyContactNumber
            ? _value.emergencyContactNumber
            : emergencyContactNumber // ignore: cast_nullable_to_non_nullable
                  as String?,
        isActive: freezed == isActive
            ? _value.isActive
            : isActive // ignore: cast_nullable_to_non_nullable
                  as bool?,
        extendedProfile: freezed == extendedProfile
            ? _value.extendedProfile
            : extendedProfile // ignore: cast_nullable_to_non_nullable
                  as ExtendedProfileDTO?,
        profilePictureUrl: freezed == profilePictureUrl
            ? _value.profilePictureUrl
            : profilePictureUrl // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc

class _$BasicProfileDTOImpl extends _BasicProfileDTO {
  const _$BasicProfileDTOImpl({
    required this.objectId,
    required this.vobGuid,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.contactNumber,
    required this.dateOfBirth,
    required this.emergencyContactNumber,
    required this.isActive,
    required this.extendedProfile,
    this.profilePictureUrl,
  }) : super._();

  @override
  final String? objectId;
  @override
  final String? vobGuid;
  @override
  final String? firstName;
  @override
  final String? lastName;
  @override
  final String? email;
  @override
  final String? contactNumber;
  @override
  final String? dateOfBirth;
  @override
  final String? emergencyContactNumber;
  @override
  final bool? isActive;
  @override
  final ExtendedProfileDTO? extendedProfile;
  @override
  final String? profilePictureUrl;

  @override
  String toString() {
    return 'BasicProfileDTO(objectId: $objectId, vobGuid: $vobGuid, firstName: $firstName, lastName: $lastName, email: $email, contactNumber: $contactNumber, dateOfBirth: $dateOfBirth, emergencyContactNumber: $emergencyContactNumber, isActive: $isActive, extendedProfile: $extendedProfile, profilePictureUrl: $profilePictureUrl)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BasicProfileDTOImpl &&
            (identical(other.objectId, objectId) ||
                other.objectId == objectId) &&
            (identical(other.vobGuid, vobGuid) || other.vobGuid == vobGuid) &&
            (identical(other.firstName, firstName) ||
                other.firstName == firstName) &&
            (identical(other.lastName, lastName) ||
                other.lastName == lastName) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.contactNumber, contactNumber) ||
                other.contactNumber == contactNumber) &&
            (identical(other.dateOfBirth, dateOfBirth) ||
                other.dateOfBirth == dateOfBirth) &&
            (identical(other.emergencyContactNumber, emergencyContactNumber) ||
                other.emergencyContactNumber == emergencyContactNumber) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive) &&
            (identical(other.extendedProfile, extendedProfile) ||
                other.extendedProfile == extendedProfile) &&
            (identical(other.profilePictureUrl, profilePictureUrl) ||
                other.profilePictureUrl == profilePictureUrl));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    objectId,
    vobGuid,
    firstName,
    lastName,
    email,
    contactNumber,
    dateOfBirth,
    emergencyContactNumber,
    isActive,
    extendedProfile,
    profilePictureUrl,
  );

  /// Create a copy of BasicProfileDTO
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$BasicProfileDTOImplCopyWith<_$BasicProfileDTOImpl> get copyWith =>
      __$$BasicProfileDTOImplCopyWithImpl<_$BasicProfileDTOImpl>(
        this,
        _$identity,
      );
}

abstract class _BasicProfileDTO extends BasicProfileDTO {
  const factory _BasicProfileDTO({
    required final String? objectId,
    required final String? vobGuid,
    required final String? firstName,
    required final String? lastName,
    required final String? email,
    required final String? contactNumber,
    required final String? dateOfBirth,
    required final String? emergencyContactNumber,
    required final bool? isActive,
    required final ExtendedProfileDTO? extendedProfile,
    final String? profilePictureUrl,
  }) = _$BasicProfileDTOImpl;
  const _BasicProfileDTO._() : super._();

  @override
  String? get objectId;
  @override
  String? get vobGuid;
  @override
  String? get firstName;
  @override
  String? get lastName;
  @override
  String? get email;
  @override
  String? get contactNumber;
  @override
  String? get dateOfBirth;
  @override
  String? get emergencyContactNumber;
  @override
  bool? get isActive;
  @override
  ExtendedProfileDTO? get extendedProfile;
  @override
  String? get profilePictureUrl;

  /// Create a copy of BasicProfileDTO
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$BasicProfileDTOImplCopyWith<_$BasicProfileDTOImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
