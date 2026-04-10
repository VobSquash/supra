// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'users_bloc.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$UsersEvent {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() onLoadBasicProfiles,
    required TResult Function() onLoadActiveProfiles,
    required TResult Function(String vobGuid) onLoadByVobGuid,
    required TResult Function() reset,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? onLoadBasicProfiles,
    TResult? Function()? onLoadActiveProfiles,
    TResult? Function(String vobGuid)? onLoadByVobGuid,
    TResult? Function()? reset,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? onLoadBasicProfiles,
    TResult Function()? onLoadActiveProfiles,
    TResult Function(String vobGuid)? onLoadByVobGuid,
    TResult Function()? reset,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(OnLoadBasicProfiles value) onLoadBasicProfiles,
    required TResult Function(OnLoadActiveProfiles value) onLoadActiveProfiles,
    required TResult Function(OnLoadByVobGuid value) onLoadByVobGuid,
    required TResult Function(OnReset value) reset,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(OnLoadBasicProfiles value)? onLoadBasicProfiles,
    TResult? Function(OnLoadActiveProfiles value)? onLoadActiveProfiles,
    TResult? Function(OnLoadByVobGuid value)? onLoadByVobGuid,
    TResult? Function(OnReset value)? reset,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(OnLoadBasicProfiles value)? onLoadBasicProfiles,
    TResult Function(OnLoadActiveProfiles value)? onLoadActiveProfiles,
    TResult Function(OnLoadByVobGuid value)? onLoadByVobGuid,
    TResult Function(OnReset value)? reset,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UsersEventCopyWith<$Res> {
  factory $UsersEventCopyWith(
    UsersEvent value,
    $Res Function(UsersEvent) then,
  ) = _$UsersEventCopyWithImpl<$Res, UsersEvent>;
}

