import 'package:client_models/client_models.dart';
import 'package:client_supabase/client_supabase.dart';
import 'package:injectable/injectable.dart';
import 'package:middleware/src/clients/league_fixtures/i_league_fixtures_facade.dart';
import 'package:middleware/src/injection.dart';
import 'package:middleware/src/mappers/club_captains/supabase_club_captain_mapper.dart';
import 'package:middleware/src/mappers/league_fixtures/league_fixture_assembler.dart';
import 'package:middleware/src/mappers/locations/supabase_location_mapper.dart';

@LazySingleton(as: ILeagueFixturesFacade)
class LeagueFixturesFacade implements ILeagueFixturesFacade {
  LeagueFixturesFacade();

  IClientSupabase get _client => middlewareSl<IClientSupabase>();

  static const _captainMapper = SupabaseClubCaptainMapper();
  static const _locationMapper = SupabaseLocationMapper();
  static const _assembler = LeagueFixtureAssembler();

  @override
  Future<List<LeagueFixtureDto>> loadLeagueFixtures() async {
    final fixtureRows = await _client.leagueFixtures.getLeagueFixtures();
    final captainRows = await _client.clubCaptains.getClubCaptains();
    final locationRows = await _client.locations.getLocations();

    final captains = captainRows
        .map((r) => _captainMapper.convert<ClubCaptainRow, ClubCaptainDTO>(r))
        .toList(growable: false);

    final locations = locationRows
        .map((r) => _locationMapper.convert<LocationRow, LocationsItemDTO>(r))
        .toList(growable: false);

    final byVob = indexLocationsByVob(locations);

    final out = <LeagueFixtureDto>[];
    for (final row in fixtureRows) {
      final ladder = ladderTypeEnumFromIndex(row.ladderType) ?? LadderTypeEnum.mens;
      final captain = matchClubCaptainForFixture(
        row: row,
        ladderType: ladder,
        captains: captains,
      );
      final venue = venueDisplayForFixture(row, byVob);
      out.add(
        _assembler.assemble(
          row: row,
          clubCaptain: captain,
          venueDisplay: venue,
        ),
      );
    }

    out.sort((a, b) => a.fixtureDate.compareTo(b.fixtureDate));
    return out;
  }
}
