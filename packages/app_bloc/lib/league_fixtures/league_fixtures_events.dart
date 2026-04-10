part of 'league_fixtures_bloc.dart';

@freezed
class LeagueFixturesEvent with _$LeagueFixturesEvent {
  const factory LeagueFixturesEvent.onLoadLeagueFixtures() = OnLoadLeagueFixtures;

  const factory LeagueFixturesEvent.onResetLeagueFixtures() = OnResetLeagueFixtures;
}
