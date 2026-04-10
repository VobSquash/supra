// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'ladders_bloc.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$LaddersEvent {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() onLoadLadders,
    required TResult Function() onResetLadders,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? onLoadLadders,
    TResult? Function()? onResetLadders,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? onLoadLadders,
    TResult Function()? onResetLadders,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(OnLoadLadders value) onLoadLadders,
    required TResult Function(OnResetLadders value) onResetLadders,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(OnLoadLadders value)? onLoadLadders,
    TResult? Function(OnResetLadders value)? onResetLadders,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(OnLoadLadders value)? onLoadLadders,
    TResult Function(OnResetLadders value)? onResetLadders,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LaddersEventCopyWith<$Res> {
  factory $LaddersEventCopyWith(
    LaddersEvent value,
    $Res Function(LaddersEvent) then,
  ) = _$LaddersEventCopyWithImpl<$Res, LaddersEvent>;
}

/// @nodoc
class _$LaddersEventCopyWithImpl<$Res, $Val extends LaddersEvent>
    implements $LaddersEventCopyWith<$Res> {
  _$LaddersEventCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of LaddersEvent
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc
abstract class _$$OnLoadLaddersImplCopyWith<$Res> {
  factory _$$OnLoadLaddersImplCopyWith(
    _$OnLoadLaddersImpl value,
    $Res Function(_$OnLoadLaddersImpl) then,
  ) = __$$OnLoadLaddersImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$OnLoadLaddersImplCopyWithImpl<$Res>
    extends _$LaddersEventCopyWithImpl<$Res, _$OnLoadLaddersImpl>
    implements _$$OnLoadLaddersImplCopyWith<$Res> {
  __$$OnLoadLaddersImplCopyWithImpl(
    _$OnLoadLaddersImpl _value,
    $Res Function(_$OnLoadLaddersImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of LaddersEvent
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$OnLoadLaddersImpl implements OnLoadLadders {
  const _$OnLoadLaddersImpl();

  @override
  String toString() {
    return 'LaddersEvent.onLoadLadders()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$OnLoadLaddersImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() onLoadLadders,
    required TResult Function() onResetLadders,
  }) {
    return onLoadLadders();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? onLoadLadders,
    TResult? Function()? onResetLadders,
  }) {
    return onLoadLadders?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? onLoadLadders,
    TResult Function()? onResetLadders,
    required TResult orElse(),
  }) {
    if (onLoadLadders != null) {
      return onLoadLadders();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(OnLoadLadders value) onLoadLadders,
    required TResult Function(OnResetLadders value) onResetLadders,
  }) {
    return onLoadLadders(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(OnLoadLadders value)? onLoadLadders,
    TResult? Function(OnResetLadders value)? onResetLadders,
  }) {
    return onLoadLadders?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(OnLoadLadders value)? onLoadLadders,
    TResult Function(OnResetLadders value)? onResetLadders,
    required TResult orElse(),
  }) {
    if (onLoadLadders != null) {
      return onLoadLadders(this);
    }
    return orElse();
  }
}

abstract class OnLoadLadders implements LaddersEvent {
  const factory OnLoadLadders() = _$OnLoadLaddersImpl;
}

/// @nodoc
abstract class _$$OnResetLaddersImplCopyWith<$Res> {
  factory _$$OnResetLaddersImplCopyWith(
    _$OnResetLaddersImpl value,
    $Res Function(_$OnResetLaddersImpl) then,
  ) = __$$OnResetLaddersImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$OnResetLaddersImplCopyWithImpl<$Res>
    extends _$LaddersEventCopyWithImpl<$Res, _$OnResetLaddersImpl>
    implements _$$OnResetLaddersImplCopyWith<$Res> {
  __$$OnResetLaddersImplCopyWithImpl(
    _$OnResetLaddersImpl _value,
    $Res Function(_$OnResetLaddersImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of LaddersEvent
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$OnResetLaddersImpl implements OnResetLadders {
  const _$OnResetLaddersImpl();

  @override
  String toString() {
    return 'LaddersEvent.onResetLadders()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$OnResetLaddersImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() onLoadLadders,
    required TResult Function() onResetLadders,
  }) {
    return onResetLadders();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? onLoadLadders,
    TResult? Function()? onResetLadders,
  }) {
    return onResetLadders?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? onLoadLadders,
    TResult Function()? onResetLadders,
    required TResult orElse(),
  }) {
    if (onResetLadders != null) {
      return onResetLadders();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(OnLoadLadders value) onLoadLadders,
    required TResult Function(OnResetLadders value) onResetLadders,
  }) {
    return onResetLadders(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(OnLoadLadders value)? onLoadLadders,
    TResult? Function(OnResetLadders value)? onResetLadders,
  }) {
    return onResetLadders?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(OnLoadLadders value)? onLoadLadders,
    TResult Function(OnResetLadders value)? onResetLadders,
    required TResult orElse(),
  }) {
    if (onResetLadders != null) {
      return onResetLadders(this);
    }
    return orElse();
  }
}

abstract class OnResetLadders implements LaddersEvent {
  const factory OnResetLadders() = _$OnResetLaddersImpl;
}

/// @nodoc
mixin _$LaddersState {
  LaddersListDTO get ladders => throw _privateConstructorUsedError;
  BaseLoading get status => throw _privateConstructorUsedError;

  /// Create a copy of LaddersState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $LaddersStateCopyWith<LaddersState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LaddersStateCopyWith<$Res> {
  factory $LaddersStateCopyWith(
    LaddersState value,
    $Res Function(LaddersState) then,
  ) = _$LaddersStateCopyWithImpl<$Res, LaddersState>;
  @useResult
  $Res call({LaddersListDTO ladders, BaseLoading status});

  $LaddersListDTOCopyWith<$Res> get ladders;
  $BaseLoadingCopyWith<$Res> get status;
}

/// @nodoc
class _$LaddersStateCopyWithImpl<$Res, $Val extends LaddersState>
    implements $LaddersStateCopyWith<$Res> {
  _$LaddersStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of LaddersState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? ladders = null, Object? status = null}) {
    return _then(
      _value.copyWith(
            ladders: null == ladders
                ? _value.ladders
                : ladders // ignore: cast_nullable_to_non_nullable
                      as LaddersListDTO,
            status: null == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as BaseLoading,
          )
          as $Val,
    );
  }

  /// Create a copy of LaddersState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $LaddersListDTOCopyWith<$Res> get ladders {
    return $LaddersListDTOCopyWith<$Res>(_value.ladders, (value) {
      return _then(_value.copyWith(ladders: value) as $Val);
    });
  }

  /// Create a copy of LaddersState
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
abstract class _$$LaddersStateImplCopyWith<$Res>
    implements $LaddersStateCopyWith<$Res> {
  factory _$$LaddersStateImplCopyWith(
    _$LaddersStateImpl value,
    $Res Function(_$LaddersStateImpl) then,
  ) = __$$LaddersStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({LaddersListDTO ladders, BaseLoading status});

  @override
  $LaddersListDTOCopyWith<$Res> get ladders;
  @override
  $BaseLoadingCopyWith<$Res> get status;
}

