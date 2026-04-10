// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'league_fixture.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$LeagueFixtureDto {
  String get id => throw _privateConstructorUsedError;
  String get homeTeam => throw _privateConstructorUsedError;
  String get awayTeam => throw _privateConstructorUsedError;
  DateTime get fixtureDate => throw _privateConstructorUsedError;
  String get venue => throw _privateConstructorUsedError;
  String get status => throw _privateConstructorUsedError;
  int get leagueTeam => throw _privateConstructorUsedError;
  LadderTypeEnum get ladderType => throw _privateConstructorUsedError;
  ClubCaptainDTO? get clubCaptain => throw _privateConstructorUsedError;

  /// Create a copy of LeagueFixtureDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $LeagueFixtureDtoCopyWith<LeagueFixtureDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LeagueFixtureDtoCopyWith<$Res> {
  factory $LeagueFixtureDtoCopyWith(
    LeagueFixtureDto value,
    $Res Function(LeagueFixtureDto) then,
  ) = _$LeagueFixtureDtoCopyWithImpl<$Res, LeagueFixtureDto>;
  @useResult
  $Res call({
    String id,
    String homeTeam,
    String awayTeam,
    DateTime fixtureDate,
    String venue,
    String status,
    int leagueTeam,
    LadderTypeEnum ladderType,
    ClubCaptainDTO? clubCaptain,
  });

  $ClubCaptainDTOCopyWith<$Res>? get clubCaptain;
}

