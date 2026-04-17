import 'session_snapshot.dart';

/// Persists [SessionSnapshot] for cold start and logout.
///
/// Implementations may use Hive, shared preferences (non-secrets only), or an
/// encrypted store. Keep long-lived secrets in [SecureTokenStore] when added.
abstract class SessionStore {
  /// Current session, or null if logged out / first launch.
  Future<SessionSnapshot?> read();

  /// Replace persisted session (full overwrite).
  Future<void> write(SessionSnapshot snapshot);

  /// Remove session data (call on logout).
  Future<void> clear();
}
