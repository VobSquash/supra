import 'package:migration/src/map/parse_to_supabase_mapper.dart';
import 'package:test/test.dart';

void main() {
  test('mapParseLeagueCaptainToSupabaseRow maps Parse REST shape', () {
    final row = mapParseLeagueCaptainToSupabaseRow({
      'objectId': 'oc1',
      'ClubName': 'Alpha',
      'CaptainName': 'Pat',
      'ContactNumber': '555',
      'Catering': true,
      'LeagueTeam': 2,
      'ClubLocationFK': 'locObj1',
      'LadderType': 0,
    });

    expect(row['club_name'], 'Alpha');
    expect(row['captain_name'], 'Pat');
    expect(row['captain_contact_no'], '555');
    expect(row['is_catering'], true);
    expect(row['league_team'], 2);
    expect(row['club_location_fk'], 'locObj1');
    expect(row['ladder_type'], 0);
    expect(row['legacy_object_id'], 'oc1');
  });

  test('mapParseLeagueCaptainToSupabaseRow extracts pointer objectId', () {
    final row = mapParseLeagueCaptainToSupabaseRow({
      'objectId': 'oc2',
      'ClubLocationFK': {
        '__type': 'Pointer',
        'className': 'Locations',
        'objectId': 'ptr1',
      },
    });

    expect(row['club_location_fk'], 'ptr1');
  });
}
