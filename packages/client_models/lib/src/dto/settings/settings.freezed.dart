// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'settings.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$SettingsDTO {
  BreakdownTeamsDTO get ladderBreakdown => throw _privateConstructorUsedError;
  SystemSettingsDTO get systemSettings => throw _privateConstructorUsedError;
  FeesDTO get fees => throw _privateConstructorUsedError;

  /// Create a copy of SettingsDTO
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SettingsDTOCopyWith<SettingsDTO> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SettingsDTOCopyWith<$Res> {
  factory $SettingsDTOCopyWith(
    SettingsDTO value,
    $Res Function(SettingsDTO) then,
  ) = _$SettingsDTOCopyWithImpl<$Res, SettingsDTO>;
  @useResult
  $Res call({
    BreakdownTeamsDTO ladderBreakdown,
    SystemSettingsDTO systemSettings,
    FeesDTO fees,
  });

  $BreakdownTeamsDTOCopyWith<$Res> get ladderBreakdown;
  $SystemSettingsDTOCopyWith<$Res> get systemSettings;
  $FeesDTOCopyWith<$Res> get fees;
}

/// @nodoc
class _$SettingsDTOCopyWithImpl<$Res, $Val extends SettingsDTO>
    implements $SettingsDTOCopyWith<$Res> {
  _$SettingsDTOCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SettingsDTO
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? ladderBreakdown = null,
    Object? systemSettings = null,
    Object? fees = null,
  }) {
    return _then(
      _value.copyWith(
            ladderBreakdown: null == ladderBreakdown
                ? _value.ladderBreakdown
                : ladderBreakdown // ignore: cast_nullable_to_non_nullable
                      as BreakdownTeamsDTO,
            systemSettings: null == systemSettings
                ? _value.systemSettings
                : systemSettings // ignore: cast_nullable_to_non_nullable
                      as SystemSettingsDTO,
            fees: null == fees
                ? _value.fees
                : fees // ignore: cast_nullable_to_non_nullable
                      as FeesDTO,
          )
          as $Val,
    );
  }

  /// Create a copy of SettingsDTO
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $BreakdownTeamsDTOCopyWith<$Res> get ladderBreakdown {
    return $BreakdownTeamsDTOCopyWith<$Res>(_value.ladderBreakdown, (value) {
      return _then(_value.copyWith(ladderBreakdown: value) as $Val);
    });
  }

  /// Create a copy of SettingsDTO
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $SystemSettingsDTOCopyWith<$Res> get systemSettings {
    return $SystemSettingsDTOCopyWith<$Res>(_value.systemSettings, (value) {
      return _then(_value.copyWith(systemSettings: value) as $Val);
    });
  }

  /// Create a copy of SettingsDTO
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $FeesDTOCopyWith<$Res> get fees {
    return $FeesDTOCopyWith<$Res>(_value.fees, (value) {
      return _then(_value.copyWith(fees: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$SettingsDTOImplCopyWith<$Res>
    implements $SettingsDTOCopyWith<$Res> {
  factory _$$SettingsDTOImplCopyWith(
    _$SettingsDTOImpl value,
    $Res Function(_$SettingsDTOImpl) then,
  ) = __$$SettingsDTOImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    BreakdownTeamsDTO ladderBreakdown,
    SystemSettingsDTO systemSettings,
    FeesDTO fees,
  });

  @override
  $BreakdownTeamsDTOCopyWith<$Res> get ladderBreakdown;
  @override
  $SystemSettingsDTOCopyWith<$Res> get systemSettings;
  @override
  $FeesDTOCopyWith<$Res> get fees;
}

/// @nodoc
class __$$SettingsDTOImplCopyWithImpl<$Res>
    extends _$SettingsDTOCopyWithImpl<$Res, _$SettingsDTOImpl>
    implements _$$SettingsDTOImplCopyWith<$Res> {
  __$$SettingsDTOImplCopyWithImpl(
    _$SettingsDTOImpl _value,
    $Res Function(_$SettingsDTOImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of SettingsDTO
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? ladderBreakdown = null,
    Object? systemSettings = null,
    Object? fees = null,
  }) {
    return _then(
      _$SettingsDTOImpl(
        ladderBreakdown: null == ladderBreakdown
            ? _value.ladderBreakdown
            : ladderBreakdown // ignore: cast_nullable_to_non_nullable
                  as BreakdownTeamsDTO,
        systemSettings: null == systemSettings
            ? _value.systemSettings
            : systemSettings // ignore: cast_nullable_to_non_nullable
                  as SystemSettingsDTO,
        fees: null == fees
            ? _value.fees
            : fees // ignore: cast_nullable_to_non_nullable
                  as FeesDTO,
      ),
    );
  }
}

/// @nodoc

class _$SettingsDTOImpl extends _SettingsDTO {
  const _$SettingsDTOImpl({
    required this.ladderBreakdown,
    required this.systemSettings,
    required this.fees,
  }) : super._();

  @override
  final BreakdownTeamsDTO ladderBreakdown;
  @override
  final SystemSettingsDTO systemSettings;
  @override
  final FeesDTO fees;

  @override
  String toString() {
    return 'SettingsDTO(ladderBreakdown: $ladderBreakdown, systemSettings: $systemSettings, fees: $fees)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SettingsDTOImpl &&
            (identical(other.ladderBreakdown, ladderBreakdown) ||
                other.ladderBreakdown == ladderBreakdown) &&
            (identical(other.systemSettings, systemSettings) ||
                other.systemSettings == systemSettings) &&
            (identical(other.fees, fees) || other.fees == fees));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, ladderBreakdown, systemSettings, fees);

  /// Create a copy of SettingsDTO
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SettingsDTOImplCopyWith<_$SettingsDTOImpl> get copyWith =>
      __$$SettingsDTOImplCopyWithImpl<_$SettingsDTOImpl>(this, _$identity);
}

abstract class _SettingsDTO extends SettingsDTO {
  const factory _SettingsDTO({
    required final BreakdownTeamsDTO ladderBreakdown,
    required final SystemSettingsDTO systemSettings,
    required final FeesDTO fees,
  }) = _$SettingsDTOImpl;
  const _SettingsDTO._() : super._();

  @override
  BreakdownTeamsDTO get ladderBreakdown;
  @override
  SystemSettingsDTO get systemSettings;
  @override
  FeesDTO get fees;

  /// Create a copy of SettingsDTO
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SettingsDTOImplCopyWith<_$SettingsDTOImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
