// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'system_settings.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

SystemSettingsDTO _$SystemSettingsDTOFromJson(Map<String, dynamic> json) {
  return _SystemSettingsDTO.fromJson(json);
}

/// @nodoc
mixin _$SystemSettingsDTO {
  String get objectId => throw _privateConstructorUsedError;
  bool get showLadderBreakdown => throw _privateConstructorUsedError;

  /// Serializes this SystemSettingsDTO to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SystemSettingsDTO
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SystemSettingsDTOCopyWith<SystemSettingsDTO> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SystemSettingsDTOCopyWith<$Res> {
  factory $SystemSettingsDTOCopyWith(
    SystemSettingsDTO value,
    $Res Function(SystemSettingsDTO) then,
  ) = _$SystemSettingsDTOCopyWithImpl<$Res, SystemSettingsDTO>;
  @useResult
  $Res call({String objectId, bool showLadderBreakdown});
}

/// @nodoc
class _$SystemSettingsDTOCopyWithImpl<$Res, $Val extends SystemSettingsDTO>
    implements $SystemSettingsDTOCopyWith<$Res> {
  _$SystemSettingsDTOCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SystemSettingsDTO
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? objectId = null, Object? showLadderBreakdown = null}) {
    return _then(
      _value.copyWith(
            objectId: null == objectId
                ? _value.objectId
                : objectId // ignore: cast_nullable_to_non_nullable
                      as String,
            showLadderBreakdown: null == showLadderBreakdown
                ? _value.showLadderBreakdown
                : showLadderBreakdown // ignore: cast_nullable_to_non_nullable
                      as bool,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$SystemSettingsDTOImplCopyWith<$Res>
    implements $SystemSettingsDTOCopyWith<$Res> {
  factory _$$SystemSettingsDTOImplCopyWith(
    _$SystemSettingsDTOImpl value,
    $Res Function(_$SystemSettingsDTOImpl) then,
  ) = __$$SystemSettingsDTOImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String objectId, bool showLadderBreakdown});
}

/// @nodoc
class __$$SystemSettingsDTOImplCopyWithImpl<$Res>
    extends _$SystemSettingsDTOCopyWithImpl<$Res, _$SystemSettingsDTOImpl>
    implements _$$SystemSettingsDTOImplCopyWith<$Res> {
  __$$SystemSettingsDTOImplCopyWithImpl(
    _$SystemSettingsDTOImpl _value,
    $Res Function(_$SystemSettingsDTOImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of SystemSettingsDTO
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? objectId = null, Object? showLadderBreakdown = null}) {
    return _then(
      _$SystemSettingsDTOImpl(
        objectId: null == objectId
            ? _value.objectId
            : objectId // ignore: cast_nullable_to_non_nullable
                  as String,
        showLadderBreakdown: null == showLadderBreakdown
            ? _value.showLadderBreakdown
            : showLadderBreakdown // ignore: cast_nullable_to_non_nullable
                  as bool,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$SystemSettingsDTOImpl extends _SystemSettingsDTO {
  const _$SystemSettingsDTOImpl({
    required this.objectId,
    required this.showLadderBreakdown,
  }) : super._();

  factory _$SystemSettingsDTOImpl.fromJson(Map<String, dynamic> json) =>
      _$$SystemSettingsDTOImplFromJson(json);

  @override
  final String objectId;
  @override
  final bool showLadderBreakdown;

  @override
  String toString() {
    return 'SystemSettingsDTO(objectId: $objectId, showLadderBreakdown: $showLadderBreakdown)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SystemSettingsDTOImpl &&
            (identical(other.objectId, objectId) ||
                other.objectId == objectId) &&
            (identical(other.showLadderBreakdown, showLadderBreakdown) ||
                other.showLadderBreakdown == showLadderBreakdown));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, objectId, showLadderBreakdown);

  /// Create a copy of SystemSettingsDTO
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SystemSettingsDTOImplCopyWith<_$SystemSettingsDTOImpl> get copyWith =>
      __$$SystemSettingsDTOImplCopyWithImpl<_$SystemSettingsDTOImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$SystemSettingsDTOImplToJson(this);
  }
}

abstract class _SystemSettingsDTO extends SystemSettingsDTO {
  const factory _SystemSettingsDTO({
    required final String objectId,
    required final bool showLadderBreakdown,
  }) = _$SystemSettingsDTOImpl;
  const _SystemSettingsDTO._() : super._();

  factory _SystemSettingsDTO.fromJson(Map<String, dynamic> json) =
      _$SystemSettingsDTOImpl.fromJson;

  @override
  String get objectId;
  @override
  bool get showLadderBreakdown;

  /// Create a copy of SystemSettingsDTO
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SystemSettingsDTOImplCopyWith<_$SystemSettingsDTOImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
