// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'ladders_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$LaddersListDTO {
  List<LadderItemDTO>? get ladies => throw _privateConstructorUsedError;
  List<LadderItemDTO>? get men => throw _privateConstructorUsedError;
  List<LadderItemDTO>? get masters => throw _privateConstructorUsedError;
  bool get showLadderBreakdown => throw _privateConstructorUsedError;

  /// Create a copy of LaddersListDTO
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $LaddersListDTOCopyWith<LaddersListDTO> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LaddersListDTOCopyWith<$Res> {
  factory $LaddersListDTOCopyWith(
    LaddersListDTO value,
    $Res Function(LaddersListDTO) then,
  ) = _$LaddersListDTOCopyWithImpl<$Res, LaddersListDTO>;
  @useResult
  $Res call({
    List<LadderItemDTO>? ladies,
    List<LadderItemDTO>? men,
    List<LadderItemDTO>? masters,
    bool showLadderBreakdown,
  });
}

/// @nodoc
class _$LaddersListDTOCopyWithImpl<$Res, $Val extends LaddersListDTO>
    implements $LaddersListDTOCopyWith<$Res> {
  _$LaddersListDTOCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of LaddersListDTO
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? ladies = freezed,
    Object? men = freezed,
    Object? masters = freezed,
    Object? showLadderBreakdown = null,
  }) {
    return _then(
      _value.copyWith(
            ladies: freezed == ladies
                ? _value.ladies
                : ladies // ignore: cast_nullable_to_non_nullable
                      as List<LadderItemDTO>?,
            men: freezed == men
                ? _value.men
                : men // ignore: cast_nullable_to_non_nullable
                      as List<LadderItemDTO>?,
            masters: freezed == masters
                ? _value.masters
                : masters // ignore: cast_nullable_to_non_nullable
                      as List<LadderItemDTO>?,
            showLadderBreakdown: null == showLadderBreakdown
                ? _value.showLadderBreakdown
                : showLadderBreakdown // ignore: cast_nullable_to_non_nullable
                      as bool,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$LaddersListDTOImplCopyWith<$Res>
    implements $LaddersListDTOCopyWith<$Res> {
  factory _$$LaddersListDTOImplCopyWith(
    _$LaddersListDTOImpl value,
    $Res Function(_$LaddersListDTOImpl) then,
  ) = __$$LaddersListDTOImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    List<LadderItemDTO>? ladies,
    List<LadderItemDTO>? men,
    List<LadderItemDTO>? masters,
    bool showLadderBreakdown,
  });
}

/// @nodoc
class __$$LaddersListDTOImplCopyWithImpl<$Res>
    extends _$LaddersListDTOCopyWithImpl<$Res, _$LaddersListDTOImpl>
    implements _$$LaddersListDTOImplCopyWith<$Res> {
  __$$LaddersListDTOImplCopyWithImpl(
    _$LaddersListDTOImpl _value,
    $Res Function(_$LaddersListDTOImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of LaddersListDTO
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? ladies = freezed,
    Object? men = freezed,
    Object? masters = freezed,
    Object? showLadderBreakdown = null,
  }) {
    return _then(
      _$LaddersListDTOImpl(
        ladies: freezed == ladies
            ? _value._ladies
            : ladies // ignore: cast_nullable_to_non_nullable
                  as List<LadderItemDTO>?,
        men: freezed == men
            ? _value._men
            : men // ignore: cast_nullable_to_non_nullable
                  as List<LadderItemDTO>?,
        masters: freezed == masters
            ? _value._masters
            : masters // ignore: cast_nullable_to_non_nullable
                  as List<LadderItemDTO>?,
        showLadderBreakdown: null == showLadderBreakdown
            ? _value.showLadderBreakdown
            : showLadderBreakdown // ignore: cast_nullable_to_non_nullable
                  as bool,
      ),
    );
  }
}

/// @nodoc

class _$LaddersListDTOImpl extends _LaddersListDTO {
  const _$LaddersListDTOImpl({
    required final List<LadderItemDTO>? ladies,
    required final List<LadderItemDTO>? men,
    required final List<LadderItemDTO>? masters,
    required this.showLadderBreakdown,
  }) : _ladies = ladies,
       _men = men,
       _masters = masters,
       super._();

  final List<LadderItemDTO>? _ladies;
  @override
  List<LadderItemDTO>? get ladies {
    final value = _ladies;
    if (value == null) return null;
    if (_ladies is EqualUnmodifiableListView) return _ladies;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  final List<LadderItemDTO>? _men;
  @override
  List<LadderItemDTO>? get men {
    final value = _men;
    if (value == null) return null;
    if (_men is EqualUnmodifiableListView) return _men;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  final List<LadderItemDTO>? _masters;
  @override
  List<LadderItemDTO>? get masters {
    final value = _masters;
    if (value == null) return null;
    if (_masters is EqualUnmodifiableListView) return _masters;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  final bool showLadderBreakdown;

  @override
  String toString() {
    return 'LaddersListDTO(ladies: $ladies, men: $men, masters: $masters, showLadderBreakdown: $showLadderBreakdown)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LaddersListDTOImpl &&
            const DeepCollectionEquality().equals(other._ladies, _ladies) &&
            const DeepCollectionEquality().equals(other._men, _men) &&
            const DeepCollectionEquality().equals(other._masters, _masters) &&
            (identical(other.showLadderBreakdown, showLadderBreakdown) ||
                other.showLadderBreakdown == showLadderBreakdown));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    const DeepCollectionEquality().hash(_ladies),
    const DeepCollectionEquality().hash(_men),
    const DeepCollectionEquality().hash(_masters),
    showLadderBreakdown,
  );

  /// Create a copy of LaddersListDTO
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$LaddersListDTOImplCopyWith<_$LaddersListDTOImpl> get copyWith =>
      __$$LaddersListDTOImplCopyWithImpl<_$LaddersListDTOImpl>(
        this,
        _$identity,
      );
}

abstract class _LaddersListDTO extends LaddersListDTO {
  const factory _LaddersListDTO({
    required final List<LadderItemDTO>? ladies,
    required final List<LadderItemDTO>? men,
    required final List<LadderItemDTO>? masters,
    required final bool showLadderBreakdown,
  }) = _$LaddersListDTOImpl;
  const _LaddersListDTO._() : super._();

  @override
  List<LadderItemDTO>? get ladies;
  @override
  List<LadderItemDTO>? get men;
  @override
  List<LadderItemDTO>? get masters;
  @override
  bool get showLadderBreakdown;

  /// Create a copy of LaddersListDTO
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$LaddersListDTOImplCopyWith<_$LaddersListDTOImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
