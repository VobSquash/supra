// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'event_banner_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$EventBannerDTO {
  /// Storage object name (e.g. `1.png`) — stable cache key.
  String get objectName => throw _privateConstructorUsedError;

  /// Public HTTPS URL for [CachedNetworkImage].
  String get imageUrl => throw _privateConstructorUsedError;

  /// Parsed from the numeric filename stem (1, 2, 3, …).
  int get sortOrder => throw _privateConstructorUsedError;

  /// Create a copy of EventBannerDTO
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $EventBannerDTOCopyWith<EventBannerDTO> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $EventBannerDTOCopyWith<$Res> {
  factory $EventBannerDTOCopyWith(
    EventBannerDTO value,
    $Res Function(EventBannerDTO) then,
  ) = _$EventBannerDTOCopyWithImpl<$Res, EventBannerDTO>;
  @useResult
  $Res call({String objectName, String imageUrl, int sortOrder});
}

/// @nodoc
class _$EventBannerDTOCopyWithImpl<$Res, $Val extends EventBannerDTO>
    implements $EventBannerDTOCopyWith<$Res> {
  _$EventBannerDTOCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of EventBannerDTO
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? objectName = null,
    Object? imageUrl = null,
    Object? sortOrder = null,
  }) {
    return _then(
      _value.copyWith(
            objectName: null == objectName
                ? _value.objectName
                : objectName // ignore: cast_nullable_to_non_nullable
                      as String,
            imageUrl: null == imageUrl
                ? _value.imageUrl
                : imageUrl // ignore: cast_nullable_to_non_nullable
                      as String,
            sortOrder: null == sortOrder
                ? _value.sortOrder
                : sortOrder // ignore: cast_nullable_to_non_nullable
                      as int,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$EventBannerDTOImplCopyWith<$Res>
    implements $EventBannerDTOCopyWith<$Res> {
  factory _$$EventBannerDTOImplCopyWith(
    _$EventBannerDTOImpl value,
    $Res Function(_$EventBannerDTOImpl) then,
  ) = __$$EventBannerDTOImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String objectName, String imageUrl, int sortOrder});
}

/// @nodoc
class __$$EventBannerDTOImplCopyWithImpl<$Res>
    extends _$EventBannerDTOCopyWithImpl<$Res, _$EventBannerDTOImpl>
    implements _$$EventBannerDTOImplCopyWith<$Res> {
  __$$EventBannerDTOImplCopyWithImpl(
    _$EventBannerDTOImpl _value,
    $Res Function(_$EventBannerDTOImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of EventBannerDTO
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? objectName = null,
    Object? imageUrl = null,
    Object? sortOrder = null,
  }) {
    return _then(
      _$EventBannerDTOImpl(
        objectName: null == objectName
            ? _value.objectName
            : objectName // ignore: cast_nullable_to_non_nullable
                  as String,
        imageUrl: null == imageUrl
            ? _value.imageUrl
            : imageUrl // ignore: cast_nullable_to_non_nullable
                  as String,
        sortOrder: null == sortOrder
            ? _value.sortOrder
            : sortOrder // ignore: cast_nullable_to_non_nullable
                  as int,
      ),
    );
  }
}

/// @nodoc

class _$EventBannerDTOImpl implements _EventBannerDTO {
  const _$EventBannerDTOImpl({
    required this.objectName,
    required this.imageUrl,
    required this.sortOrder,
  });

  /// Storage object name (e.g. `1.png`) — stable cache key.
  @override
  final String objectName;

  /// Public HTTPS URL for [CachedNetworkImage].
  @override
  final String imageUrl;

  /// Parsed from the numeric filename stem (1, 2, 3, …).
  @override
  final int sortOrder;

  @override
  String toString() {
    return 'EventBannerDTO(objectName: $objectName, imageUrl: $imageUrl, sortOrder: $sortOrder)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$EventBannerDTOImpl &&
            (identical(other.objectName, objectName) ||
                other.objectName == objectName) &&
            (identical(other.imageUrl, imageUrl) ||
                other.imageUrl == imageUrl) &&
            (identical(other.sortOrder, sortOrder) ||
                other.sortOrder == sortOrder));
  }

  @override
  int get hashCode => Object.hash(runtimeType, objectName, imageUrl, sortOrder);

  /// Create a copy of EventBannerDTO
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$EventBannerDTOImplCopyWith<_$EventBannerDTOImpl> get copyWith =>
      __$$EventBannerDTOImplCopyWithImpl<_$EventBannerDTOImpl>(
        this,
        _$identity,
      );
}

abstract class _EventBannerDTO implements EventBannerDTO {
  const factory _EventBannerDTO({
    required final String objectName,
    required final String imageUrl,
    required final int sortOrder,
  }) = _$EventBannerDTOImpl;

  /// Storage object name (e.g. `1.png`) — stable cache key.
  @override
  String get objectName;

  /// Public HTTPS URL for [CachedNetworkImage].
  @override
  String get imageUrl;

  /// Parsed from the numeric filename stem (1, 2, 3, …).
  @override
  int get sortOrder;

  /// Create a copy of EventBannerDTO
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$EventBannerDTOImplCopyWith<_$EventBannerDTOImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
