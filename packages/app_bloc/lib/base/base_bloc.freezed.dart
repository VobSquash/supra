// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'base_bloc.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$BaseLoading {
  String? get message => throw _privateConstructorUsedError;
  BaseLoadingStatus get status => throw _privateConstructorUsedError;

  /// Create a copy of BaseLoading
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $BaseLoadingCopyWith<BaseLoading> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BaseLoadingCopyWith<$Res> {
  factory $BaseLoadingCopyWith(
    BaseLoading value,
    $Res Function(BaseLoading) then,
  ) = _$BaseLoadingCopyWithImpl<$Res, BaseLoading>;
  @useResult
  $Res call({String? message, BaseLoadingStatus status});
}

/// @nodoc
class _$BaseLoadingCopyWithImpl<$Res, $Val extends BaseLoading>
    implements $BaseLoadingCopyWith<$Res> {
  _$BaseLoadingCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of BaseLoading
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? message = freezed, Object? status = null}) {
    return _then(
      _value.copyWith(
            message: freezed == message
                ? _value.message
                : message // ignore: cast_nullable_to_non_nullable
                      as String?,
            status: null == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as BaseLoadingStatus,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$BaseLoadingImplCopyWith<$Res>
    implements $BaseLoadingCopyWith<$Res> {
  factory _$$BaseLoadingImplCopyWith(
    _$BaseLoadingImpl value,
    $Res Function(_$BaseLoadingImpl) then,
  ) = __$$BaseLoadingImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String? message, BaseLoadingStatus status});
}

/// @nodoc
class __$$BaseLoadingImplCopyWithImpl<$Res>
    extends _$BaseLoadingCopyWithImpl<$Res, _$BaseLoadingImpl>
    implements _$$BaseLoadingImplCopyWith<$Res> {
  __$$BaseLoadingImplCopyWithImpl(
    _$BaseLoadingImpl _value,
    $Res Function(_$BaseLoadingImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of BaseLoading
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? message = freezed, Object? status = null}) {
    return _then(
      _$BaseLoadingImpl(
        message: freezed == message
            ? _value.message
            : message // ignore: cast_nullable_to_non_nullable
                  as String?,
        status: null == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as BaseLoadingStatus,
      ),
    );
  }
}

/// @nodoc

class _$BaseLoadingImpl implements _BaseLoading {
  const _$BaseLoadingImpl({required this.message, required this.status});

  @override
  final String? message;
  @override
  final BaseLoadingStatus status;

  @override
  String toString() {
    return 'BaseLoading(message: $message, status: $status)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BaseLoadingImpl &&
            (identical(other.message, message) || other.message == message) &&
            (identical(other.status, status) || other.status == status));
  }

  @override
  int get hashCode => Object.hash(runtimeType, message, status);

  /// Create a copy of BaseLoading
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$BaseLoadingImplCopyWith<_$BaseLoadingImpl> get copyWith =>
      __$$BaseLoadingImplCopyWithImpl<_$BaseLoadingImpl>(this, _$identity);
}

abstract class _BaseLoading implements BaseLoading {
  const factory _BaseLoading({
    required final String? message,
    required final BaseLoadingStatus status,
  }) = _$BaseLoadingImpl;

  @override
  String? get message;
  @override
  BaseLoadingStatus get status;

  /// Create a copy of BaseLoading
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$BaseLoadingImplCopyWith<_$BaseLoadingImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
