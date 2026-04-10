// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'locations_bloc.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$LocationsEvent {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() onLoadLocations,
    required TResult Function() onResetLocations,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? onLoadLocations,
    TResult? Function()? onResetLocations,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? onLoadLocations,
    TResult Function()? onResetLocations,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(OnLoadLocations value) onLoadLocations,
    required TResult Function(OnResetLocations value) onResetLocations,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(OnLoadLocations value)? onLoadLocations,
    TResult? Function(OnResetLocations value)? onResetLocations,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(OnLoadLocations value)? onLoadLocations,
    TResult Function(OnResetLocations value)? onResetLocations,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LocationsEventCopyWith<$Res> {
  factory $LocationsEventCopyWith(
    LocationsEvent value,
    $Res Function(LocationsEvent) then,
  ) = _$LocationsEventCopyWithImpl<$Res, LocationsEvent>;
}

/// @nodoc
class _$LocationsEventCopyWithImpl<$Res, $Val extends LocationsEvent>
    implements $LocationsEventCopyWith<$Res> {
  _$LocationsEventCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of LocationsEvent
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc
abstract class _$$OnLoadLocationsImplCopyWith<$Res> {
  factory _$$OnLoadLocationsImplCopyWith(
    _$OnLoadLocationsImpl value,
    $Res Function(_$OnLoadLocationsImpl) then,
  ) = __$$OnLoadLocationsImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$OnLoadLocationsImplCopyWithImpl<$Res>
    extends _$LocationsEventCopyWithImpl<$Res, _$OnLoadLocationsImpl>
    implements _$$OnLoadLocationsImplCopyWith<$Res> {
  __$$OnLoadLocationsImplCopyWithImpl(
    _$OnLoadLocationsImpl _value,
    $Res Function(_$OnLoadLocationsImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of LocationsEvent
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$OnLoadLocationsImpl implements OnLoadLocations {
  const _$OnLoadLocationsImpl();

  @override
  String toString() {
    return 'LocationsEvent.onLoadLocations()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$OnLoadLocationsImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() onLoadLocations,
    required TResult Function() onResetLocations,
  }) {
    return onLoadLocations();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? onLoadLocations,
    TResult? Function()? onResetLocations,
  }) {
    return onLoadLocations?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? onLoadLocations,
    TResult Function()? onResetLocations,
    required TResult orElse(),
  }) {
    if (onLoadLocations != null) {
      return onLoadLocations();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(OnLoadLocations value) onLoadLocations,
    required TResult Function(OnResetLocations value) onResetLocations,
  }) {
    return onLoadLocations(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(OnLoadLocations value)? onLoadLocations,
    TResult? Function(OnResetLocations value)? onResetLocations,
  }) {
    return onLoadLocations?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(OnLoadLocations value)? onLoadLocations,
    TResult Function(OnResetLocations value)? onResetLocations,
    required TResult orElse(),
  }) {
    if (onLoadLocations != null) {
      return onLoadLocations(this);
    }
    return orElse();
  }
}

abstract class OnLoadLocations implements LocationsEvent {
  const factory OnLoadLocations() = _$OnLoadLocationsImpl;
}

/// @nodoc
abstract class _$$OnResetLocationsImplCopyWith<$Res> {
  factory _$$OnResetLocationsImplCopyWith(
    _$OnResetLocationsImpl value,
    $Res Function(_$OnResetLocationsImpl) then,
  ) = __$$OnResetLocationsImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$OnResetLocationsImplCopyWithImpl<$Res>
    extends _$LocationsEventCopyWithImpl<$Res, _$OnResetLocationsImpl>
    implements _$$OnResetLocationsImplCopyWith<$Res> {
  __$$OnResetLocationsImplCopyWithImpl(
    _$OnResetLocationsImpl _value,
    $Res Function(_$OnResetLocationsImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of LocationsEvent
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$OnResetLocationsImpl implements OnResetLocations {
  const _$OnResetLocationsImpl();

  @override
  String toString() {
    return 'LocationsEvent.onResetLocations()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$OnResetLocationsImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() onLoadLocations,
    required TResult Function() onResetLocations,
  }) {
    return onResetLocations();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? onLoadLocations,
    TResult? Function()? onResetLocations,
  }) {
    return onResetLocations?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? onLoadLocations,
    TResult Function()? onResetLocations,
    required TResult orElse(),
  }) {
    if (onResetLocations != null) {
      return onResetLocations();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(OnLoadLocations value) onLoadLocations,
    required TResult Function(OnResetLocations value) onResetLocations,
  }) {
    return onResetLocations(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(OnLoadLocations value)? onLoadLocations,
    TResult? Function(OnResetLocations value)? onResetLocations,
  }) {
    return onResetLocations?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(OnLoadLocations value)? onLoadLocations,
    TResult Function(OnResetLocations value)? onResetLocations,
    required TResult orElse(),
  }) {
    if (onResetLocations != null) {
      return onResetLocations(this);
    }
    return orElse();
  }
}

abstract class OnResetLocations implements LocationsEvent {
  const factory OnResetLocations() = _$OnResetLocationsImpl;
}

/// @nodoc
mixin _$LocationsState {
  List<LocationsItemDTO> get locations => throw _privateConstructorUsedError;
  BaseLoading get status => throw _privateConstructorUsedError;

  /// Create a copy of LocationsState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $LocationsStateCopyWith<LocationsState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LocationsStateCopyWith<$Res> {
  factory $LocationsStateCopyWith(
    LocationsState value,
    $Res Function(LocationsState) then,
  ) = _$LocationsStateCopyWithImpl<$Res, LocationsState>;
  @useResult
  $Res call({List<LocationsItemDTO> locations, BaseLoading status});

  $BaseLoadingCopyWith<$Res> get status;
}

/// @nodoc
class _$LocationsStateCopyWithImpl<$Res, $Val extends LocationsState>
    implements $LocationsStateCopyWith<$Res> {
  _$LocationsStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of LocationsState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? locations = null, Object? status = null}) {
    return _then(
      _value.copyWith(
            locations: null == locations
                ? _value.locations
                : locations // ignore: cast_nullable_to_non_nullable
                      as List<LocationsItemDTO>,
            status: null == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as BaseLoading,
          )
          as $Val,
    );
  }

  /// Create a copy of LocationsState
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
abstract class _$$LocationsStateImplCopyWith<$Res>
    implements $LocationsStateCopyWith<$Res> {
  factory _$$LocationsStateImplCopyWith(
    _$LocationsStateImpl value,
    $Res Function(_$LocationsStateImpl) then,
  ) = __$$LocationsStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({List<LocationsItemDTO> locations, BaseLoading status});

  @override
  $BaseLoadingCopyWith<$Res> get status;
}

