import 'package:client_models/client_models.dart';
import 'package:client_supabase/client_supabase.dart';

import '../../utils/vob_guid_normalize.dart';

/// Builds [LeagueFixtureDto] from Supabase rows + resolved venue + matched captain.
///
/// Mirrors `LeagueFixturesService._processFixtures` in
/// `packages/examples/file_examples/league_fixtures_service.dart` (minus cache / scorecards).
class LeagueFixtureAssembler {
  const LeagueFixtureAssembler();

  LeagueFixtureDto assemble({
    required LeagueFixtureRow row,
    ClubCaptainDTO? clubCaptain,
    required String venueDisplay,
  }) {
    final ladder = ladderTypeEnumFromIndex(row.ladderType) ?? LadderTypeEnum.mens;
    final opp = (row.opponent ?? '').trim();
    final isHome = row.isHome ?? false;
    final homeTeam = isHome ? 'VOB' : (opp.isEmpty ? '—' : opp);
    final awayTeam = isHome ? (opp.isEmpty ? '—' : opp) : 'VOB';

    return LeagueFixtureDto(
      id: row.id,
      homeTeam: homeTeam,
      awayTeam: awayTeam,
      fixtureDate: row.gameDate,
      venue: venueDisplay,
      status: _statusFor(row.gameDate),
      leagueTeam: row.leagueTeam ?? 0,
      ladderType: ladder,
      clubCaptain: clubCaptain,
    );
  }

  static String _statusFor(DateTime gameDate) {
    final g = gameDate.toUtc();
    final now = DateTime.now().toUtc();
    return g.isBefore(now) ? 'Completed' : 'Scheduled';
  }
}

/// Captain whose [ClubCaptainDTO.clubLocationFk], [leagueTeam], and [ladderType]
/// match the fixture’s opponent location and team (same rules as the legacy service).
ClubCaptainDTO? matchClubCaptainForFixture({
  required LeagueFixtureRow row,
  required LadderTypeEnum ladderType,
  required List<ClubCaptainDTO> captains,
}) {
  final locKey = normalizeVobGuid(row.opponentLocationId);
  if (locKey == null || locKey.isEmpty) return null;
  final team = row.leagueTeam;
  if (team == null) return null;

  for (final c in captains) {
    if (normalizeVobGuid(c.clubLocationFk) != locKey) continue;
    if (c.leagueTeam != team) continue;
    if (c.ladderType != ladderType) continue;
    return c;
  }
  return null;
}

/// [LocationsItemDTO] keyed by normalized [LocationsItemDTO.vobGuid].
Map<String, LocationsItemDTO> indexLocationsByVob(Iterable<LocationsItemDTO> locations) {
  final map = <String, LocationsItemDTO>{};
  for (final loc in locations) {
    final k = normalizeVobGuid(loc.vobGuid);
    if (k != null && k.isNotEmpty) {
      map[k] = loc;
    }
  }
  return map;
}

String venueDisplayForFixture(LeagueFixtureRow row, Map<String, LocationsItemDTO> byVob) {
  final key = normalizeVobGuid(row.opponentLocationId);
  if (key == null || key.isEmpty) {
    return row.opponentLocationId ?? '';
  }
  final loc = byVob[key];
  final name = loc?.name?.trim();
  if (name != null && name.isNotEmpty) return name;
  return row.opponentLocationId ?? '';
}
