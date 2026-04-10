import 'package:migration/src/map/parse_to_supabase_mapper.dart';
import 'package:test/test.dart';

void main() {
  test('mapParseSettingsToSupabaseRow maps Parse REST shape', () {
    final row = mapParseSettingsToSupabaseRow({
      'objectId': 'abc',
      'Name': 'SystemSettings',
      'Value': '{"a":1}',
    });
    expect(row['name'], 'SystemSettings');
    expect(row['value'], '{"a":1}');
    expect(row['legacy_object_id'], 'abc');
    expect(row['id'], isNotNull);
  });
}
