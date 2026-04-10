// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'fees.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$FeesDTO {
  List<FeesItemDTO> get items => throw _privateConstructorUsedError;

  /// Create a copy of FeesDTO
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $FeesDTOCopyWith<FeesDTO> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FeesDTOCopyWith<$Res> {
  factory $FeesDTOCopyWith(FeesDTO value, $Res Function(FeesDTO) then) =
      _$FeesDTOCopyWithImpl<$Res, FeesDTO>;
  @useResult
  $Res call({List<FeesItemDTO> items});
}

/// @nodoc
class _$FeesDTOCopyWithImpl<$Res, $Val extends FeesDTO>
    implements $FeesDTOCopyWith<$Res> {
  _$FeesDTOCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of FeesDTO
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? items = null}) {
    return _then(
      _value.copyWith(
            items: null == items
                ? _value.items
                : items // ignore: cast_nullable_to_non_nullable
                      as List<FeesItemDTO>,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$FeesDTOImplCopyWith<$Res> implements $FeesDTOCopyWith<$Res> {
  factory _$$FeesDTOImplCopyWith(
    _$FeesDTOImpl value,
    $Res Function(_$FeesDTOImpl) then,
  ) = __$$FeesDTOImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({List<FeesItemDTO> items});
}

/// @nodoc
class __$$FeesDTOImplCopyWithImpl<$Res>
    extends _$FeesDTOCopyWithImpl<$Res, _$FeesDTOImpl>
    implements _$$FeesDTOImplCopyWith<$Res> {
  __$$FeesDTOImplCopyWithImpl(
    _$FeesDTOImpl _value,
    $Res Function(_$FeesDTOImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of FeesDTO
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? items = null}) {
    return _then(
      _$FeesDTOImpl(
        items: null == items
            ? _value._items
            : items // ignore: cast_nullable_to_non_nullable
                  as List<FeesItemDTO>,
      ),
    );
  }
}

/// @nodoc

class _$FeesDTOImpl extends _FeesDTO {
  const _$FeesDTOImpl({required final List<FeesItemDTO> items})
    : _items = items,
      super._();

  final List<FeesItemDTO> _items;
  @override
  List<FeesItemDTO> get items {
    if (_items is EqualUnmodifiableListView) return _items;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_items);
  }

  @override
  String toString() {
    return 'FeesDTO(items: $items)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FeesDTOImpl &&
            const DeepCollectionEquality().equals(other._items, _items));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(_items));

  /// Create a copy of FeesDTO
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$FeesDTOImplCopyWith<_$FeesDTOImpl> get copyWith =>
      __$$FeesDTOImplCopyWithImpl<_$FeesDTOImpl>(this, _$identity);
}

abstract class _FeesDTO extends FeesDTO {
  const factory _FeesDTO({required final List<FeesItemDTO> items}) =
      _$FeesDTOImpl;
  const _FeesDTO._() : super._();

  @override
  List<FeesItemDTO> get items;

  /// Create a copy of FeesDTO
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$FeesDTOImplCopyWith<_$FeesDTOImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

FeesItemDTO _$FeesItemDTOFromJson(Map<String, dynamic> json) {
  return _FeesItemDTO.fromJson(json);
}

/// @nodoc
mixin _$FeesItemDTO {
  @JsonKey(name: 'Cost')
  double get cost => throw _privateConstructorUsedError;
  @JsonKey(name: 'ProRataCost')
  double? get proRataCost => throw _privateConstructorUsedError;
  @JsonKey(name: 'FeeType')
  String get feeType => throw _privateConstructorUsedError;

  /// Serializes this FeesItemDTO to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of FeesItemDTO
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $FeesItemDTOCopyWith<FeesItemDTO> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FeesItemDTOCopyWith<$Res> {
  factory $FeesItemDTOCopyWith(
    FeesItemDTO value,
    $Res Function(FeesItemDTO) then,
  ) = _$FeesItemDTOCopyWithImpl<$Res, FeesItemDTO>;
  @useResult
  $Res call({
    @JsonKey(name: 'Cost') double cost,
    @JsonKey(name: 'ProRataCost') double? proRataCost,
    @JsonKey(name: 'FeeType') String feeType,
  });
}

/// @nodoc
class _$FeesItemDTOCopyWithImpl<$Res, $Val extends FeesItemDTO>
    implements $FeesItemDTOCopyWith<$Res> {
  _$FeesItemDTOCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of FeesItemDTO
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? cost = null,
    Object? proRataCost = freezed,
    Object? feeType = null,
  }) {
    return _then(
      _value.copyWith(
            cost: null == cost
                ? _value.cost
                : cost // ignore: cast_nullable_to_non_nullable
                      as double,
            proRataCost: freezed == proRataCost
                ? _value.proRataCost
                : proRataCost // ignore: cast_nullable_to_non_nullable
                      as double?,
            feeType: null == feeType
                ? _value.feeType
                : feeType // ignore: cast_nullable_to_non_nullable
                      as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$FeesItemDTOImplCopyWith<$Res>
    implements $FeesItemDTOCopyWith<$Res> {
  factory _$$FeesItemDTOImplCopyWith(
    _$FeesItemDTOImpl value,
    $Res Function(_$FeesItemDTOImpl) then,
  ) = __$$FeesItemDTOImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: 'Cost') double cost,
    @JsonKey(name: 'ProRataCost') double? proRataCost,
    @JsonKey(name: 'FeeType') String feeType,
  });
}

/// @nodoc
class __$$FeesItemDTOImplCopyWithImpl<$Res>
    extends _$FeesItemDTOCopyWithImpl<$Res, _$FeesItemDTOImpl>
    implements _$$FeesItemDTOImplCopyWith<$Res> {
  __$$FeesItemDTOImplCopyWithImpl(
    _$FeesItemDTOImpl _value,
    $Res Function(_$FeesItemDTOImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of FeesItemDTO
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? cost = null,
    Object? proRataCost = freezed,
    Object? feeType = null,
  }) {
    return _then(
      _$FeesItemDTOImpl(
        cost: null == cost
            ? _value.cost
            : cost // ignore: cast_nullable_to_non_nullable
                  as double,
        proRataCost: freezed == proRataCost
            ? _value.proRataCost
            : proRataCost // ignore: cast_nullable_to_non_nullable
                  as double?,
        feeType: null == feeType
            ? _value.feeType
            : feeType // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$FeesItemDTOImpl extends _FeesItemDTO {
  const _$FeesItemDTOImpl({
    @JsonKey(name: 'Cost') required this.cost,
    @JsonKey(name: 'ProRataCost') this.proRataCost,
    @JsonKey(name: 'FeeType') required this.feeType,
  }) : super._();

  factory _$FeesItemDTOImpl.fromJson(Map<String, dynamic> json) =>
      _$$FeesItemDTOImplFromJson(json);

  @override
  @JsonKey(name: 'Cost')
  final double cost;
  @override
  @JsonKey(name: 'ProRataCost')
  final double? proRataCost;
  @override
  @JsonKey(name: 'FeeType')
  final String feeType;

  @override
  String toString() {
    return 'FeesItemDTO(cost: $cost, proRataCost: $proRataCost, feeType: $feeType)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FeesItemDTOImpl &&
            (identical(other.cost, cost) || other.cost == cost) &&
            (identical(other.proRataCost, proRataCost) ||
                other.proRataCost == proRataCost) &&
            (identical(other.feeType, feeType) || other.feeType == feeType));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, cost, proRataCost, feeType);

  /// Create a copy of FeesItemDTO
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$FeesItemDTOImplCopyWith<_$FeesItemDTOImpl> get copyWith =>
      __$$FeesItemDTOImplCopyWithImpl<_$FeesItemDTOImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$FeesItemDTOImplToJson(this);
  }
}

abstract class _FeesItemDTO extends FeesItemDTO {
  const factory _FeesItemDTO({
    @JsonKey(name: 'Cost') required final double cost,
    @JsonKey(name: 'ProRataCost') final double? proRataCost,
    @JsonKey(name: 'FeeType') required final String feeType,
  }) = _$FeesItemDTOImpl;
  const _FeesItemDTO._() : super._();

  factory _FeesItemDTO.fromJson(Map<String, dynamic> json) =
      _$FeesItemDTOImpl.fromJson;

  @override
  @JsonKey(name: 'Cost')
  double get cost;
  @override
  @JsonKey(name: 'ProRataCost')
  double? get proRataCost;
  @override
  @JsonKey(name: 'FeeType')
  String get feeType;

  /// Create a copy of FeesItemDTO
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$FeesItemDTOImplCopyWith<_$FeesItemDTOImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
