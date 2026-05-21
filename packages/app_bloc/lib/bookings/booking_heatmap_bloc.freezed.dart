// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'booking_heatmap_bloc.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$BookingHeatmapEvent {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(DateTime anyDateInMonth) loadMemberMonth,
    required TResult Function(DateTime forDay) loadAdminDay,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(DateTime anyDateInMonth)? loadMemberMonth,
    TResult? Function(DateTime forDay)? loadAdminDay,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(DateTime anyDateInMonth)? loadMemberMonth,
    TResult Function(DateTime forDay)? loadAdminDay,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_LoadMemberMonth value) loadMemberMonth,
    required TResult Function(_LoadAdminDay value) loadAdminDay,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_LoadMemberMonth value)? loadMemberMonth,
    TResult? Function(_LoadAdminDay value)? loadAdminDay,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_LoadMemberMonth value)? loadMemberMonth,
    TResult Function(_LoadAdminDay value)? loadAdminDay,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BookingHeatmapEventCopyWith<$Res> {
  factory $BookingHeatmapEventCopyWith(
    BookingHeatmapEvent value,
    $Res Function(BookingHeatmapEvent) then,
  ) = _$BookingHeatmapEventCopyWithImpl<$Res, BookingHeatmapEvent>;
}

/// @nodoc
class _$BookingHeatmapEventCopyWithImpl<$Res, $Val extends BookingHeatmapEvent>
    implements $BookingHeatmapEventCopyWith<$Res> {
  _$BookingHeatmapEventCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of BookingHeatmapEvent
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc
abstract class _$$LoadMemberMonthImplCopyWith<$Res> {
  factory _$$LoadMemberMonthImplCopyWith(
    _$LoadMemberMonthImpl value,
    $Res Function(_$LoadMemberMonthImpl) then,
  ) = __$$LoadMemberMonthImplCopyWithImpl<$Res>;
  @useResult
  $Res call({DateTime anyDateInMonth});
}

/// @nodoc
class __$$LoadMemberMonthImplCopyWithImpl<$Res>
    extends _$BookingHeatmapEventCopyWithImpl<$Res, _$LoadMemberMonthImpl>
    implements _$$LoadMemberMonthImplCopyWith<$Res> {
  __$$LoadMemberMonthImplCopyWithImpl(
    _$LoadMemberMonthImpl _value,
    $Res Function(_$LoadMemberMonthImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of BookingHeatmapEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? anyDateInMonth = null}) {
    return _then(
      _$LoadMemberMonthImpl(
        anyDateInMonth: null == anyDateInMonth
            ? _value.anyDateInMonth
            : anyDateInMonth // ignore: cast_nullable_to_non_nullable
                  as DateTime,
      ),
    );
  }
}

/// @nodoc

class _$LoadMemberMonthImpl implements _LoadMemberMonth {
  const _$LoadMemberMonthImpl({required this.anyDateInMonth});

  @override
  final DateTime anyDateInMonth;

  @override
  String toString() {
    return 'BookingHeatmapEvent.loadMemberMonth(anyDateInMonth: $anyDateInMonth)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LoadMemberMonthImpl &&
            (identical(other.anyDateInMonth, anyDateInMonth) ||
                other.anyDateInMonth == anyDateInMonth));
  }

  @override
  int get hashCode => Object.hash(runtimeType, anyDateInMonth);

  /// Create a copy of BookingHeatmapEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$LoadMemberMonthImplCopyWith<_$LoadMemberMonthImpl> get copyWith =>
      __$$LoadMemberMonthImplCopyWithImpl<_$LoadMemberMonthImpl>(
        this,
        _$identity,
      );

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(DateTime anyDateInMonth) loadMemberMonth,
    required TResult Function(DateTime forDay) loadAdminDay,
  }) {
    return loadMemberMonth(anyDateInMonth);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(DateTime anyDateInMonth)? loadMemberMonth,
    TResult? Function(DateTime forDay)? loadAdminDay,
  }) {
    return loadMemberMonth?.call(anyDateInMonth);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(DateTime anyDateInMonth)? loadMemberMonth,
    TResult Function(DateTime forDay)? loadAdminDay,
    required TResult orElse(),
  }) {
    if (loadMemberMonth != null) {
      return loadMemberMonth(anyDateInMonth);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_LoadMemberMonth value) loadMemberMonth,
    required TResult Function(_LoadAdminDay value) loadAdminDay,
  }) {
    return loadMemberMonth(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_LoadMemberMonth value)? loadMemberMonth,
    TResult? Function(_LoadAdminDay value)? loadAdminDay,
  }) {
    return loadMemberMonth?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_LoadMemberMonth value)? loadMemberMonth,
    TResult Function(_LoadAdminDay value)? loadAdminDay,
    required TResult orElse(),
  }) {
    if (loadMemberMonth != null) {
      return loadMemberMonth(this);
    }
    return orElse();
  }
}