/// @nodoc
class __$$LocationsStateImplCopyWithImpl<$Res>
    extends _$LocationsStateCopyWithImpl<$Res, _$LocationsStateImpl>
    implements _$$LocationsStateImplCopyWith<$Res> {
  __$$LocationsStateImplCopyWithImpl(
    _$LocationsStateImpl _value,
    $Res Function(_$LocationsStateImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of LocationsState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? locations = null, Object? status = null}) {
    return _then(
      _$LocationsStateImpl(
        locations: null == locations
            ? _value._locations
            : locations // ignore: cast_nullable_to_non_nullable
                  as List<LocationsItemDTO>,
        status: null == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as BaseLoading,
      ),
    );
  }
}

/// @nodoc

class _$LocationsStateImpl implements _LocationsState {
  const _$LocationsStateImpl({
    required final List<LocationsItemDTO> locations,
    required this.status,
  }) : _locations = locations;

  final List<LocationsItemDTO> _locations;
  @override
  List<LocationsItemDTO> get locations {
    if (_locations is EqualUnmodifiableListView) return _locations;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_locations);
  }

  @override
  final BaseLoading status;

  @override
  String toString() {
    return 'LocationsState(locations: $locations, status: $status)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LocationsStateImpl &&
            const DeepCollectionEquality().equals(
              other._locations,
              _locations,
            ) &&
            (identical(other.status, status) || other.status == status));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    const DeepCollectionEquality().hash(_locations),
    status,
  );

  /// Create a copy of LocationsState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$LocationsStateImplCopyWith<_$LocationsStateImpl> get copyWith =>
      __$$LocationsStateImplCopyWithImpl<_$LocationsStateImpl>(
        this,
        _$identity,
      );
}

abstract class _LocationsState implements LocationsState {
  const factory _LocationsState({
    required final List<LocationsItemDTO> locations,
    required final BaseLoading status,
  }) = _$LocationsStateImpl;

  @override
  List<LocationsItemDTO> get locations;
  @override
  BaseLoading get status;

  /// Create a copy of LocationsState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$LocationsStateImplCopyWith<_$LocationsStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
