part of 'league_fixtures_bloc.dart';

@freezed
class LeagueFixturesState with _$LeagueFixturesState {
  const factory LeagueFixturesState({
    required List<LeagueFixtureDto> fixtures,
    required BaseLoading status,
  }) = _LeagueFixturesState;

  factory LeagueFixturesState.initial() => LeagueFixturesState(
        fixtures: const [],
        status: BaseLoading.initial(),
      );
}