abstract class _LoadMemberMonth implements BookingHeatmapEvent {
  const factory _LoadMemberMonth({required final DateTime anyDateInMonth}) =
      _$LoadMemberMonthImpl;

  DateTime get anyDateInMonth;

  /// Create a copy of BookingHeatmapEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$LoadMemberMonthImplCopyWith<_$LoadMemberMonthImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$LoadAdminDayImplCopyWith<$Res> {
  factory _$$LoadAdminDayImplCopyWith(
    _$LoadAdminDayImpl value,
    $Res Function(_$LoadAdminDayImpl) then,
  ) = __$$LoadAdminDayImplCopyWithImpl<$Res>;
  @useResult
  $Res call({DateTime forDay});
}

/// @nodoc
class __$$LoadAdminDayImplCopyWithImpl<$Res>
    extends _$BookingHeatmapEventCopyWithImpl<$Res, _$LoadAdminDayImpl>
    implements _$$LoadAdminDayImplCopyWith<$Res> {
  __$$LoadAdminDayImplCopyWithImpl(
    _$LoadAdminDayImpl _value,
    $Res Function(_$LoadAdminDayImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of BookingHeatmapEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? forDay = null}) {
    return _then(
      _$LoadAdminDayImpl(
        forDay: null == forDay
            ? _value.forDay
            : forDay // ignore: cast_nullable_to_non_nullable
                  as DateTime,
      ),
    );
  }
}

/// @nodoc

class _$LoadAdminDayImpl implements _LoadAdminDay {
  const _$LoadAdminDayImpl({required this.forDay});

  @override
  final DateTime forDay;

  @override
  String toString() {
    return 'BookingHeatmapEvent.loadAdminDay(forDay: $forDay)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LoadAdminDayImpl &&
            (identical(other.forDay, forDay) || other.forDay == forDay));
  }

  @override
  int get hashCode => Object.hash(runtimeType, forDay);

  /// Create a copy of BookingHeatmapEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$LoadAdminDayImplCopyWith<_$LoadAdminDayImpl> get copyWith =>
      __$$LoadAdminDayImplCopyWithImpl<_$LoadAdminDayImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(DateTime anyDateInMonth) loadMemberMonth,
    required TResult Function(DateTime forDay) loadAdminDay,
  }) {
    return loadAdminDay(forDay);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(DateTime anyDateInMonth)? loadMemberMonth,
    TResult? Function(DateTime forDay)? loadAdminDay,
  }) {
    return loadAdminDay?.call(forDay);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(DateTime anyDateInMonth)? loadMemberMonth,
    TResult Function(DateTime forDay)? loadAdminDay,
    required TResult orElse(),
  }) {
    if (loadAdminDay != null) {
      return loadAdminDay(forDay);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_LoadMemberMonth value) loadMemberMonth,
    required TResult Function(_LoadAdminDay value) loadAdminDay,
  }) {
    return loadAdminDay(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_LoadMemberMonth value)? loadMemberMonth,
    TResult? Function(_LoadAdminDay value)? loadAdminDay,
  }) {
    return loadAdminDay?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_LoadMemberMonth value)? loadMemberMonth,
    TResult Function(_LoadAdminDay value)? loadAdminDay,
    required TResult orElse(),
  }) {
    if (loadAdminDay != null) {
      return loadAdminDay(this);
    }
    return orElse();
  }
}

