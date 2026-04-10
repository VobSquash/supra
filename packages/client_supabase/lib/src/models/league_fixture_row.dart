import 'package:json_annotation/json_annotation.dart';

part 'league_fixture_row.g.dart';

/// Supabase `league_fixtures` row (Parse `LeagueFixture`).
@JsonSerializable()
class LeagueFixtureRow {
  const LeagueFixtureRow({
    required this.id,
    required this.gameDate,
    this.opponent,
    this.opponentLocationId,
    this.isHome,
    this.leagueTeam,
    this.ladderType,
    this.legacyObjectId,
  });

  factory LeagueFixtureRow.fromJson(Map<String, dynamic> json) => _$LeagueFixtureRowFromJson(json);

  final String id;

  @JsonKey(name: 'game_date')
  final DateTime gameDate;

  final String? opponent;

  @JsonKey(name: 'opponent_location_id')
  final String? opponentLocationId;

  @JsonKey(name: 'is_home')
  final bool? isHome;

  @JsonKey(name: 'league_team')
  final int? leagueTeam;

  @JsonKey(name: 'ladder_type')
  final int? ladderType;

  @JsonKey(name: 'legacy_object_id')
  final String? legacyObjectId;

  Map<String, dynamic> toJson() => _$LeagueFixtureRowToJson(this);
}
