// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'ladder_item_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$LadderItemDTO {
  String? get objectId => throw _privateConstructorUsedError;
  String? get vobGuid => throw _privateConstructorUsedError;
  int? get order => throw _privateConstructorUsedError;
  BasicProfileDTO? get profile => throw _privateConstructorUsedError;
  int? get team => throw _privateConstructorUsedError;
  bool? get canBeChallenged => throw _privateConstructorUsedError;

  /// Create a copy of LadderItemDTO
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $LadderItemDTOCopyWith<LadderItemDTO> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LadderItemDTOCopyWith<$Res> {
  factory $LadderItemDTOCopyWith(
    LadderItemDTO value,
    $Res Function(LadderItemDTO) then,
  ) = _$LadderItemDTOCopyWithImpl<$Res, LadderItemDTO>;
  @useResult
  $Res call({
    String? objectId,
    String? vobGuid,
    int? order,
    BasicProfileDTO? profile,
    int? team,
    bool? canBeChallenged,
  });

  $BasicProfileDTOCopyWith<$Res>? get profile;
}

/// @nodoc
class _$LadderItemDTOCopyWithImpl<$Res, $Val extends LadderItemDTO>
    implements $LadderItemDTOCopyWith<$Res> {
  _$LadderItemDTOCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of LadderItemDTO
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? objectId = freezed,
    Object? vobGuid = freezed,
    Object? order = freezed,
    Object? profile = freezed,
    Object? team = freezed,
    Object? canBeChallenged = freezed,
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
            order: freezed == order
                ? _value.order
                : order // ignore: cast_nullable_to_non_nullable
                      as int?,
            profile: freezed == profile
                ? _value.profile
                : profile // ignore: cast_nullable_to_non_nullable
                      as BasicProfileDTO?,
            team: freezed == team
                ? _value.team
                : team // ignore: cast_nullable_to_non_nullable
                      as int?,
            canBeChallenged: freezed == canBeChallenged
                ? _value.canBeChallenged
                : canBeChallenged // ignore: cast_nullable_to_non_nullable
                      as bool?,
          )
          as $Val,
    );
  }

  /// Create a copy of LadderItemDTO
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
abstract class _$$LadderItemDTOImplCopyWith<$Res>
    implements $LadderItemDTOCopyWith<$Res> {
  factory _$$LadderItemDTOImplCopyWith(
    _$LadderItemDTOImpl value,
    $Res Function(_$LadderItemDTOImpl) then,
  ) = __$$LadderItemDTOImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String? objectId,
    String? vobGuid,
    int? order,
    BasicProfileDTO? profile,
    int? team,
    bool? canBeChallenged,
  });

  @override
  $BasicProfileDTOCopyWith<$Res>? get profile;
}

/// @nodoc
class __$$LadderItemDTOImplCopyWithImpl<$Res>
    extends _$LadderItemDTOCopyWithImpl<$Res, _$LadderItemDTOImpl>
    implements _$$LadderItemDTOImplCopyWith<$Res> {
  __$$LadderItemDTOImplCopyWithImpl(
    _$LadderItemDTOImpl _value,
    $Res Function(_$LadderItemDTOImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of LadderItemDTO
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? objectId = freezed,
    Object? vobGuid = freezed,
    Object? order = freezed,
    Object? profile = freezed,
    Object? team = freezed,
    Object? canBeChallenged = freezed,
  }) {
    return _then(
      _$LadderItemDTOImpl(
        objectId: freezed == objectId
            ? _value.objectId
            : objectId // ignore: cast_nullable_to_non_nullable
                  as String?,
        vobGuid: freezed == vobGuid
            ? _value.vobGuid
            : vobGuid // ignore: cast_nullable_to_non_nullable
                  as String?,
        order: freezed == order
            ? _value.order
            : order // ignore: cast_nullable_to_non_nullable
                  as int?,
        profile: freezed == profile
            ? _value.profile
            : profile // ignore: cast_nullable_to_non_nullable
                  as BasicProfileDTO?,
        team: freezed == team
            ? _value.team
            : team // ignore: cast_nullable_to_non_nullable
                  as int?,
        canBeChallenged: freezed == canBeChallenged
            ? _value.canBeChallenged
            : canBeChallenged // ignore: cast_nullable_to_non_nullable
                  as bool?,
      ),
    );
  }
}

/// @nodoc

class _$LadderItemDTOImpl extends _LadderItemDTO {
  const _$LadderItemDTOImpl({
    required this.objectId,
    required this.vobGuid,
    required this.order,
    required this.profile,
    required this.team,
    required this.canBeChallenged,
  }) : super._();

  @override
  final String? objectId;
  @override
  final String? vobGuid;
  @override
  final int? order;
  @override
  final BasicProfileDTO? profile;
  @override
  final int? team;
  @override
  final bool? canBeChallenged;

  @override
  String toString() {
    return 'LadderItemDTO(objectId: $objectId, vobGuid: $vobGuid, order: $order, profile: $profile, team: $team, canBeChallenged: $canBeChallenged)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LadderItemDTOImpl &&
            (identical(other.objectId, objectId) ||
                other.objectId == objectId) &&
            (identical(other.vobGuid, vobGuid) || other.vobGuid == vobGuid) &&
            (identical(other.order, order) || other.order == order) &&
            (identical(other.profile, profile) || other.profile == profile) &&
            (identical(other.team, team) || other.team == team) &&
            (identical(other.canBeChallenged, canBeChallenged) ||
                other.canBeChallenged == canBeChallenged));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    objectId,
    vobGuid,
    order,
    profile,
    team,
    canBeChallenged,
  );

  /// Create a copy of LadderItemDTO
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$LadderItemDTOImplCopyWith<_$LadderItemDTOImpl> get copyWith =>
      __$$LadderItemDTOImplCopyWithImpl<_$LadderItemDTOImpl>(this, _$identity);
}

abstract class _LadderItemDTO extends LadderItemDTO {
  const factory _LadderItemDTO({
    required final String? objectId,
    required final String? vobGuid,
    required final int? order,
    required final BasicProfileDTO? profile,
    required final int? team,
    required final bool? canBeChallenged,
  }) = _$LadderItemDTOImpl;
  const _LadderItemDTO._() : super._();

  @override
  String? get objectId;
  @override
  String? get vobGuid;
  @override
  int? get order;
  @override
  BasicProfileDTO? get profile;
  @override
  int? get team;
  @override
  bool? get canBeChallenged;

  /// Create a copy of LadderItemDTO
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$LadderItemDTOImplCopyWith<_$LadderItemDTOImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
