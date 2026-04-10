// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'locations_item_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$LocationsItemDTO {
  String? get name => throw _privateConstructorUsedError;
  String? get prefix => throw _privateConstructorUsedError;
  String? get longitude => throw _privateConstructorUsedError;
  String? get latitude => throw _privateConstructorUsedError;
  String? get imageUrl => throw _privateConstructorUsedError;
  String? get vobGuid => throw _privateConstructorUsedError;

  /// Create a copy of LocationsItemDTO
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $LocationsItemDTOCopyWith<LocationsItemDTO> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LocationsItemDTOCopyWith<$Res> {
  factory $LocationsItemDTOCopyWith(
    LocationsItemDTO value,
    $Res Function(LocationsItemDTO) then,
  ) = _$LocationsItemDTOCopyWithImpl<$Res, LocationsItemDTO>;
  @useResult
  $Res call({
    String? name,
    String? prefix,
    String? longitude,
    String? latitude,
    String? imageUrl,
    String? vobGuid,
  });
}

/// @nodoc
class _$LocationsItemDTOCopyWithImpl<$Res, $Val extends LocationsItemDTO>
    implements $LocationsItemDTOCopyWith<$Res> {
  _$LocationsItemDTOCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of LocationsItemDTO
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = freezed,
    Object? prefix = freezed,
    Object? longitude = freezed,
    Object? latitude = freezed,
    Object? imageUrl = freezed,
    Object? vobGuid = freezed,
  }) {
    return _then(
      _value.copyWith(
            name: freezed == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                      as String?,
            prefix: freezed == prefix
                ? _value.prefix
                : prefix // ignore: cast_nullable_to_non_nullable
                      as String?,
            longitude: freezed == longitude
                ? _value.longitude
                : longitude // ignore: cast_nullable_to_non_nullable
                      as String?,
            latitude: freezed == latitude
                ? _value.latitude
                : latitude // ignore: cast_nullable_to_non_nullable
                      as String?,
            imageUrl: freezed == imageUrl
                ? _value.imageUrl
                : imageUrl // ignore: cast_nullable_to_non_nullable
                      as String?,
            vobGuid: freezed == vobGuid
                ? _value.vobGuid
                : vobGuid // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$LocationsItemDTOImplCopyWith<$Res>
    implements $LocationsItemDTOCopyWith<$Res> {
  factory _$$LocationsItemDTOImplCopyWith(
    _$LocationsItemDTOImpl value,
    $Res Function(_$LocationsItemDTOImpl) then,
  ) = __$$LocationsItemDTOImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String? name,
    String? prefix,
    String? longitude,
    String? latitude,
    String? imageUrl,
    String? vobGuid,
  });
}

/// @nodoc
class __$$LocationsItemDTOImplCopyWithImpl<$Res>
    extends _$LocationsItemDTOCopyWithImpl<$Res, _$LocationsItemDTOImpl>
    implements _$$LocationsItemDTOImplCopyWith<$Res> {
  __$$LocationsItemDTOImplCopyWithImpl(
    _$LocationsItemDTOImpl _value,
    $Res Function(_$LocationsItemDTOImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of LocationsItemDTO
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = freezed,
    Object? prefix = freezed,
    Object? longitude = freezed,
    Object? latitude = freezed,
    Object? imageUrl = freezed,
    Object? vobGuid = freezed,
  }) {
    return _then(
      _$LocationsItemDTOImpl(
        name: freezed == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String?,
        prefix: freezed == prefix
            ? _value.prefix
            : prefix // ignore: cast_nullable_to_non_nullable
                  as String?,
        longitude: freezed == longitude
            ? _value.longitude
            : longitude // ignore: cast_nullable_to_non_nullable
                  as String?,
        latitude: freezed == latitude
            ? _value.latitude
            : latitude // ignore: cast_nullable_to_non_nullable
                  as String?,
        imageUrl: freezed == imageUrl
            ? _value.imageUrl
            : imageUrl // ignore: cast_nullable_to_non_nullable
                  as String?,
        vobGuid: freezed == vobGuid
            ? _value.vobGuid
            : vobGuid // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc

class _$LocationsItemDTOImpl extends _LocationsItemDTO {
  const _$LocationsItemDTOImpl({
    required this.name,
    required this.prefix,
    required this.longitude,
    required this.latitude,
    required this.imageUrl,
    required this.vobGuid,
  }) : super._();

  @override
  final String? name;
  @override
  final String? prefix;
  @override
  final String? longitude;
  @override
  final String? latitude;
  @override
  final String? imageUrl;
  @override
  final String? vobGuid;

  @override
  String toString() {
    return 'LocationsItemDTO(name: $name, prefix: $prefix, longitude: $longitude, latitude: $latitude, imageUrl: $imageUrl, vobGuid: $vobGuid)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LocationsItemDTOImpl &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.prefix, prefix) || other.prefix == prefix) &&
            (identical(other.longitude, longitude) ||
                other.longitude == longitude) &&
            (identical(other.latitude, latitude) ||
                other.latitude == latitude) &&
            (identical(other.imageUrl, imageUrl) ||
                other.imageUrl == imageUrl) &&
            (identical(other.vobGuid, vobGuid) || other.vobGuid == vobGuid));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    name,
    prefix,
    longitude,
    latitude,
    imageUrl,
    vobGuid,
  );

  /// Create a copy of LocationsItemDTO
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$LocationsItemDTOImplCopyWith<_$LocationsItemDTOImpl> get copyWith =>
      __$$LocationsItemDTOImplCopyWithImpl<_$LocationsItemDTOImpl>(
        this,
        _$identity,
      );
}

abstract class _LocationsItemDTO extends LocationsItemDTO {
  const factory _LocationsItemDTO({
    required final String? name,
    required final String? prefix,
    required final String? longitude,
    required final String? latitude,
    required final String? imageUrl,
    required final String? vobGuid,
  }) = _$LocationsItemDTOImpl;
  const _LocationsItemDTO._() : super._();

  @override
  String? get name;
  @override
  String? get prefix;
  @override
  String? get longitude;
  @override
  String? get latitude;
  @override
  String? get imageUrl;
  @override
  String? get vobGuid;

  /// Create a copy of LocationsItemDTO
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$LocationsItemDTOImplCopyWith<_$LocationsItemDTOImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