/// @nodoc
class _$UsersEventCopyWithImpl<$Res, $Val extends UsersEvent>
    implements $UsersEventCopyWith<$Res> {
  _$UsersEventCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of UsersEvent
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc
abstract class _$$OnLoadBasicProfilesImplCopyWith<$Res> {
  factory _$$OnLoadBasicProfilesImplCopyWith(
    _$OnLoadBasicProfilesImpl value,
    $Res Function(_$OnLoadBasicProfilesImpl) then,
  ) = __$$OnLoadBasicProfilesImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$OnLoadBasicProfilesImplCopyWithImpl<$Res>
    extends _$UsersEventCopyWithImpl<$Res, _$OnLoadBasicProfilesImpl>
    implements _$$OnLoadBasicProfilesImplCopyWith<$Res> {
  __$$OnLoadBasicProfilesImplCopyWithImpl(
    _$OnLoadBasicProfilesImpl _value,
    $Res Function(_$OnLoadBasicProfilesImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of UsersEvent
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$OnLoadBasicProfilesImpl implements OnLoadBasicProfiles {
  const _$OnLoadBasicProfilesImpl();

  @override
  String toString() {
    return 'UsersEvent.onLoadBasicProfiles()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$OnLoadBasicProfilesImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() onLoadBasicProfiles,
    required TResult Function() onLoadActiveProfiles,
    required TResult Function(String vobGuid) onLoadByVobGuid,
    required TResult Function() reset,
  }) {
    return onLoadBasicProfiles();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? onLoadBasicProfiles,
    TResult? Function()? onLoadActiveProfiles,
    TResult? Function(String vobGuid)? onLoadByVobGuid,
    TResult? Function()? reset,
  }) {
    return onLoadBasicProfiles?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? onLoadBasicProfiles,
    TResult Function()? onLoadActiveProfiles,
    TResult Function(String vobGuid)? onLoadByVobGuid,
    TResult Function()? reset,
    required TResult orElse(),
  }) {
    if (onLoadBasicProfiles != null) {
      return onLoadBasicProfiles();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(OnLoadBasicProfiles value) onLoadBasicProfiles,
    required TResult Function(OnLoadActiveProfiles value) onLoadActiveProfiles,
    required TResult Function(OnLoadByVobGuid value) onLoadByVobGuid,
    required TResult Function(OnReset value) reset,
  }) {
    return onLoadBasicProfiles(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(OnLoadBasicProfiles value)? onLoadBasicProfiles,
    TResult? Function(OnLoadActiveProfiles value)? onLoadActiveProfiles,
    TResult? Function(OnLoadByVobGuid value)? onLoadByVobGuid,
    TResult? Function(OnReset value)? reset,
  }) {
    return onLoadBasicProfiles?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(OnLoadBasicProfiles value)? onLoadBasicProfiles,
    TResult Function(OnLoadActiveProfiles value)? onLoadActiveProfiles,
    TResult Function(OnLoadByVobGuid value)? onLoadByVobGuid,
    TResult Function(OnReset value)? reset,
    required TResult orElse(),
  }) {
    if (onLoadBasicProfiles != null) {
      return onLoadBasicProfiles(this);
    }
    return orElse();
  }
}

abstract class OnLoadBasicProfiles implements UsersEvent {
  const factory OnLoadBasicProfiles() = _$OnLoadBasicProfilesImpl;
}

/// @nodoc
abstract class _$$OnLoadActiveProfilesImplCopyWith<$Res> {
  factory _$$OnLoadActiveProfilesImplCopyWith(
    _$OnLoadActiveProfilesImpl value,
    $Res Function(_$OnLoadActiveProfilesImpl) then,
  ) = __$$OnLoadActiveProfilesImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$OnLoadActiveProfilesImplCopyWithImpl<$Res>
    extends _$UsersEventCopyWithImpl<$Res, _$OnLoadActiveProfilesImpl>
    implements _$$OnLoadActiveProfilesImplCopyWith<$Res> {
  __$$OnLoadActiveProfilesImplCopyWithImpl(
    _$OnLoadActiveProfilesImpl _value,
    $Res Function(_$OnLoadActiveProfilesImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of UsersEvent
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$OnLoadActiveProfilesImpl implements OnLoadActiveProfiles {
  const _$OnLoadActiveProfilesImpl();

  @override
  String toString() {
    return 'UsersEvent.onLoadActiveProfiles()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$OnLoadActiveProfilesImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() onLoadBasicProfiles,
    required TResult Function() onLoadActiveProfiles,
    required TResult Function(String vobGuid) onLoadByVobGuid,
    required TResult Function() reset,
  }) {
    return onLoadActiveProfiles();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? onLoadBasicProfiles,
    TResult? Function()? onLoadActiveProfiles,
    TResult? Function(String vobGuid)? onLoadByVobGuid,
    TResult? Function()? reset,
  }) {
    return onLoadActiveProfiles?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? onLoadBasicProfiles,
    TResult Function()? onLoadActiveProfiles,
    TResult Function(String vobGuid)? onLoadByVobGuid,
    TResult Function()? reset,
    required TResult orElse(),
  }) {
    if (onLoadActiveProfiles != null) {
      return onLoadActiveProfiles();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(OnLoadBasicProfiles value) onLoadBasicProfiles,
    required TResult Function(OnLoadActiveProfiles value) onLoadActiveProfiles,
    required TResult Function(OnLoadByVobGuid value) onLoadByVobGuid,
    required TResult Function(OnReset value) reset,
  }) {
    return onLoadActiveProfiles(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(OnLoadBasicProfiles value)? onLoadBasicProfiles,
    TResult? Function(OnLoadActiveProfiles value)? onLoadActiveProfiles,
    TResult? Function(OnLoadByVobGuid value)? onLoadByVobGuid,
    TResult? Function(OnReset value)? reset,
  }) {
    return onLoadActiveProfiles?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(OnLoadBasicProfiles value)? onLoadBasicProfiles,
    TResult Function(OnLoadActiveProfiles value)? onLoadActiveProfiles,
    TResult Function(OnLoadByVobGuid value)? onLoadByVobGuid,
    TResult Function(OnReset value)? reset,
    required TResult orElse(),
  }) {
    if (onLoadActiveProfiles != null) {
      return onLoadActiveProfiles(this);
    }
    return orElse();
  }
}

abstract class OnLoadActiveProfiles implements UsersEvent {
  const factory OnLoadActiveProfiles() = _$OnLoadActiveProfilesImpl;
}

/// @nodoc
abstract class _$$OnLoadByVobGuidImplCopyWith<$Res> {
  factory _$$OnLoadByVobGuidImplCopyWith(
    _$OnLoadByVobGuidImpl value,
    $Res Function(_$OnLoadByVobGuidImpl) then,
  ) = __$$OnLoadByVobGuidImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String vobGuid});
}