/// @nodoc
class _$LeagueFixtureDtoCopyWithImpl<$Res, $Val extends LeagueFixtureDto>
    implements $LeagueFixtureDtoCopyWith<$Res> {
  _$LeagueFixtureDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of LeagueFixtureDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? homeTeam = null,
    Object? awayTeam = null,
    Object? fixtureDate = null,
    Object? venue = null,
    Object? status = null,
    Object? leagueTeam = null,
    Object? ladderType = null,
    Object? clubCaptain = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            homeTeam: null == homeTeam
                ? _value.homeTeam
                : homeTeam // ignore: cast_nullable_to_non_nullable
                      as String,
            awayTeam: null == awayTeam
                ? _value.awayTeam
                : awayTeam // ignore: cast_nullable_to_non_nullable
                      as String,
            fixtureDate: null == fixtureDate
                ? _value.fixtureDate
                : fixtureDate // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            venue: null == venue
                ? _value.venue
                : venue // ignore: cast_nullable_to_non_nullable
                      as String,
            status: null == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as String,
            leagueTeam: null == leagueTeam
                ? _value.leagueTeam
                : leagueTeam // ignore: cast_nullable_to_non_nullable
                      as int,
            ladderType: null == ladderType
                ? _value.ladderType
                : ladderType // ignore: cast_nullable_to_non_nullable
                      as LadderTypeEnum,
            clubCaptain: freezed == clubCaptain
                ? _value.clubCaptain
                : clubCaptain // ignore: cast_nullable_to_non_nullable
                      as ClubCaptainDTO?,
          )
          as $Val,
    );
  }

  /// Create a copy of LeagueFixtureDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ClubCaptainDTOCopyWith<$Res>? get clubCaptain {
    if (_value.clubCaptain == null) {
      return null;
    }

    return $ClubCaptainDTOCopyWith<$Res>(_value.clubCaptain!, (value) {
      return _then(_value.copyWith(clubCaptain: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$LeagueFixtureDtoImplCopyWith<$Res>
    implements $LeagueFixtureDtoCopyWith<$Res> {
  factory _$$LeagueFixtureDtoImplCopyWith(
    _$LeagueFixtureDtoImpl value,
    $Res Function(_$LeagueFixtureDtoImpl) then,
  ) = __$$LeagueFixtureDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String homeTeam,
    String awayTeam,
    DateTime fixtureDate,
    String venue,
    String status,
    int leagueTeam,
    LadderTypeEnum ladderType,
    ClubCaptainDTO? clubCaptain,
  });

  @override
  $ClubCaptainDTOCopyWith<$Res>? get clubCaptain;
}

/// @nodoc
class __$$LeagueFixtureDtoImplCopyWithImpl<$Res>
    extends _$LeagueFixtureDtoCopyWithImpl<$Res, _$LeagueFixtureDtoImpl>
    implements _$$LeagueFixtureDtoImplCopyWith<$Res> {
  __$$LeagueFixtureDtoImplCopyWithImpl(
    _$LeagueFixtureDtoImpl _value,
    $Res Function(_$LeagueFixtureDtoImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of LeagueFixtureDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? homeTeam = null,
    Object? awayTeam = null,
    Object? fixtureDate = null,
    Object? venue = null,
    Object? status = null,
    Object? leagueTeam = null,
    Object? ladderType = null,
    Object? clubCaptain = freezed,
  }) {
    return _then(
      _$LeagueFixtureDtoImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        homeTeam: null == homeTeam
            ? _value.homeTeam
            : homeTeam // ignore: cast_nullable_to_non_nullable
                  as String,
        awayTeam: null == awayTeam
            ? _value.awayTeam
            : awayTeam // ignore: cast_nullable_to_non_nullable
                  as String,
        fixtureDate: null == fixtureDate
            ? _value.fixtureDate
            : fixtureDate // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        venue: null == venue
            ? _value.venue
            : venue // ignore: cast_nullable_to_non_nullable
                  as String,
        status: null == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as String,
        leagueTeam: null == leagueTeam
            ? _value.leagueTeam
            : leagueTeam // ignore: cast_nullable_to_non_nullable
                  as int,
        ladderType: null == ladderType
            ? _value.ladderType
            : ladderType // ignore: cast_nullable_to_non_nullable
                  as LadderTypeEnum,
        clubCaptain: freezed == clubCaptain
            ? _value.clubCaptain
            : clubCaptain // ignore: cast_nullable_to_non_nullable
                  as ClubCaptainDTO?,
      ),
    );
  }
}

/// @nodoc

class _$LeagueFixtureDtoImpl extends _LeagueFixtureDto {
  const _$LeagueFixtureDtoImpl({
    required this.id,
    required this.homeTeam,
    required this.awayTeam,
    required this.fixtureDate,
    required this.venue,
    required this.status,
    required this.leagueTeam,
    required this.ladderType,
    required this.clubCaptain,
  }) : super._();

  @override
  final String id;
  @override
  final String homeTeam;
  @override
  final String awayTeam;
  @override
  final DateTime fixtureDate;
  @override
  final String venue;
  @override
  final String status;
  @override
  final int leagueTeam;
  @override
  final LadderTypeEnum ladderType;
  @override
  final ClubCaptainDTO? clubCaptain;

  @override
  String toString() {
    return 'LeagueFixtureDto(id: $id, homeTeam: $homeTeam, awayTeam: $awayTeam, fixtureDate: $fixtureDate, venue: $venue, status: $status, leagueTeam: $leagueTeam, ladderType: $ladderType, clubCaptain: $clubCaptain)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LeagueFixtureDtoImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.homeTeam, homeTeam) ||
                other.homeTeam == homeTeam) &&
            (identical(other.awayTeam, awayTeam) ||
                other.awayTeam == awayTeam) &&
            (identical(other.fixtureDate, fixtureDate) ||
                other.fixtureDate == fixtureDate) &&
            (identical(other.venue, venue) || other.venue == venue) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.leagueTeam, leagueTeam) ||
                other.leagueTeam == leagueTeam) &&
            (identical(other.ladderType, ladderType) ||
                other.ladderType == ladderType) &&
            (identical(other.clubCaptain, clubCaptain) ||
                other.clubCaptain == clubCaptain));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    homeTeam,
    awayTeam,
    fixtureDate,
    venue,
    status,
    leagueTeam,
    ladderType,
    clubCaptain,
  );

  /// Create a copy of LeagueFixtureDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$LeagueFixtureDtoImplCopyWith<_$LeagueFixtureDtoImpl> get copyWith =>
      __$$LeagueFixtureDtoImplCopyWithImpl<_$LeagueFixtureDtoImpl>(
        this,
        _$identity,
      );
}

abstract class _LeagueFixtureDto extends LeagueFixtureDto {
  const factory _LeagueFixtureDto({
    required final String id,
    required final String homeTeam,
    required final String awayTeam,
    required final DateTime fixtureDate,
    required final String venue,
    required final String status,
    required final int leagueTeam,
    required final LadderTypeEnum ladderType,
    required final ClubCaptainDTO? clubCaptain,
  }) = _$LeagueFixtureDtoImpl;
  const _LeagueFixtureDto._() : super._();

  @override
  String get id;
  @override
  String get homeTeam;
  @override
  String get awayTeam;
  @override
  DateTime get fixtureDate;
  @override
  String get venue;
  @override
  String get status;
  @override
  int get leagueTeam;
  @override
  LadderTypeEnum get ladderType;
  @override
  ClubCaptainDTO? get clubCaptain;

  /// Create a copy of LeagueFixtureDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$LeagueFixtureDtoImplCopyWith<_$LeagueFixtureDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
