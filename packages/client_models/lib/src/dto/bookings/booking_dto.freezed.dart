// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'booking_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$BookingDto {
  String? get objectId => throw _privateConstructorUsedError;
  int? get courtNo => throw _privateConstructorUsedError;
  DateTime? get bookingDate => throw _privateConstructorUsedError;
  String? get displayName => throw _privateConstructorUsedError;
  BasicProfileDTO? get profile => throw _privateConstructorUsedError;
  int? get groupBookingId => throw _privateConstructorUsedError;
  bool get isMine => throw _privateConstructorUsedError;
  int? get index => throw _privateConstructorUsedError;
  String? get profilePictureUrl => throw _privateConstructorUsedError;

  /// Create a copy of BookingDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $BookingDtoCopyWith<BookingDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BookingDtoCopyWith<$Res> {
  factory $BookingDtoCopyWith(
    BookingDto value,
    $Res Function(BookingDto) then,
  ) = _$BookingDtoCopyWithImpl<$Res, BookingDto>;
  @useResult
  $Res call({
    String? objectId,
    int? courtNo,
    DateTime? bookingDate,
    String? displayName,
    BasicProfileDTO? profile,
    int? groupBookingId,
    bool isMine,
    int? index,
    String? profilePictureUrl,
  });

  $BasicProfileDTOCopyWith<$Res>? get profile;
}

