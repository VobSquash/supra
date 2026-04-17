import 'package:middleware/src/auth/legacy_jwt_session_mapper.dart';
import 'package:test/test.dart';

void main() {
  test('mapVobDataToSessionSnapshot accepts JSON string', () {
    const raw = '{"ProfileId":"x","Email":"e@e.com"}';
    final s = mapVobDataToSessionSnapshot(raw, legacyJwt: 'jwt');
    expect(s.vobGuid, 'x');
    expect(s.email, 'e@e.com');
    expect(s.legacyJwt, 'jwt');
  });
}