abstract class _LoadAdminDay implements BookingHeatmapEvent {
  const factory _LoadAdminDay({required final DateTime forDay}) =
      _$LoadAdminDayImpl;

  DateTime get forDay;

  /// Create a copy of BookingHeatmapEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$LoadAdminDayImplCopyWith<_$LoadAdminDayImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$BookingHeatmapState {
  BaseLoading get status => throw _privateConstructorUsedError;
  BookingHeatmapMode get mode => throw _privateConstructorUsedError;
  BookingHeatmapMemberMonth? get memberMonth =>
      throw _privateConstructorUsedError;
  BookingHeatmapMemberRolling4Week? get memberRolling4Week =>
      throw _privateConstructorUsedError;
  BookingHeatmapAdminDayGrid? get adminDayGrid =>
      throw _privateConstructorUsedError;

  /// Create a copy of BookingHeatmapState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $BookingHeatmapStateCopyWith<BookingHeatmapState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BookingHeatmapStateCopyWith<$Res> {
  factory $BookingHeatmapStateCopyWith(
    BookingHeatmapState value,
    $Res Function(BookingHeatmapState) then,
  ) = _$BookingHeatmapStateCopyWithImpl<$Res, BookingHeatmapState>;
  @useResult
  $Res call({
    BaseLoading status,
    BookingHeatmapMode mode,
    BookingHeatmapMemberMonth? memberMonth,
    BookingHeatmapMemberRolling4Week? memberRolling4Week,
    BookingHeatmapAdminDayGrid? adminDayGrid,
  });

  $BaseLoadingCopyWith<$Res> get status;
}

/// @nodoc
class _$BookingHeatmapStateCopyWithImpl<$Res, $Val extends BookingHeatmapState>
    implements $BookingHeatmapStateCopyWith<$Res> {
  _$BookingHeatmapStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of BookingHeatmapState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? status = null,
    Object? mode = null,
    Object? memberMonth = freezed,
    Object? memberRolling4Week = freezed,
    Object? adminDayGrid = freezed,
  }) {
    return _then(
      _value.copyWith(
            status: null == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as BaseLoading,
            mode: null == mode
                ? _value.mode
                : mode // ignore: cast_nullable_to_non_nullable
                      as BookingHeatmapMode,
            memberMonth: freezed == memberMonth
                ? _value.memberMonth
                : memberMonth // ignore: cast_nullable_to_non_nullable
                      as BookingHeatmapMemberMonth?,
            memberRolling4Week: freezed == memberRolling4Week
                ? _value.memberRolling4Week
                : memberRolling4Week // ignore: cast_nullable_to_non_nullable
                      as BookingHeatmapMemberRolling4Week?,
            adminDayGrid: freezed == adminDayGrid
                ? _value.adminDayGrid
                : adminDayGrid // ignore: cast_nullable_to_non_nullable
                      as BookingHeatmapAdminDayGrid?,
          )
          as $Val,
    );
  }

  /// Create a copy of BookingHeatmapState
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
abstract class _$$BookingHeatmapStateImplCopyWith<$Res>
    implements $BookingHeatmapStateCopyWith<$Res> {
  factory _$$BookingHeatmapStateImplCopyWith(
    _$BookingHeatmapStateImpl value,
    $Res Function(_$BookingHeatmapStateImpl) then,
  ) = __$$BookingHeatmapStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    BaseLoading status,
    BookingHeatmapMode mode,
    BookingHeatmapMemberMonth? memberMonth,
    BookingHeatmapMemberRolling4Week? memberRolling4Week,
    BookingHeatmapAdminDayGrid? adminDayGrid,
  });

  @override
  $BaseLoadingCopyWith<$Res> get status;
}

