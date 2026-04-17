import 'package:test/test.dart';
import 'package:session_storage/session_storage.dart';

void main() {
  test('write then read returns snapshot', () async {
    final store = InMemorySessionStore();
    const s = SessionSnapshot(
      email: 'a@b.com',
      displayName: 'A B',
      vobGuid: '00000000-0000-4000-8000-000000000001',
      profileTypeId: 1,
      membershipTypeId: 6,
    );
    await store.write(s);
    final read = await store.read();
    expect(read?.email, s.email);
    expect(read?.vobGuid, s.vobGuid);
    expect(read?.membershipTypeId, s.membershipTypeId);
  });

  test('clear removes snapshot', () async {
    final store = InMemorySessionStore();
    await store.write(const SessionSnapshot(email: 'x@y.com'));
    await store.clear();
    expect(await store.read(), isNull);
  });

  test('SessionSnapshot json roundtrip', () {
    const original = SessionSnapshot(
      email: 'a@b.com',
      legacyJwt: 'jwt',
    );
    final decoded = SessionSnapshot.fromJson(original.toJson());
    expect(decoded.email, original.email);
    expect(decoded.legacyJwt, original.legacyJwt);
  });
}
