// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'bookings_bloc.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$BookingsEvent {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(DateTime forDate) onLoadBookings,
    required TResult Function() onResetBookings,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(DateTime forDate)? onLoadBookings,
    TResult? Function()? onResetBookings,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(DateTime forDate)? onLoadBookings,
    TResult Function()? onResetBookings,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(OnLoadBookings value) onLoadBookings,
    required TResult Function(OnResetBookings value) onResetBookings,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(OnLoadBookings value)? onLoadBookings,
    TResult? Function(OnResetBookings value)? onResetBookings,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(OnLoadBookings value)? onLoadBookings,
    TResult Function(OnResetBookings value)? onResetBookings,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BookingsEventCopyWith<$Res> {
  factory $BookingsEventCopyWith(
    BookingsEvent value,
    $Res Function(BookingsEvent) then,
  ) = _$BookingsEventCopyWithImpl<$Res, BookingsEvent>;
}

/// @nodoc
class _$BookingsEventCopyWithImpl<$Res, $Val extends BookingsEvent>
    implements $BookingsEventCopyWith<$Res> {
  _$BookingsEventCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of BookingsEvent
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc
abstract class _$$OnLoadBookingsImplCopyWith<$Res> {
  factory _$$OnLoadBookingsImplCopyWith(
    _$OnLoadBookingsImpl value,
    $Res Function(_$OnLoadBookingsImpl) then,
  ) = __$$OnLoadBookingsImplCopyWithImpl<$Res>;
  @useResult
  $Res call({DateTime forDate});
}

/// @nodoc
class __$$OnLoadBookingsImplCopyWithImpl<$Res>
    extends _$BookingsEventCopyWithImpl<$Res, _$OnLoadBookingsImpl>
    implements _$$OnLoadBookingsImplCopyWith<$Res> {
  __$$OnLoadBookingsImplCopyWithImpl(
    _$OnLoadBookingsImpl _value,
    $Res Function(_$OnLoadBookingsImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of BookingsEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? forDate = null}) {
    return _then(
      _$OnLoadBookingsImpl(
        forDate: null == forDate
            ? _value.forDate
            : forDate // ignore: cast_nullable_to_non_nullable
                  as DateTime,
      ),
    );
  }
}

/// @nodoc

class _$OnLoadBookingsImpl implements OnLoadBookings {
  const _$OnLoadBookingsImpl({required this.forDate});

  @override
  final DateTime forDate;

  @override
  String toString() {
    return 'BookingsEvent.onLoadBookings(forDate: $forDate)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$OnLoadBookingsImpl &&
            (identical(other.forDate, forDate) || other.forDate == forDate));
  }

  @override
  int get hashCode => Object.hash(runtimeType, forDate);

  /// Create a copy of BookingsEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$OnLoadBookingsImplCopyWith<_$OnLoadBookingsImpl> get copyWith =>
      __$$OnLoadBookingsImplCopyWithImpl<_$OnLoadBookingsImpl>(
        this,
        _$identity,
      );

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(DateTime forDate) onLoadBookings,
    required TResult Function() onResetBookings,
  }) {
    return onLoadBookings(forDate);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(DateTime forDate)? onLoadBookings,
    TResult? Function()? onResetBookings,
  }) {
    return onLoadBookings?.call(forDate);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(DateTime forDate)? onLoadBookings,
    TResult Function()? onResetBookings,
    required TResult orElse(),
  }) {
    if (onLoadBookings != null) {
      return onLoadBookings(forDate);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(OnLoadBookings value) onLoadBookings,
    required TResult Function(OnResetBookings value) onResetBookings,
  }) {
    return onLoadBookings(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(OnLoadBookings value)? onLoadBookings,
    TResult? Function(OnResetBookings value)? onResetBookings,
  }) {
    return onLoadBookings?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(OnLoadBookings value)? onLoadBookings,
    TResult Function(OnResetBookings value)? onResetBookings,
    required TResult orElse(),
  }) {
    if (onLoadBookings != null) {
      return onLoadBookings(this);
    }
    return orElse();
  }
}

abstract class OnLoadBookings implements BookingsEvent {
  const factory OnLoadBookings({required final DateTime forDate}) =
      _$OnLoadBookingsImpl;

  DateTime get forDate;

  /// Create a copy of BookingsEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$OnLoadBookingsImplCopyWith<_$OnLoadBookingsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$OnResetBookingsImplCopyWith<$Res> {
  factory _$$OnResetBookingsImplCopyWith(
    _$OnResetBookingsImpl value,
    $Res Function(_$OnResetBookingsImpl) then,
  ) = __$$OnResetBookingsImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$OnResetBookingsImplCopyWithImpl<$Res>
    extends _$BookingsEventCopyWithImpl<$Res, _$OnResetBookingsImpl>
    implements _$$OnResetBookingsImplCopyWith<$Res> {
  __$$OnResetBookingsImplCopyWithImpl(
    _$OnResetBookingsImpl _value,
    $Res Function(_$OnResetBookingsImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of BookingsEvent
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$OnResetBookingsImpl implements OnResetBookings {
  const _$OnResetBookingsImpl();

  @override
  String toString() {
    return 'BookingsEvent.onResetBookings()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$OnResetBookingsImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(DateTime forDate) onLoadBookings,
    required TResult Function() onResetBookings,
  }) {
    return onResetBookings();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(DateTime forDate)? onLoadBookings,
    TResult? Function()? onResetBookings,
  }) {
    return onResetBookings?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(DateTime forDate)? onLoadBookings,
    TResult Function()? onResetBookings,
    required TResult orElse(),
  }) {
    if (onResetBookings != null) {
      return onResetBookings();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(OnLoadBookings value) onLoadBookings,
    required TResult Function(OnResetBookings value) onResetBookings,
  }) {
    return onResetBookings(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(OnLoadBookings value)? onLoadBookings,
    TResult? Function(OnResetBookings value)? onResetBookings,
  }) {
    return onResetBookings?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(OnLoadBookings value)? onLoadBookings,
    TResult Function(OnResetBookings value)? onResetBookings,
    required TResult orElse(),
  }) {
    if (onResetBookings != null) {
      return onResetBookings(this);
    }
    return orElse();
  }
}

