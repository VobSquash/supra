import 'session_snapshot.dart';
import 'session_store.dart';

/// Non-persistent store for unit tests and local tooling.
class InMemorySessionStore implements SessionStore {
  SessionSnapshot? _snapshot;

  @override
  Future<void> clear() async {
    _snapshot = null;
  }

  @override
  Future<SessionSnapshot?> read() async => _snapshot;

  @override
  Future<void> write(SessionSnapshot snapshot) async {
    _snapshot = snapshot;
  }
}
