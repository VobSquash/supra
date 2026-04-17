import 'package:app_bloc/app_bloc.dart';
import 'package:client_models/client_models.dart';
import 'package:middleware/middleware_clients.dart';
import 'package:test/test.dart';

class _FakeLeagueFixturesFacade implements ILeagueFixturesFacade {
  @override
  Future<List<LeagueFixtureDto>> loadLeagueFixtures() async => [
        LeagueFixtureDto.empty().copyWith(
          id: '1',
          homeTeam: 'VOB',
          awayTeam: 'Other',
          fixtureDate: DateTime.utc(2026, 6, 1),
          venue: 'Court A',
          status: 'Scheduled',
          leagueTeam: 1,
          ladderType: LadderTypeEnum.mens,
        ),
      ];
}

void main() {
  test('onLoadLeagueFixtures ends in loadingSuccess', () async {
    final bloc = LeagueFixturesBloc(_FakeLeagueFixturesFacade());

    bloc.add(const LeagueFixturesEvent.onLoadLeagueFixtures());
    await bloc.stream.firstWhere(
      (s) => s.status.status == BaseLoadingStatus.loadingSuccess,
    );
    expect(bloc.state.fixtures.length, 1);
    expect(bloc.state.fixtures.single.homeTeam, 'VOB');
    await bloc.close();
  });
}
