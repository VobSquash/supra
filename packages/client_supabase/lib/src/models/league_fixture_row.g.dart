// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'league_fixture_row.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LeagueFixtureRow _$LeagueFixtureRowFromJson(Map<String, dynamic> json) =>
    LeagueFixtureRow(
      id: json['id'] as String,
      gameDate: DateTime.parse(json['game_date'] as String),
      opponent: json['opponent'] as String?,
      opponentLocationId: json['opponent_location_id'] as String?,
      isHome: json['is_home'] as bool?,
      leagueTeam: (json['league_team'] as num?)?.toInt(),
      ladderType: (json['ladder_type'] as num?)?.toInt(),
      legacyObjectId: json['legacy_object_id'] as String?,
    );

Map<String, dynamic> _$LeagueFixtureRowToJson(LeagueFixtureRow instance) =>
    <String, dynamic>{
      'id': instance.id,
      'game_date': instance.gameDate.toIso8601String(),
      'opponent': instance.opponent,
      'opponent_location_id': instance.opponentLocationId,
      'is_home': instance.isHome,
      'league_team': instance.leagueTeam,
      'ladder_type': instance.ladderType,
      'legacy_object_id': instance.legacyObjectId,
    };