abstract class OnResetBookings implements BookingsEvent {
  const factory OnResetBookings() = _$OnResetBookingsImpl;
}

/// @nodoc
mixin _$BookingsState {
  DateTime get selectedDate => throw _privateConstructorUsedError;
  List<BookingDto> get bookings => throw _privateConstructorUsedError;
  BaseLoading get status => throw _privateConstructorUsedError;

  /// Create a copy of BookingsState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $BookingsStateCopyWith<BookingsState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BookingsStateCopyWith<$Res> {
  factory $BookingsStateCopyWith(
    BookingsState value,
    $Res Function(BookingsState) then,
  ) = _$BookingsStateCopyWithImpl<$Res, BookingsState>;
  @useResult
  $Res call({
    DateTime selectedDate,
    List<BookingDto> bookings,
    BaseLoading status,
  });

  $BaseLoadingCopyWith<$Res> get status;
}

/// @nodoc
class _$BookingsStateCopyWithImpl<$Res, $Val extends BookingsState>
    implements $BookingsStateCopyWith<$Res> {
  _$BookingsStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of BookingsState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? selectedDate = null,
    Object? bookings = null,
    Object? status = null,
  }) {
    return _then(
      _value.copyWith(
            selectedDate: null == selectedDate
                ? _value.selectedDate
                : selectedDate // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            bookings: null == bookings
                ? _value.bookings
                : bookings // ignore: cast_nullable_to_non_nullable
                      as List<BookingDto>,
            status: null == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as BaseLoading,
          )
          as $Val,
    );
  }

  /// Create a copy of BookingsState
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
abstract class _$$BookingsStateImplCopyWith<$Res>
    implements $BookingsStateCopyWith<$Res> {
  factory _$$BookingsStateImplCopyWith(
    _$BookingsStateImpl value,
    $Res Function(_$BookingsStateImpl) then,
  ) = __$$BookingsStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    DateTime selectedDate,
    List<BookingDto> bookings,
    BaseLoading status,
  });

  @override
  $BaseLoadingCopyWith<$Res> get status;
}

/// @nodoc
class __$$BookingsStateImplCopyWithImpl<$Res>
    extends _$BookingsStateCopyWithImpl<$Res, _$BookingsStateImpl>
    implements _$$BookingsStateImplCopyWith<$Res> {
  __$$BookingsStateImplCopyWithImpl(
    _$BookingsStateImpl _value,
    $Res Function(_$BookingsStateImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of BookingsState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? selectedDate = null,
    Object? bookings = null,
    Object? status = null,
  }) {
    return _then(
      _$BookingsStateImpl(
        selectedDate: null == selectedDate
            ? _value.selectedDate
            : selectedDate // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        bookings: null == bookings
            ? _value._bookings
            : bookings // ignore: cast_nullable_to_non_nullable
                  as List<BookingDto>,
        status: null == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as BaseLoading,
      ),
    );
  }
}

/// @nodoc

class _$BookingsStateImpl implements _BookingsState {
  const _$BookingsStateImpl({
    required this.selectedDate,
    required final List<BookingDto> bookings,
    required this.status,
  }) : _bookings = bookings;

  @override
  final DateTime selectedDate;
  final List<BookingDto> _bookings;
  @override
  List<BookingDto> get bookings {
    if (_bookings is EqualUnmodifiableListView) return _bookings;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_bookings);
  }

  @override
  final BaseLoading status;

  @override
  String toString() {
    return 'BookingsState(selectedDate: $selectedDate, bookings: $bookings, status: $status)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BookingsStateImpl &&
            (identical(other.selectedDate, selectedDate) ||
                other.selectedDate == selectedDate) &&
            const DeepCollectionEquality().equals(other._bookings, _bookings) &&
            (identical(other.status, status) || other.status == status));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    selectedDate,
    const DeepCollectionEquality().hash(_bookings),
    status,
  );

  /// Create a copy of BookingsState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$BookingsStateImplCopyWith<_$BookingsStateImpl> get copyWith =>
      __$$BookingsStateImplCopyWithImpl<_$BookingsStateImpl>(this, _$identity);
}

abstract class _BookingsState implements BookingsState {
  const factory _BookingsState({
    required final DateTime selectedDate,
    required final List<BookingDto> bookings,
    required final BaseLoading status,
  }) = _$BookingsStateImpl;

  @override
  DateTime get selectedDate;
  @override
  List<BookingDto> get bookings;
  @override
  BaseLoading get status;

  /// Create a copy of BookingsState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$BookingsStateImplCopyWith<_$BookingsStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
