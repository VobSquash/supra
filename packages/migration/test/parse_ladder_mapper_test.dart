import 'package:client_models/client_models.dart';
import 'package:migration/src/map/parse_to_supabase_mapper.dart';
import 'package:test/test.dart';

void main() {
  test('mapParseLadderRowToSupabase maps included ProfileId', () {
    final row = mapParseLadderRowToSupabase(
      parseRow: {
        'objectId': 'l1',
        'Order': 1,
        'Year': 2026,
        'ProfileId': {
          'objectId': 'p1',
          'Id': '11111111-1111-1111-1111-111111111101',
        },
      },
      ladderTypeIdentifier: LadderTypeEnum.mens.identifierType,
    );

    expect(row['sort_order'], 1);
    expect(row['year'], 2026);
    expect(row['legacy_object_id'], 'l1');
    expect(row['vob_guid'], '11111111-1111-1111-1111-111111111101');
  });
}