/// @nodoc
class __$$LaddersStateImplCopyWithImpl<$Res>
    extends _$LaddersStateCopyWithImpl<$Res, _$LaddersStateImpl>
    implements _$$LaddersStateImplCopyWith<$Res> {
  __$$LaddersStateImplCopyWithImpl(
    _$LaddersStateImpl _value,
    $Res Function(_$LaddersStateImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of LaddersState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? ladders = null, Object? status = null}) {
    return _then(
      _$LaddersStateImpl(
        ladders: null == ladders
            ? _value.ladders
            : ladders // ignore: cast_nullable_to_non_nullable
                  as LaddersListDTO,
        status: null == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as BaseLoading,
      ),
    );
  }
}

/// @nodoc

class _$LaddersStateImpl implements _LaddersState {
  const _$LaddersStateImpl({required this.ladders, required this.status});

  @override
  final LaddersListDTO ladders;
  @override
  final BaseLoading status;

  @override
  String toString() {
    return 'LaddersState(ladders: $ladders, status: $status)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LaddersStateImpl &&
            (identical(other.ladders, ladders) || other.ladders == ladders) &&
            (identical(other.status, status) || other.status == status));
  }

  @override
  int get hashCode => Object.hash(runtimeType, ladders, status);

  /// Create a copy of LaddersState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$LaddersStateImplCopyWith<_$LaddersStateImpl> get copyWith =>
      __$$LaddersStateImplCopyWithImpl<_$LaddersStateImpl>(this, _$identity);
}

abstract class _LaddersState implements LaddersState {
  const factory _LaddersState({
    required final LaddersListDTO ladders,
    required final BaseLoading status,
  }) = _$LaddersStateImpl;

  @override
  LaddersListDTO get ladders;
  @override
  BaseLoading get status;

  /// Create a copy of LaddersState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$LaddersStateImplCopyWith<_$LaddersStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