/// @nodoc
class __$$OnLoadByVobGuidImplCopyWithImpl<$Res>
    extends _$UsersEventCopyWithImpl<$Res, _$OnLoadByVobGuidImpl>
    implements _$$OnLoadByVobGuidImplCopyWith<$Res> {
  __$$OnLoadByVobGuidImplCopyWithImpl(
    _$OnLoadByVobGuidImpl _value,
    $Res Function(_$OnLoadByVobGuidImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of UsersEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? vobGuid = null}) {
    return _then(
      _$OnLoadByVobGuidImpl(
        null == vobGuid
            ? _value.vobGuid
            : vobGuid // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc

class _$OnLoadByVobGuidImpl implements OnLoadByVobGuid {
  const _$OnLoadByVobGuidImpl(this.vobGuid);

  @override
  final String vobGuid;

  @override
  String toString() {
    return 'UsersEvent.onLoadByVobGuid(vobGuid: $vobGuid)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$OnLoadByVobGuidImpl &&
            (identical(other.vobGuid, vobGuid) || other.vobGuid == vobGuid));
  }

  @override
  int get hashCode => Object.hash(runtimeType, vobGuid);

  /// Create a copy of UsersEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$OnLoadByVobGuidImplCopyWith<_$OnLoadByVobGuidImpl> get copyWith =>
      __$$OnLoadByVobGuidImplCopyWithImpl<_$OnLoadByVobGuidImpl>(
        this,
        _$identity,
      );

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() onLoadBasicProfiles,
    required TResult Function() onLoadActiveProfiles,
    required TResult Function(String vobGuid) onLoadByVobGuid,
    required TResult Function() reset,
  }) {
    return onLoadByVobGuid(vobGuid);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? onLoadBasicProfiles,
    TResult? Function()? onLoadActiveProfiles,
    TResult? Function(String vobGuid)? onLoadByVobGuid,
    TResult? Function()? reset,
  }) {
    return onLoadByVobGuid?.call(vobGuid);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? onLoadBasicProfiles,
    TResult Function()? onLoadActiveProfiles,
    TResult Function(String vobGuid)? onLoadByVobGuid,
    TResult Function()? reset,
    required TResult orElse(),
  }) {
    if (onLoadByVobGuid != null) {
      return onLoadByVobGuid(vobGuid);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(OnLoadBasicProfiles value) onLoadBasicProfiles,
    required TResult Function(OnLoadActiveProfiles value) onLoadActiveProfiles,
    required TResult Function(OnLoadByVobGuid value) onLoadByVobGuid,
    required TResult Function(OnReset value) reset,
  }) {
    return onLoadByVobGuid(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(OnLoadBasicProfiles value)? onLoadBasicProfiles,
    TResult? Function(OnLoadActiveProfiles value)? onLoadActiveProfiles,
    TResult? Function(OnLoadByVobGuid value)? onLoadByVobGuid,
    TResult? Function(OnReset value)? reset,
  }) {
    return onLoadByVobGuid?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(OnLoadBasicProfiles value)? onLoadBasicProfiles,
    TResult Function(OnLoadActiveProfiles value)? onLoadActiveProfiles,
    TResult Function(OnLoadByVobGuid value)? onLoadByVobGuid,
    TResult Function(OnReset value)? reset,
    required TResult orElse(),
  }) {
    if (onLoadByVobGuid != null) {
      return onLoadByVobGuid(this);
    }
    return orElse();
  }
}

abstract class OnLoadByVobGuid implements UsersEvent {
  const factory OnLoadByVobGuid(final String vobGuid) = _$OnLoadByVobGuidImpl;

  String get vobGuid;

  /// Create a copy of UsersEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$OnLoadByVobGuidImplCopyWith<_$OnLoadByVobGuidImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$OnResetImplCopyWith<$Res> {
  factory _$$OnResetImplCopyWith(
    _$OnResetImpl value,
    $Res Function(_$OnResetImpl) then,
  ) = __$$OnResetImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$OnResetImplCopyWithImpl<$Res>
    extends _$UsersEventCopyWithImpl<$Res, _$OnResetImpl>
    implements _$$OnResetImplCopyWith<$Res> {
  __$$OnResetImplCopyWithImpl(
    _$OnResetImpl _value,
    $Res Function(_$OnResetImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of UsersEvent
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$OnResetImpl implements OnReset {
  const _$OnResetImpl();

  @override
  String toString() {
    return 'UsersEvent.reset()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$OnResetImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() onLoadBasicProfiles,
    required TResult Function() onLoadActiveProfiles,
    required TResult Function(String vobGuid) onLoadByVobGuid,
    required TResult Function() reset,
  }) {
    return reset();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? onLoadBasicProfiles,
    TResult? Function()? onLoadActiveProfiles,
    TResult? Function(String vobGuid)? onLoadByVobGuid,
    TResult? Function()? reset,
  }) {
    return reset?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? onLoadBasicProfiles,
    TResult Function()? onLoadActiveProfiles,
    TResult Function(String vobGuid)? onLoadByVobGuid,
    TResult Function()? reset,
    required TResult orElse(),
  }) {
    if (reset != null) {
      return reset();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(OnLoadBasicProfiles value) onLoadBasicProfiles,
    required TResult Function(OnLoadActiveProfiles value) onLoadActiveProfiles,
    required TResult Function(OnLoadByVobGuid value) onLoadByVobGuid,
    required TResult Function(OnReset value) reset,
  }) {
    return reset(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(OnLoadBasicProfiles value)? onLoadBasicProfiles,
    TResult? Function(OnLoadActiveProfiles value)? onLoadActiveProfiles,
    TResult? Function(OnLoadByVobGuid value)? onLoadByVobGuid,
    TResult? Function(OnReset value)? reset,
  }) {
    return reset?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(OnLoadBasicProfiles value)? onLoadBasicProfiles,
    TResult Function(OnLoadActiveProfiles value)? onLoadActiveProfiles,
    TResult Function(OnLoadByVobGuid value)? onLoadByVobGuid,
    TResult Function(OnReset value)? reset,
    required TResult orElse(),
  }) {
    if (reset != null) {
      return reset(this);
    }
    return orElse();
  }
}

