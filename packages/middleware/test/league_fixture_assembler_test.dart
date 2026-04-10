import 'package:client_models/client_models.dart';
import 'package:client_supabase/client_supabase.dart';
import 'package:middleware/src/mappers/league_fixtures/league_fixture_assembler.dart';
import 'package:test/test.dart';

void main() {
  test('matchClubCaptainForFixture returns captain when location, team, ladder match', () {
    final row = LeagueFixtureRow(
      id: 'a',
      gameDate: DateTime.utc(2026, 1, 1),
      opponentLocationId: '11111111-1111-1111-1111-111111111101',
      leagueTeam: 3,
    );
    final captains = [
      const ClubCaptainDTO(
        captainName: 'Pat',
        captainContactNo: null,
        isCatering: null,
        leagueTeam: 3,
        clubLocationFk: '11111111-1111-1111-1111-111111111101',
        ladderType: LadderTypeEnum.mens,
      ),
    ];
    final captain = matchClubCaptainForFixture(
      row: row,
      ladderType: LadderTypeEnum.mens,
      captains: captains,
    );
    expect(captain?.captainName, 'Pat');
  });

  test('matchClubCaptainForFixture returns null when ladder differs', () {
    final row = LeagueFixtureRow(
      id: 'a',
      gameDate: DateTime.utc(2026, 1, 1),
      opponentLocationId: '11111111-1111-1111-1111-111111111101',
      leagueTeam: 3,
    );
    final captains = [
      const ClubCaptainDTO(
        captainName: 'Pat',
        captainContactNo: null,
        isCatering: null,
        leagueTeam: 3,
        clubLocationFk: '11111111-1111-1111-1111-111111111101',
        ladderType: LadderTypeEnum.ladies,
      ),
    ];
    final captain = matchClubCaptainForFixture(
      row: row,
      ladderType: LadderTypeEnum.mens,
      captains: captains,
    );
    expect(captain, isNull);
  });
}
