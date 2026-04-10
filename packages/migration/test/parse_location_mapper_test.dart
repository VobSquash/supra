import 'package:migration/src/map/parse_to_supabase_mapper.dart';
import 'package:test/test.dart';

void main() {
  test('mapParseLocationToSupabaseRow maps Parse REST shape', () {
    final row = mapParseLocationToSupabaseRow({
      'objectId': 'abc123',
      'Id': '11111111-1111-1111-1111-111111111101',
      'Name': 'Test place',
      'Latitude': -36.5,
      'Longitude': 174.2,
      'Lookup': 'test-lookup',
    });

    expect(row['vob_guid'], '11111111-1111-1111-1111-111111111101');
    expect(row['name'], 'Test place');
    expect(row['latitude'], '-36.5');
    expect(row['longitude'], '174.2');
    expect(row['lookup'], 'test-lookup');
    expect(row['id'], isNotNull);
  });

  test('mapParseLocationToSupabaseRow accepts 32-char hex Id', () {
    final row = mapParseLocationToSupabaseRow({
      'objectId': 'x',
      'Id': '11111111111111111111111111111111',
      'Name': 'A',
    });

    expect(row['vob_guid'], '11111111-1111-1111-1111-111111111111');
  });
}
