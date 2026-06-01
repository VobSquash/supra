// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'banner_events_bloc.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$BannerEventsEvent {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() onLoadEventBanners,
    required TResult Function() onResetEventBanners,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? onLoadEventBanners,
    TResult? Function()? onResetEventBanners,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? onLoadEventBanners,
    TResult Function()? onResetEventBanners,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(OnLoadEventBanners value) onLoadEventBanners,
    required TResult Function(OnResetEventBanners value) onResetEventBanners,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(OnLoadEventBanners value)? onLoadEventBanners,
    TResult? Function(OnResetEventBanners value)? onResetEventBanners,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(OnLoadEventBanners value)? onLoadEventBanners,
    TResult Function(OnResetEventBanners value)? onResetEventBanners,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BannerEventsEventCopyWith<$Res> {
  factory $BannerEventsEventCopyWith(
    BannerEventsEvent value,
    $Res Function(BannerEventsEvent) then,
  ) = _$BannerEventsEventCopyWithImpl<$Res, BannerEventsEvent>;
}

/// @nodoc
class _$BannerEventsEventCopyWithImpl<$Res, $Val extends BannerEventsEvent>
    implements $BannerEventsEventCopyWith<$Res> {
  _$BannerEventsEventCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of BannerEventsEvent
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc
abstract class _$$OnLoadEventBannersImplCopyWith<$Res> {
  factory _$$OnLoadEventBannersImplCopyWith(
    _$OnLoadEventBannersImpl value,
    $Res Function(_$OnLoadEventBannersImpl) then,
  ) = __$$OnLoadEventBannersImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$OnLoadEventBannersImplCopyWithImpl<$Res>
    extends _$BannerEventsEventCopyWithImpl<$Res, _$OnLoadEventBannersImpl>
    implements _$$OnLoadEventBannersImplCopyWith<$Res> {
  __$$OnLoadEventBannersImplCopyWithImpl(
    _$OnLoadEventBannersImpl _value,
    $Res Function(_$OnLoadEventBannersImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of BannerEventsEvent
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$OnLoadEventBannersImpl implements OnLoadEventBanners {
  const _$OnLoadEventBannersImpl();

  @override
  String toString() {
    return 'BannerEventsEvent.onLoadEventBanners()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$OnLoadEventBannersImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() onLoadEventBanners,
    required TResult Function() onResetEventBanners,
  }) {
    return onLoadEventBanners();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? onLoadEventBanners,
    TResult? Function()? onResetEventBanners,
  }) {
    return onLoadEventBanners?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? onLoadEventBanners,
    TResult Function()? onResetEventBanners,
    required TResult orElse(),
  }) {
    if (onLoadEventBanners != null) {
      return onLoadEventBanners();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(OnLoadEventBanners value) onLoadEventBanners,
    required TResult Function(OnResetEventBanners value) onResetEventBanners,
  }) {
    return onLoadEventBanners(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(OnLoadEventBanners value)? onLoadEventBanners,
    TResult? Function(OnResetEventBanners value)? onResetEventBanners,
  }) {
    return onLoadEventBanners?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(OnLoadEventBanners value)? onLoadEventBanners,
    TResult Function(OnResetEventBanners value)? onResetEventBanners,
    required TResult orElse(),
  }) {
    if (onLoadEventBanners != null) {
      return onLoadEventBanners(this);
    }
    return orElse();
  }
}

abstract class OnLoadEventBanners implements BannerEventsEvent {
  const factory OnLoadEventBanners() = _$OnLoadEventBannersImpl;
}

/// @nodoc
abstract class _$$OnResetEventBannersImplCopyWith<$Res> {
  factory _$$OnResetEventBannersImplCopyWith(
    _$OnResetEventBannersImpl value,
    $Res Function(_$OnResetEventBannersImpl) then,
  ) = __$$OnResetEventBannersImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$OnResetEventBannersImplCopyWithImpl<$Res>
    extends _$BannerEventsEventCopyWithImpl<$Res, _$OnResetEventBannersImpl>
    implements _$$OnResetEventBannersImplCopyWith<$Res> {
  __$$OnResetEventBannersImplCopyWithImpl(
    _$OnResetEventBannersImpl _value,
    $Res Function(_$OnResetEventBannersImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of BannerEventsEvent
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$OnResetEventBannersImpl implements OnResetEventBanners {
  const _$OnResetEventBannersImpl();

  @override
  String toString() {
    return 'BannerEventsEvent.onResetEventBanners()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$OnResetEventBannersImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() onLoadEventBanners,
    required TResult Function() onResetEventBanners,
  }) {
    return onResetEventBanners();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? onLoadEventBanners,
    TResult? Function()? onResetEventBanners,
  }) {
    return onResetEventBanners?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? onLoadEventBanners,
    TResult Function()? onResetEventBanners,
    required TResult orElse(),
  }) {
    if (onResetEventBanners != null) {
      return onResetEventBanners();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(OnLoadEventBanners value) onLoadEventBanners,
    required TResult Function(OnResetEventBanners value) onResetEventBanners,
  }) {
    return onResetEventBanners(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(OnLoadEventBanners value)? onLoadEventBanners,
    TResult? Function(OnResetEventBanners value)? onResetEventBanners,
  }) {
    return onResetEventBanners?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(OnLoadEventBanners value)? onLoadEventBanners,
    TResult Function(OnResetEventBanners value)? onResetEventBanners,
    required TResult orElse(),
  }) {
    if (onResetEventBanners != null) {
      return onResetEventBanners(this);
    }
    return orElse();
  }
}

abstract class OnResetEventBanners implements BannerEventsEvent {
  const factory OnResetEventBanners() = _$OnResetEventBannersImpl;
}

/// @nodoc
mixin _$BannerEventsState {
  List<EventBannerDTO> get banners => throw _privateConstructorUsedError;
  BaseLoading get status => throw _privateConstructorUsedError;

  /// Create a copy of BannerEventsState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $BannerEventsStateCopyWith<BannerEventsState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BannerEventsStateCopyWith<$Res> {
  factory $BannerEventsStateCopyWith(
    BannerEventsState value,
    $Res Function(BannerEventsState) then,
  ) = _$BannerEventsStateCopyWithImpl<$Res, BannerEventsState>;
  @useResult
  $Res call({List<EventBannerDTO> banners, BaseLoading status});

  $BaseLoadingCopyWith<$Res> get status;
}

/// @nodoc
class _$BannerEventsStateCopyWithImpl<$Res, $Val extends BannerEventsState>
    implements $BannerEventsStateCopyWith<$Res> {
  _$BannerEventsStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of BannerEventsState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? banners = null, Object? status = null}) {
    return _then(
      _value.copyWith(
            banners: null == banners
                ? _value.banners
                : banners // ignore: cast_nullable_to_non_nullable
                      as List<EventBannerDTO>,
            status: null == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as BaseLoading,
          )
          as $Val,
    );
  }

  /// Create a copy of BannerEventsState
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
abstract class _$$BannerEventsStateImplCopyWith<$Res>
    implements $BannerEventsStateCopyWith<$Res> {
  factory _$$BannerEventsStateImplCopyWith(
    _$BannerEventsStateImpl value,
    $Res Function(_$BannerEventsStateImpl) then,
  ) = __$$BannerEventsStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({List<EventBannerDTO> banners, BaseLoading status});

  @override
  $BaseLoadingCopyWith<$Res> get status;
}

