// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'locations_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$LocationsDTO {
  List<LocationsItemDTO>? get locations => throw _privateConstructorUsedError;

  /// Create a copy of LocationsDTO
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $LocationsDTOCopyWith<LocationsDTO> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LocationsDTOCopyWith<$Res> {
  factory $LocationsDTOCopyWith(
    LocationsDTO value,
    $Res Function(LocationsDTO) then,
  ) = _$LocationsDTOCopyWithImpl<$Res, LocationsDTO>;
  @useResult
  $Res call({List<LocationsItemDTO>? locations});
}

/// @nodoc
class _$LocationsDTOCopyWithImpl<$Res, $Val extends LocationsDTO>
    implements $LocationsDTOCopyWith<$Res> {
  _$LocationsDTOCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of LocationsDTO
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? locations = freezed}) {
    return _then(
      _value.copyWith(
            locations: freezed == locations
                ? _value.locations
                : locations // ignore: cast_nullable_to_non_nullable
                      as List<LocationsItemDTO>?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$LocationsDTOImplCopyWith<$Res>
    implements $LocationsDTOCopyWith<$Res> {
  factory _$$LocationsDTOImplCopyWith(
    _$LocationsDTOImpl value,
    $Res Function(_$LocationsDTOImpl) then,
  ) = __$$LocationsDTOImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({List<LocationsItemDTO>? locations});
}

/// @nodoc
class __$$LocationsDTOImplCopyWithImpl<$Res>
    extends _$LocationsDTOCopyWithImpl<$Res, _$LocationsDTOImpl>
    implements _$$LocationsDTOImplCopyWith<$Res> {
  __$$LocationsDTOImplCopyWithImpl(
    _$LocationsDTOImpl _value,
    $Res Function(_$LocationsDTOImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of LocationsDTO
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? locations = freezed}) {
    return _then(
      _$LocationsDTOImpl(
        locations: freezed == locations
            ? _value._locations
            : locations // ignore: cast_nullable_to_non_nullable
                  as List<LocationsItemDTO>?,
      ),
    );
  }
}

/// @nodoc

class _$LocationsDTOImpl extends _LocationsDTO {
  const _$LocationsDTOImpl({required final List<LocationsItemDTO>? locations})
    : _locations = locations,
      super._();

  final List<LocationsItemDTO>? _locations;
  @override
  List<LocationsItemDTO>? get locations {
    final value = _locations;
    if (value == null) return null;
    if (_locations is EqualUnmodifiableListView) return _locations;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  String toString() {
    return 'LocationsDTO(locations: $locations)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LocationsDTOImpl &&
            const DeepCollectionEquality().equals(
              other._locations,
              _locations,
            ));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(_locations));

  /// Create a copy of LocationsDTO
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$LocationsDTOImplCopyWith<_$LocationsDTOImpl> get copyWith =>
      __$$LocationsDTOImplCopyWithImpl<_$LocationsDTOImpl>(this, _$identity);
}

abstract class _LocationsDTO extends LocationsDTO {
  const factory _LocationsDTO({
    required final List<LocationsItemDTO>? locations,
  }) = _$LocationsDTOImpl;
  const _LocationsDTO._() : super._();

  @override
  List<LocationsItemDTO>? get locations;

  /// Create a copy of LocationsDTO
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$LocationsDTOImplCopyWith<_$LocationsDTOImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