abstract class OnReset implements UsersEvent {
  const factory OnReset() = _$OnResetImpl;
}

/// @nodoc
mixin _$UsersState {
  List<BasicProfileDTO> get profiles => throw _privateConstructorUsedError;
  BaseLoading get status => throw _privateConstructorUsedError;

  /// Create a copy of UsersState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $UsersStateCopyWith<UsersState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UsersStateCopyWith<$Res> {
  factory $UsersStateCopyWith(
    UsersState value,
    $Res Function(UsersState) then,
  ) = _$UsersStateCopyWithImpl<$Res, UsersState>;
  @useResult
  $Res call({List<BasicProfileDTO> profiles, BaseLoading status});

  $BaseLoadingCopyWith<$Res> get status;
}

/// @nodoc
class _$UsersStateCopyWithImpl<$Res, $Val extends UsersState>
    implements $UsersStateCopyWith<$Res> {
  _$UsersStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of UsersState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? profiles = null, Object? status = null}) {
    return _then(
      _value.copyWith(
            profiles: null == profiles
                ? _value.profiles
                : profiles // ignore: cast_nullable_to_non_nullable
                      as List<BasicProfileDTO>,
            status: null == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as BaseLoading,
          )
          as $Val,
    );
  }

  /// Create a copy of UsersState
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
abstract class _$$UsersStateImplCopyWith<$Res>
    implements $UsersStateCopyWith<$Res> {
  factory _$$UsersStateImplCopyWith(
    _$UsersStateImpl value,
    $Res Function(_$UsersStateImpl) then,
  ) = __$$UsersStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({List<BasicProfileDTO> profiles, BaseLoading status});

  @override
  $BaseLoadingCopyWith<$Res> get status;
}

/// @nodoc
class __$$UsersStateImplCopyWithImpl<$Res>
    extends _$UsersStateCopyWithImpl<$Res, _$UsersStateImpl>
    implements _$$UsersStateImplCopyWith<$Res> {
  __$$UsersStateImplCopyWithImpl(
    _$UsersStateImpl _value,
    $Res Function(_$UsersStateImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of UsersState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? profiles = null, Object? status = null}) {
    return _then(
      _$UsersStateImpl(
        profiles: null == profiles
            ? _value._profiles
            : profiles // ignore: cast_nullable_to_non_nullable
                  as List<BasicProfileDTO>,
        status: null == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as BaseLoading,
      ),
    );
  }
}

/// @nodoc

class _$UsersStateImpl implements _UsersState {
  const _$UsersStateImpl({
    required final List<BasicProfileDTO> profiles,
    required this.status,
  }) : _profiles = profiles;

  final List<BasicProfileDTO> _profiles;
  @override
  List<BasicProfileDTO> get profiles {
    if (_profiles is EqualUnmodifiableListView) return _profiles;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_profiles);
  }

  @override
  final BaseLoading status;

  @override
  String toString() {
    return 'UsersState(profiles: $profiles, status: $status)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UsersStateImpl &&
            const DeepCollectionEquality().equals(other._profiles, _profiles) &&
            (identical(other.status, status) || other.status == status));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    const DeepCollectionEquality().hash(_profiles),
    status,
  );

  /// Create a copy of UsersState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UsersStateImplCopyWith<_$UsersStateImpl> get copyWith =>
      __$$UsersStateImplCopyWithImpl<_$UsersStateImpl>(this, _$identity);
}

abstract class _UsersState implements UsersState {
  const factory _UsersState({
    required final List<BasicProfileDTO> profiles,
    required final BaseLoading status,
  }) = _$UsersStateImpl;

  @override
  List<BasicProfileDTO> get profiles;
  @override
  BaseLoading get status;

  /// Create a copy of UsersState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UsersStateImplCopyWith<_$UsersStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
