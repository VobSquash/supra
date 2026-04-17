import 'package:auth/auth.dart';
import 'package:session_storage/session_storage.dart';
import 'package:test/test.dart';

void main() {
  test('AuthResult signedIn carries session', () {
    const s = SessionSnapshot(email: 'a@b.com');
    const r = AuthResult.signedIn(s);
    expect(r.success, isTrue);
    expect(r.session?.email, 'a@b.com');
  });

  test('AuthResult failure', () {
    const r = AuthResult.failure('bad');
    expect(r.success, isFalse);
    expect(r.errorMessage, 'bad');
  });
}
