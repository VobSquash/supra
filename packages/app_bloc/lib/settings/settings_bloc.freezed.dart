// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'settings_bloc.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$SettingsEvent {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() onLoadSettings,
    required TResult Function() onResetSettings,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? onLoadSettings,
    TResult? Function()? onResetSettings,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? onLoadSettings,
    TResult Function()? onResetSettings,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(OnLoadSettings value) onLoadSettings,
    required TResult Function(OnResetSettings value) onResetSettings,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(OnLoadSettings value)? onLoadSettings,
    TResult? Function(OnResetSettings value)? onResetSettings,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(OnLoadSettings value)? onLoadSettings,
    TResult Function(OnResetSettings value)? onResetSettings,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SettingsEventCopyWith<$Res> {
  factory $SettingsEventCopyWith(
    SettingsEvent value,
    $Res Function(SettingsEvent) then,
  ) = _$SettingsEventCopyWithImpl<$Res, SettingsEvent>;
}

/// @nodoc
class _$SettingsEventCopyWithImpl<$Res, $Val extends SettingsEvent>
    implements $SettingsEventCopyWith<$Res> {
  _$SettingsEventCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SettingsEvent
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc
abstract class _$$OnLoadSettingsImplCopyWith<$Res> {
  factory _$$OnLoadSettingsImplCopyWith(
    _$OnLoadSettingsImpl value,
    $Res Function(_$OnLoadSettingsImpl) then,
  ) = __$$OnLoadSettingsImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$OnLoadSettingsImplCopyWithImpl<$Res>
    extends _$SettingsEventCopyWithImpl<$Res, _$OnLoadSettingsImpl>
    implements _$$OnLoadSettingsImplCopyWith<$Res> {
  __$$OnLoadSettingsImplCopyWithImpl(
    _$OnLoadSettingsImpl _value,
    $Res Function(_$OnLoadSettingsImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of SettingsEvent
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$OnLoadSettingsImpl implements OnLoadSettings {
  const _$OnLoadSettingsImpl();

  @override
  String toString() {
    return 'SettingsEvent.onLoadSettings()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$OnLoadSettingsImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() onLoadSettings,
    required TResult Function() onResetSettings,
  }) {
    return onLoadSettings();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? onLoadSettings,
    TResult? Function()? onResetSettings,
  }) {
    return onLoadSettings?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? onLoadSettings,
    TResult Function()? onResetSettings,
    required TResult orElse(),
  }) {
    if (onLoadSettings != null) {
      return onLoadSettings();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(OnLoadSettings value) onLoadSettings,
    required TResult Function(OnResetSettings value) onResetSettings,
  }) {
    return onLoadSettings(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(OnLoadSettings value)? onLoadSettings,
    TResult? Function(OnResetSettings value)? onResetSettings,
  }) {
    return onLoadSettings?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(OnLoadSettings value)? onLoadSettings,
    TResult Function(OnResetSettings value)? onResetSettings,
    required TResult orElse(),
  }) {
    if (onLoadSettings != null) {
      return onLoadSettings(this);
    }
    return orElse();
  }
}

abstract class OnLoadSettings implements SettingsEvent {
  const factory OnLoadSettings() = _$OnLoadSettingsImpl;
}

/// @nodoc
abstract class _$$OnResetSettingsImplCopyWith<$Res> {
  factory _$$OnResetSettingsImplCopyWith(
    _$OnResetSettingsImpl value,
    $Res Function(_$OnResetSettingsImpl) then,
  ) = __$$OnResetSettingsImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$OnResetSettingsImplCopyWithImpl<$Res>
    extends _$SettingsEventCopyWithImpl<$Res, _$OnResetSettingsImpl>
    implements _$$OnResetSettingsImplCopyWith<$Res> {
  __$$OnResetSettingsImplCopyWithImpl(
    _$OnResetSettingsImpl _value,
    $Res Function(_$OnResetSettingsImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of SettingsEvent
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$OnResetSettingsImpl implements OnResetSettings {
  const _$OnResetSettingsImpl();

  @override
  String toString() {
    return 'SettingsEvent.onResetSettings()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$OnResetSettingsImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() onLoadSettings,
    required TResult Function() onResetSettings,
  }) {
    return onResetSettings();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? onLoadSettings,
    TResult? Function()? onResetSettings,
  }) {
    return onResetSettings?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? onLoadSettings,
    TResult Function()? onResetSettings,
    required TResult orElse(),
  }) {
    if (onResetSettings != null) {
      return onResetSettings();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(OnLoadSettings value) onLoadSettings,
    required TResult Function(OnResetSettings value) onResetSettings,
  }) {
    return onResetSettings(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(OnLoadSettings value)? onLoadSettings,
    TResult? Function(OnResetSettings value)? onResetSettings,
  }) {
    return onResetSettings?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(OnLoadSettings value)? onLoadSettings,
    TResult Function(OnResetSettings value)? onResetSettings,
    required TResult orElse(),
  }) {
    if (onResetSettings != null) {
      return onResetSettings(this);
    }
    return orElse();
  }
}

abstract class OnResetSettings implements SettingsEvent {
  const factory OnResetSettings() = _$OnResetSettingsImpl;
}

/// @nodoc
mixin _$SettingsState {
  SettingsDTO get settings => throw _privateConstructorUsedError;
  BaseLoading get status => throw _privateConstructorUsedError;

  /// Create a copy of SettingsState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SettingsStateCopyWith<SettingsState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SettingsStateCopyWith<$Res> {
  factory $SettingsStateCopyWith(
    SettingsState value,
    $Res Function(SettingsState) then,
  ) = _$SettingsStateCopyWithImpl<$Res, SettingsState>;
  @useResult
  $Res call({SettingsDTO settings, BaseLoading status});

  $SettingsDTOCopyWith<$Res> get settings;
  $BaseLoadingCopyWith<$Res> get status;
}

/// @nodoc
class _$SettingsStateCopyWithImpl<$Res, $Val extends SettingsState>
    implements $SettingsStateCopyWith<$Res> {
  _$SettingsStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SettingsState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? settings = null, Object? status = null}) {
    return _then(
      _value.copyWith(
            settings: null == settings
                ? _value.settings
                : settings // ignore: cast_nullable_to_non_nullable
                      as SettingsDTO,
            status: null == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as BaseLoading,
          )
          as $Val,
    );
  }

  /// Create a copy of SettingsState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $SettingsDTOCopyWith<$Res> get settings {
    return $SettingsDTOCopyWith<$Res>(_value.settings, (value) {
      return _then(_value.copyWith(settings: value) as $Val);
    });
  }

  /// Create a copy of SettingsState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $BaseLoadingCopyWith<$Res> get status {
    return $BaseLoadingCopyWith<$Res>(_value.status, (value) {
      return _then(_value.copyWith(status: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$SettingsStateImplCopyWith<$Res>
    implements $SettingsStateCopyWith<$Res> {
  factory _$$SettingsStateImplCopyWith(
    _$SettingsStateImpl value,
    $Res Function(_$SettingsStateImpl) then,
  ) = __$$SettingsStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({SettingsDTO settings, BaseLoading status});

  @override
  $SettingsDTOCopyWith<$Res> get settings;
  @override
  $BaseLoadingCopyWith<$Res> get status;
}

/// @nodoc
class __$$SettingsStateImplCopyWithImpl<$Res>
    extends _$SettingsStateCopyWithImpl<$Res, _$SettingsStateImpl>
    implements _$$SettingsStateImplCopyWith<$Res> {
  __$$SettingsStateImplCopyWithImpl(
    _$SettingsStateImpl _value,
    $Res Function(_$SettingsStateImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of SettingsState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? settings = null, Object? status = null}) {
    return _then(
      _$SettingsStateImpl(
        settings: null == settings
            ? _value.settings
            : settings // ignore: cast_nullable_to_non_nullable
                  as SettingsDTO,
        status: null == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as BaseLoading,
      ),
    );
  }
}

/// @nodoc

class _$SettingsStateImpl implements _SettingsState {
  const _$SettingsStateImpl({required this.settings, required this.status});

  @override
  final SettingsDTO settings;
  @override
  final BaseLoading status;

  @override
  String toString() {
    return 'SettingsState(settings: $settings, status: $status)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SettingsStateImpl &&
            (identical(other.settings, settings) ||
                other.settings == settings) &&
            (identical(other.status, status) || other.status == status));
  }

  @override
  int get hashCode => Object.hash(runtimeType, settings, status);

  /// Create a copy of SettingsState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SettingsStateImplCopyWith<_$SettingsStateImpl> get copyWith =>
      __$$SettingsStateImplCopyWithImpl<_$SettingsStateImpl>(this, _$identity);
}

abstract class _SettingsState implements SettingsState {
  const factory _SettingsState({
    required final SettingsDTO settings,
    required final BaseLoading status,
  }) = _$SettingsStateImpl;

  @override
  SettingsDTO get settings;
  @override
  BaseLoading get status;

  /// Create a copy of SettingsState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SettingsStateImplCopyWith<_$SettingsStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
