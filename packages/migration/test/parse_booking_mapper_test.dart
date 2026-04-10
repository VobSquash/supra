import 'package:migration/src/map/parse_to_supabase_mapper.dart';
import 'package:test/test.dart';

void main() {
  test('mapParseBookingToSupabaseRow maps ProfileFk string and BookingDate', () {
    final row = mapParseBookingToSupabaseRow({
      'objectId': 'b1',
      'ProfileFk': 'a1b2c3d4e5f6789012345678abcdef01',
      'CourtNo': 3,
      'BookingDate': {
        '__type': 'Date',
        'iso': '2026-04-09T14:30:00.000Z',
      },
      'DisplayName': 'Alice',
      'GroupBookingId': 7,
    });

    expect(row['court_no'], 3);
    expect(row['display_name'], 'Alice');
    expect(row['group_booking_id'], 7);
    expect(row['legacy_object_id'], 'b1');
    expect(row['booking_date'], '2026-04-09T14:30:00.000Z');
    expect(row['vob_guid'], 'a1b2c3d4-e5f6-7890-1234-5678abcdef01');
    expect(row['id'], bookingIdFor('b1'));
  });

  test('mapParseBookingToSupabaseRow uses ProfileId.Id when ProfileFk missing', () {
    final row = mapParseBookingToSupabaseRow({
      'objectId': 'b2',
      'BookingDate': {'__type': 'Date', 'iso': '2026-01-01T08:00:00.000Z'},
      'ProfileId': {
        'objectId': 'profPtr',
        'Id': 'fedcba0987654321fedcba0987654321',
      },
    });

    expect(row['vob_guid'], 'fedcba09-8765-4321-fedc-ba0987654321');
  });
}
