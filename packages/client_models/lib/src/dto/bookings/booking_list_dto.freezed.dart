// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'booking_list_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$BookingListDto {
  List<BookingDto>? get bookings => throw _privateConstructorUsedError;

  /// Create a copy of BookingListDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $BookingListDtoCopyWith<BookingListDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BookingListDtoCopyWith<$Res> {
  factory $BookingListDtoCopyWith(
    BookingListDto value,
    $Res Function(BookingListDto) then,
  ) = _$BookingListDtoCopyWithImpl<$Res, BookingListDto>;
  @useResult
  $Res call({List<BookingDto>? bookings});
}

/// @nodoc
class _$BookingListDtoCopyWithImpl<$Res, $Val extends BookingListDto>
    implements $BookingListDtoCopyWith<$Res> {
  _$BookingListDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of BookingListDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? bookings = freezed}) {
    return _then(
      _value.copyWith(
            bookings: freezed == bookings
                ? _value.bookings
                : bookings // ignore: cast_nullable_to_non_nullable
                      as List<BookingDto>?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$BookingListDtoImplCopyWith<$Res>
    implements $BookingListDtoCopyWith<$Res> {
  factory _$$BookingListDtoImplCopyWith(
    _$BookingListDtoImpl value,
    $Res Function(_$BookingListDtoImpl) then,
  ) = __$$BookingListDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({List<BookingDto>? bookings});
}

/// @nodoc
class __$$BookingListDtoImplCopyWithImpl<$Res>
    extends _$BookingListDtoCopyWithImpl<$Res, _$BookingListDtoImpl>
    implements _$$BookingListDtoImplCopyWith<$Res> {
  __$$BookingListDtoImplCopyWithImpl(
    _$BookingListDtoImpl _value,
    $Res Function(_$BookingListDtoImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of BookingListDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? bookings = freezed}) {
    return _then(
      _$BookingListDtoImpl(
        bookings: freezed == bookings
            ? _value._bookings
            : bookings // ignore: cast_nullable_to_non_nullable
                  as List<BookingDto>?,
      ),
    );
  }
}

/// @nodoc

class _$BookingListDtoImpl extends _BookingListDto {
  const _$BookingListDtoImpl({required final List<BookingDto>? bookings})
    : _bookings = bookings,
      super._();

  final List<BookingDto>? _bookings;
  @override
  List<BookingDto>? get bookings {
    final value = _bookings;
    if (value == null) return null;
    if (_bookings is EqualUnmodifiableListView) return _bookings;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  String toString() {
    return 'BookingListDto(bookings: $bookings)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BookingListDtoImpl &&
            const DeepCollectionEquality().equals(other._bookings, _bookings));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(_bookings));

  /// Create a copy of BookingListDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$BookingListDtoImplCopyWith<_$BookingListDtoImpl> get copyWith =>
      __$$BookingListDtoImplCopyWithImpl<_$BookingListDtoImpl>(
        this,
        _$identity,
      );
}

abstract class _BookingListDto extends BookingListDto {
  const factory _BookingListDto({required final List<BookingDto>? bookings}) =
      _$BookingListDtoImpl;
  const _BookingListDto._() : super._();

  @override
  List<BookingDto>? get bookings;

  /// Create a copy of BookingListDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$BookingListDtoImplCopyWith<_$BookingListDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