/// @nodoc
class __$$BannerEventsStateImplCopyWithImpl<$Res>
    extends _$BannerEventsStateCopyWithImpl<$Res, _$BannerEventsStateImpl>
    implements _$$BannerEventsStateImplCopyWith<$Res> {
  __$$BannerEventsStateImplCopyWithImpl(
    _$BannerEventsStateImpl _value,
    $Res Function(_$BannerEventsStateImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of BannerEventsState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? banners = null, Object? status = null}) {
    return _then(
      _$BannerEventsStateImpl(
        banners: null == banners
            ? _value._banners
            : banners // ignore: cast_nullable_to_non_nullable
                  as List<EventBannerDTO>,
        status: null == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as BaseLoading,
      ),
    );
  }
}

/// @nodoc

class _$BannerEventsStateImpl implements _BannerEventsState {
  const _$BannerEventsStateImpl({
    required final List<EventBannerDTO> banners,
    required this.status,
  }) : _banners = banners;

  final List<EventBannerDTO> _banners;
  @override
  List<EventBannerDTO> get banners {
    if (_banners is EqualUnmodifiableListView) return _banners;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_banners);
  }

  @override
  final BaseLoading status;

  @override
  String toString() {
    return 'BannerEventsState(banners: $banners, status: $status)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BannerEventsStateImpl &&
            const DeepCollectionEquality().equals(other._banners, _banners) &&
            (identical(other.status, status) || other.status == status));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    const DeepCollectionEquality().hash(_banners),
    status,
  );

  /// Create a copy of BannerEventsState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$BannerEventsStateImplCopyWith<_$BannerEventsStateImpl> get copyWith =>
      __$$BannerEventsStateImplCopyWithImpl<_$BannerEventsStateImpl>(
        this,
        _$identity,
      );
}

abstract class _BannerEventsState implements BannerEventsState {
  const factory _BannerEventsState({
    required final List<EventBannerDTO> banners,
    required final BaseLoading status,
  }) = _$BannerEventsStateImpl;

  @override
  List<EventBannerDTO> get banners;
  @override
  BaseLoading get status;

  /// Create a copy of BannerEventsState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$BannerEventsStateImplCopyWith<_$BannerEventsStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
