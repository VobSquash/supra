import 'package:migration/src/map/parse_to_supabase_mapper.dart';
import 'package:test/test.dart';

void main() {
  test('mapParseLeagueFixtureToSupabaseRow maps Parse Date object and fields', () {
    final row = mapParseLeagueFixtureToSupabaseRow({
      'objectId': 'fx1',
      'gameDate': {
        '__type': 'Date',
        'iso': '2026-03-15T10:00:00.000Z',
      },
      'opponent': 'Other Club',
      'opponentLocationId': 'loc-guid-1',
      'isHome': true,
      'leagueTeam': 2,
      'ladderType': 1,
    });

    expect(row['opponent'], 'Other Club');
    expect(row['opponent_location_id'], 'loc-guid-1');
    expect(row['is_home'], true);
    expect(row['league_team'], 2);
    expect(row['ladder_type'], 1);
    expect(row['legacy_object_id'], 'fx1');
    expect(row['game_date'], '2026-03-15T10:00:00.000Z');
  });

  test('mapParseLeagueFixtureToSupabaseRow extracts opponentLocationId pointer', () {
    final row = mapParseLeagueFixtureToSupabaseRow({
      'objectId': 'fx2',
      'gameDate': {'__type': 'Date', 'iso': '2026-01-01T00:00:00.000Z'},
      'opponentLocationId': {
        '__type': 'Pointer',
        'className': 'Locations',
        'objectId': 'ptrLoc',
      },
    });

    expect(row['opponent_location_id'], 'ptrLoc');
  });
}
