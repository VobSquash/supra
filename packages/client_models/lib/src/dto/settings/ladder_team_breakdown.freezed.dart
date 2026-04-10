// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'ladder_team_breakdown.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$BreakdownTeamsDTO {
  String? get objectId => throw _privateConstructorUsedError;
  List<BreakdownItemDTO>? get mensteams => throw _privateConstructorUsedError;
  List<BreakdownItemDTO>? get ladiesTeams => throw _privateConstructorUsedError;
  List<BreakdownItemDTO>? get mastersTeams =>
      throw _privateConstructorUsedError;

  /// Create a copy of BreakdownTeamsDTO
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $BreakdownTeamsDTOCopyWith<BreakdownTeamsDTO> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BreakdownTeamsDTOCopyWith<$Res> {
  factory $BreakdownTeamsDTOCopyWith(
    BreakdownTeamsDTO value,
    $Res Function(BreakdownTeamsDTO) then,
  ) = _$BreakdownTeamsDTOCopyWithImpl<$Res, BreakdownTeamsDTO>;
  @useResult
  $Res call({
    String? objectId,
    List<BreakdownItemDTO>? mensteams,
    List<BreakdownItemDTO>? ladiesTeams,
    List<BreakdownItemDTO>? mastersTeams,
  });
}

/// @nodoc
class _$BreakdownTeamsDTOCopyWithImpl<$Res, $Val extends BreakdownTeamsDTO>
    implements $BreakdownTeamsDTOCopyWith<$Res> {
  _$BreakdownTeamsDTOCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of BreakdownTeamsDTO
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? objectId = freezed,
    Object? mensteams = freezed,
    Object? ladiesTeams = freezed,
    Object? mastersTeams = freezed,
  }) {
    return _then(
      _value.copyWith(
            objectId: freezed == objectId
                ? _value.objectId
                : objectId // ignore: cast_nullable_to_non_nullable
                      as String?,
            mensteams: freezed == mensteams
                ? _value.mensteams
                : mensteams // ignore: cast_nullable_to_non_nullable
                      as List<BreakdownItemDTO>?,
            ladiesTeams: freezed == ladiesTeams
                ? _value.ladiesTeams
                : ladiesTeams // ignore: cast_nullable_to_non_nullable
                      as List<BreakdownItemDTO>?,
            mastersTeams: freezed == mastersTeams
                ? _value.mastersTeams
                : mastersTeams // ignore: cast_nullable_to_non_nullable
                      as List<BreakdownItemDTO>?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$BreakdownTeamsDTOImplCopyWith<$Res>
    implements $BreakdownTeamsDTOCopyWith<$Res> {
  factory _$$BreakdownTeamsDTOImplCopyWith(
    _$BreakdownTeamsDTOImpl value,
    $Res Function(_$BreakdownTeamsDTOImpl) then,
  ) = __$$BreakdownTeamsDTOImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String? objectId,
    List<BreakdownItemDTO>? mensteams,
    List<BreakdownItemDTO>? ladiesTeams,
    List<BreakdownItemDTO>? mastersTeams,
  });
}

/// @nodoc
class __$$BreakdownTeamsDTOImplCopyWithImpl<$Res>
    extends _$BreakdownTeamsDTOCopyWithImpl<$Res, _$BreakdownTeamsDTOImpl>
    implements _$$BreakdownTeamsDTOImplCopyWith<$Res> {
  __$$BreakdownTeamsDTOImplCopyWithImpl(
    _$BreakdownTeamsDTOImpl _value,
    $Res Function(_$BreakdownTeamsDTOImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of BreakdownTeamsDTO
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? objectId = freezed,
    Object? mensteams = freezed,
    Object? ladiesTeams = freezed,
    Object? mastersTeams = freezed,
  }) {
    return _then(
      _$BreakdownTeamsDTOImpl(
        objectId: freezed == objectId
            ? _value.objectId
            : objectId // ignore: cast_nullable_to_non_nullable
                  as String?,
        mensteams: freezed == mensteams
            ? _value._mensteams
            : mensteams // ignore: cast_nullable_to_non_nullable
                  as List<BreakdownItemDTO>?,
        ladiesTeams: freezed == ladiesTeams
            ? _value._ladiesTeams
            : ladiesTeams // ignore: cast_nullable_to_non_nullable
                  as List<BreakdownItemDTO>?,
        mastersTeams: freezed == mastersTeams
            ? _value._mastersTeams
            : mastersTeams // ignore: cast_nullable_to_non_nullable
                  as List<BreakdownItemDTO>?,
      ),
    );
  }
}

/// @nodoc

class _$BreakdownTeamsDTOImpl extends _BreakdownTeamsDTO {
  const _$BreakdownTeamsDTOImpl({
    required this.objectId,
    required final List<BreakdownItemDTO>? mensteams,
    required final List<BreakdownItemDTO>? ladiesTeams,
    required final List<BreakdownItemDTO>? mastersTeams,
  }) : _mensteams = mensteams,
       _ladiesTeams = ladiesTeams,
       _mastersTeams = mastersTeams,
       super._();

  @override
  final String? objectId;
  final List<BreakdownItemDTO>? _mensteams;
  @override
  List<BreakdownItemDTO>? get mensteams {
    final value = _mensteams;
    if (value == null) return null;
    if (_mensteams is EqualUnmodifiableListView) return _mensteams;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  final List<BreakdownItemDTO>? _ladiesTeams;
  @override
  List<BreakdownItemDTO>? get ladiesTeams {
    final value = _ladiesTeams;
    if (value == null) return null;
    if (_ladiesTeams is EqualUnmodifiableListView) return _ladiesTeams;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  final List<BreakdownItemDTO>? _mastersTeams;
  @override
  List<BreakdownItemDTO>? get mastersTeams {
    final value = _mastersTeams;
    if (value == null) return null;
    if (_mastersTeams is EqualUnmodifiableListView) return _mastersTeams;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  String toString() {
    return 'BreakdownTeamsDTO(objectId: $objectId, mensteams: $mensteams, ladiesTeams: $ladiesTeams, mastersTeams: $mastersTeams)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BreakdownTeamsDTOImpl &&
            (identical(other.objectId, objectId) ||
                other.objectId == objectId) &&
            const DeepCollectionEquality().equals(
              other._mensteams,
              _mensteams,
            ) &&
            const DeepCollectionEquality().equals(
              other._ladiesTeams,
              _ladiesTeams,
            ) &&
            const DeepCollectionEquality().equals(
              other._mastersTeams,
              _mastersTeams,
            ));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    objectId,
    const DeepCollectionEquality().hash(_mensteams),
    const DeepCollectionEquality().hash(_ladiesTeams),
    const DeepCollectionEquality().hash(_mastersTeams),
  );

  /// Create a copy of BreakdownTeamsDTO
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$BreakdownTeamsDTOImplCopyWith<_$BreakdownTeamsDTOImpl> get copyWith =>
      __$$BreakdownTeamsDTOImplCopyWithImpl<_$BreakdownTeamsDTOImpl>(
        this,
        _$identity,
      );
}

abstract class _BreakdownTeamsDTO extends BreakdownTeamsDTO {
  const factory _BreakdownTeamsDTO({
    required final String? objectId,
    required final List<BreakdownItemDTO>? mensteams,
    required final List<BreakdownItemDTO>? ladiesTeams,
    required final List<BreakdownItemDTO>? mastersTeams,
  }) = _$BreakdownTeamsDTOImpl;
  const _BreakdownTeamsDTO._() : super._();

  @override
  String? get objectId;
  @override
  List<BreakdownItemDTO>? get mensteams;
  @override
  List<BreakdownItemDTO>? get ladiesTeams;
  @override
  List<BreakdownItemDTO>? get mastersTeams;

  /// Create a copy of BreakdownTeamsDTO
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$BreakdownTeamsDTOImplCopyWith<_$BreakdownTeamsDTOImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$BreakdownItemDTO {
  int? get teamMemberCount => throw _privateConstructorUsedError;
  int? get teamNumber => throw _privateConstructorUsedError;

  /// Create a copy of BreakdownItemDTO
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $BreakdownItemDTOCopyWith<BreakdownItemDTO> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BreakdownItemDTOCopyWith<$Res> {
  factory $BreakdownItemDTOCopyWith(
    BreakdownItemDTO value,
    $Res Function(BreakdownItemDTO) then,
  ) = _$BreakdownItemDTOCopyWithImpl<$Res, BreakdownItemDTO>;
  @useResult
  $Res call({int? teamMemberCount, int? teamNumber});
}

/// @nodoc
class _$BreakdownItemDTOCopyWithImpl<$Res, $Val extends BreakdownItemDTO>
    implements $BreakdownItemDTOCopyWith<$Res> {
  _$BreakdownItemDTOCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of BreakdownItemDTO
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? teamMemberCount = freezed, Object? teamNumber = freezed}) {
    return _then(
      _value.copyWith(
            teamMemberCount: freezed == teamMemberCount
                ? _value.teamMemberCount
                : teamMemberCount // ignore: cast_nullable_to_non_nullable
                      as int?,
            teamNumber: freezed == teamNumber
                ? _value.teamNumber
                : teamNumber // ignore: cast_nullable_to_non_nullable
                      as int?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$BreakdownItemDTOImplCopyWith<$Res>
    implements $BreakdownItemDTOCopyWith<$Res> {
  factory _$$BreakdownItemDTOImplCopyWith(
    _$BreakdownItemDTOImpl value,
    $Res Function(_$BreakdownItemDTOImpl) then,
  ) = __$$BreakdownItemDTOImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int? teamMemberCount, int? teamNumber});
}

/// @nodoc
class __$$BreakdownItemDTOImplCopyWithImpl<$Res>
    extends _$BreakdownItemDTOCopyWithImpl<$Res, _$BreakdownItemDTOImpl>
    implements _$$BreakdownItemDTOImplCopyWith<$Res> {
  __$$BreakdownItemDTOImplCopyWithImpl(
    _$BreakdownItemDTOImpl _value,
    $Res Function(_$BreakdownItemDTOImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of BreakdownItemDTO
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? teamMemberCount = freezed, Object? teamNumber = freezed}) {
    return _then(
      _$BreakdownItemDTOImpl(
        teamMemberCount: freezed == teamMemberCount
            ? _value.teamMemberCount
            : teamMemberCount // ignore: cast_nullable_to_non_nullable
                  as int?,
        teamNumber: freezed == teamNumber
            ? _value.teamNumber
            : teamNumber // ignore: cast_nullable_to_non_nullable
                  as int?,
      ),
    );
  }
}

/// @nodoc

class _$BreakdownItemDTOImpl extends _BreakdownItemDTO {
  const _$BreakdownItemDTOImpl({
    required this.teamMemberCount,
    required this.teamNumber,
  }) : super._();

  @override
  final int? teamMemberCount;
  @override
  final int? teamNumber;

  @override
  String toString() {
    return 'BreakdownItemDTO(teamMemberCount: $teamMemberCount, teamNumber: $teamNumber)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BreakdownItemDTOImpl &&
            (identical(other.teamMemberCount, teamMemberCount) ||
                other.teamMemberCount == teamMemberCount) &&
            (identical(other.teamNumber, teamNumber) ||
                other.teamNumber == teamNumber));
  }

  @override
  int get hashCode => Object.hash(runtimeType, teamMemberCount, teamNumber);

  /// Create a copy of BreakdownItemDTO
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$BreakdownItemDTOImplCopyWith<_$BreakdownItemDTOImpl> get copyWith =>
      __$$BreakdownItemDTOImplCopyWithImpl<_$BreakdownItemDTOImpl>(
        this,
        _$identity,
      );
}

abstract class _BreakdownItemDTO extends BreakdownItemDTO {
  const factory _BreakdownItemDTO({
    required final int? teamMemberCount,
    required final int? teamNumber,
  }) = _$BreakdownItemDTOImpl;
  const _BreakdownItemDTO._() : super._();

  @override
  int? get teamMemberCount;
  @override
  int? get teamNumber;

  /// Create a copy of BreakdownItemDTO
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$BreakdownItemDTOImplCopyWith<_$BreakdownItemDTOImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