/// @nodoc
class __$$BookingHeatmapStateImplCopyWithImpl<$Res>
    extends _$BookingHeatmapStateCopyWithImpl<$Res, _$BookingHeatmapStateImpl>
    implements _$$BookingHeatmapStateImplCopyWith<$Res> {
  __$$BookingHeatmapStateImplCopyWithImpl(
    _$BookingHeatmapStateImpl _value,
    $Res Function(_$BookingHeatmapStateImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of BookingHeatmapState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? status = null,
    Object? mode = null,
    Object? memberMonth = freezed,
    Object? memberRolling4Week = freezed,
    Object? adminDayGrid = freezed,
  }) {
    return _then(
      _$BookingHeatmapStateImpl(
        status: null == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as BaseLoading,
        mode: null == mode
            ? _value.mode
            : mode // ignore: cast_nullable_to_non_nullable
                  as BookingHeatmapMode,
        memberMonth: freezed == memberMonth
            ? _value.memberMonth
            : memberMonth // ignore: cast_nullable_to_non_nullable
                  as BookingHeatmapMemberMonth?,
        memberRolling4Week: freezed == memberRolling4Week
            ? _value.memberRolling4Week
            : memberRolling4Week // ignore: cast_nullable_to_non_nullable
                  as BookingHeatmapMemberRolling4Week?,
        adminDayGrid: freezed == adminDayGrid
            ? _value.adminDayGrid
            : adminDayGrid // ignore: cast_nullable_to_non_nullable
                  as BookingHeatmapAdminDayGrid?,
      ),
    );
  }
}

/// @nodoc

class _$BookingHeatmapStateImpl implements _BookingHeatmapState {
  const _$BookingHeatmapStateImpl({
    required this.status,
    required this.mode,
    this.memberMonth,
    this.memberRolling4Week,
    this.adminDayGrid,
  });

  @override
  final BaseLoading status;
  @override
  final BookingHeatmapMode mode;
  @override
  final BookingHeatmapMemberMonth? memberMonth;
  @override
  final BookingHeatmapMemberRolling4Week? memberRolling4Week;
  @override
  final BookingHeatmapAdminDayGrid? adminDayGrid;

  @override
  String toString() {
    return 'BookingHeatmapState(status: $status, mode: $mode, memberMonth: $memberMonth, memberRolling4Week: $memberRolling4Week, adminDayGrid: $adminDayGrid)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BookingHeatmapStateImpl &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.mode, mode) || other.mode == mode) &&
            (identical(other.memberMonth, memberMonth) ||
                other.memberMonth == memberMonth) &&
            (identical(other.memberRolling4Week, memberRolling4Week) ||
                other.memberRolling4Week == memberRolling4Week) &&
            (identical(other.adminDayGrid, adminDayGrid) ||
                other.adminDayGrid == adminDayGrid));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    status,
    mode,
    memberMonth,
    memberRolling4Week,
    adminDayGrid,
  );

  /// Create a copy of BookingHeatmapState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$BookingHeatmapStateImplCopyWith<_$BookingHeatmapStateImpl> get copyWith =>
      __$$BookingHeatmapStateImplCopyWithImpl<_$BookingHeatmapStateImpl>(
        this,
        _$identity,
      );
}

abstract class _BookingHeatmapState implements BookingHeatmapState {
  const factory _BookingHeatmapState({
    required final BaseLoading status,
    required final BookingHeatmapMode mode,
    final BookingHeatmapMemberMonth? memberMonth,
    final BookingHeatmapMemberRolling4Week? memberRolling4Week,
    final BookingHeatmapAdminDayGrid? adminDayGrid,
  }) = _$BookingHeatmapStateImpl;

  @override
  BaseLoading get status;
  @override
  BookingHeatmapMode get mode;
  @override
  BookingHeatmapMemberMonth? get memberMonth;
  @override
  BookingHeatmapMemberRolling4Week? get memberRolling4Week;
  @override
  BookingHeatmapAdminDayGrid? get adminDayGrid;

  /// Create a copy of BookingHeatmapState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$BookingHeatmapStateImplCopyWith<_$BookingHeatmapStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