/// @nodoc
class _$BookingDtoCopyWithImpl<$Res, $Val extends BookingDto>
    implements $BookingDtoCopyWith<$Res> {
  _$BookingDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of BookingDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? objectId = freezed,
    Object? courtNo = freezed,
    Object? bookingDate = freezed,
    Object? displayName = freezed,
    Object? profile = freezed,
    Object? groupBookingId = freezed,
    Object? isMine = null,
    Object? index = freezed,
    Object? profilePictureUrl = freezed,
  }) {
    return _then(
      _value.copyWith(
            objectId: freezed == objectId
                ? _value.objectId
                : objectId // ignore: cast_nullable_to_non_nullable
                      as String?,
            courtNo: freezed == courtNo
                ? _value.courtNo
                : courtNo // ignore: cast_nullable_to_non_nullable
                      as int?,
            bookingDate: freezed == bookingDate
                ? _value.bookingDate
                : bookingDate // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            displayName: freezed == displayName
                ? _value.displayName
                : displayName // ignore: cast_nullable_to_non_nullable
                      as String?,
            profile: freezed == profile
                ? _value.profile
                : profile // ignore: cast_nullable_to_non_nullable
                      as BasicProfileDTO?,
            groupBookingId: freezed == groupBookingId
                ? _value.groupBookingId
                : groupBookingId // ignore: cast_nullable_to_non_nullable
                      as int?,
            isMine: null == isMine
                ? _value.isMine
                : isMine // ignore: cast_nullable_to_non_nullable
                      as bool,
            index: freezed == index
                ? _value.index
                : index // ignore: cast_nullable_to_non_nullable
                      as int?,
            profilePictureUrl: freezed == profilePictureUrl
                ? _value.profilePictureUrl
                : profilePictureUrl // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }

  /// Create a copy of BookingDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $BasicProfileDTOCopyWith<$Res>? get profile {
    if (_value.profile == null) {
      return null;
    }

    return $BasicProfileDTOCopyWith<$Res>(_value.profile!, (value) {
      return _then(_value.copyWith(profile: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$BookingDtoImplCopyWith<$Res>
    implements $BookingDtoCopyWith<$Res> {
  factory _$$BookingDtoImplCopyWith(
    _$BookingDtoImpl value,
    $Res Function(_$BookingDtoImpl) then,
  ) = __$$BookingDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String? objectId,
    int? courtNo,
    DateTime? bookingDate,
    String? displayName,
    BasicProfileDTO? profile,
    int? groupBookingId,
    bool isMine,
    int? index,
    String? profilePictureUrl,
  });

  @override
  $BasicProfileDTOCopyWith<$Res>? get profile;
}

/// @nodoc
class __$$BookingDtoImplCopyWithImpl<$Res>
    extends _$BookingDtoCopyWithImpl<$Res, _$BookingDtoImpl>
    implements _$$BookingDtoImplCopyWith<$Res> {
  __$$BookingDtoImplCopyWithImpl(
    _$BookingDtoImpl _value,
    $Res Function(_$BookingDtoImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of BookingDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? objectId = freezed,
    Object? courtNo = freezed,
    Object? bookingDate = freezed,
    Object? displayName = freezed,
    Object? profile = freezed,
    Object? groupBookingId = freezed,
    Object? isMine = null,
    Object? index = freezed,
    Object? profilePictureUrl = freezed,
  }) {
    return _then(
      _$BookingDtoImpl(
        objectId: freezed == objectId
            ? _value.objectId
            : objectId // ignore: cast_nullable_to_non_nullable
                  as String?,
        courtNo: freezed == courtNo
            ? _value.courtNo
            : courtNo // ignore: cast_nullable_to_non_nullable
                  as int?,
        bookingDate: freezed == bookingDate
            ? _value.bookingDate
            : bookingDate // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        displayName: freezed == displayName
            ? _value.displayName
            : displayName // ignore: cast_nullable_to_non_nullable
                  as String?,
        profile: freezed == profile
            ? _value.profile
            : profile // ignore: cast_nullable_to_non_nullable
                  as BasicProfileDTO?,
        groupBookingId: freezed == groupBookingId
            ? _value.groupBookingId
            : groupBookingId // ignore: cast_nullable_to_non_nullable
                  as int?,
        isMine: null == isMine
            ? _value.isMine
            : isMine // ignore: cast_nullable_to_non_nullable
                  as bool,
        index: freezed == index
            ? _value.index
            : index // ignore: cast_nullable_to_non_nullable
                  as int?,
        profilePictureUrl: freezed == profilePictureUrl
            ? _value.profilePictureUrl
            : profilePictureUrl // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc

class _$BookingDtoImpl extends _BookingDto {
  const _$BookingDtoImpl({
    required this.objectId,
    required this.courtNo,
    required this.bookingDate,
    required this.displayName,
    required this.profile,
    required this.groupBookingId,
    required this.isMine,
    required this.index,
    this.profilePictureUrl,
  }) : super._();

  @override
  final String? objectId;
  @override
  final int? courtNo;
  @override
  final DateTime? bookingDate;
  @override
  final String? displayName;
  @override
  final BasicProfileDTO? profile;
  @override
  final int? groupBookingId;
  @override
  final bool isMine;
  @override
  final int? index;
  @override
  final String? profilePictureUrl;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BookingDtoImpl &&
            (identical(other.objectId, objectId) ||
                other.objectId == objectId) &&
            (identical(other.courtNo, courtNo) || other.courtNo == courtNo) &&
            (identical(other.bookingDate, bookingDate) ||
                other.bookingDate == bookingDate) &&
            (identical(other.displayName, displayName) ||
                other.displayName == displayName) &&
            (identical(other.profile, profile) || other.profile == profile) &&
            (identical(other.groupBookingId, groupBookingId) ||
                other.groupBookingId == groupBookingId) &&
            (identical(other.isMine, isMine) || other.isMine == isMine) &&
            (identical(other.index, index) || other.index == index) &&
            (identical(other.profilePictureUrl, profilePictureUrl) ||
                other.profilePictureUrl == profilePictureUrl));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    objectId,
    courtNo,
    bookingDate,
    displayName,
    profile,
    groupBookingId,
    isMine,
    index,
    profilePictureUrl,
  );

  /// Create a copy of BookingDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$BookingDtoImplCopyWith<_$BookingDtoImpl> get copyWith =>
      __$$BookingDtoImplCopyWithImpl<_$BookingDtoImpl>(this, _$identity);
}

abstract class _BookingDto extends BookingDto {
  const factory _BookingDto({
    required final String? objectId,
    required final int? courtNo,
    required final DateTime? bookingDate,
    required final String? displayName,
    required final BasicProfileDTO? profile,
    required final int? groupBookingId,
    required final bool isMine,
    required final int? index,
    final String? profilePictureUrl,
  }) = _$BookingDtoImpl;
  const _BookingDto._() : super._();

  @override
  String? get objectId;
  @override
  int? get courtNo;
  @override
  DateTime? get bookingDate;
  @override
  String? get displayName;
  @override
  BasicProfileDTO? get profile;
  @override
  int? get groupBookingId;
  @override
  bool get isMine;
  @override
  int? get index;
  @override
  String? get profilePictureUrl;

  /// Create a copy of BookingDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$BookingDtoImplCopyWith<_$BookingDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
