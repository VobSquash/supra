import 'package:session_storage/session_storage.dart';

import 'auth_result.dart';

/// App-facing auth API: sign-in, restore, sign-out hooks.
///
/// **Prod:** After password verification, implementations establish a **Supabase**
/// session and persist session material via `session_storage`. “Logged in” on a later
/// open means that persisted state + Supabase session is still valid and the user has
/// not called [signOut].
abstract class AuthService {
  /// Full login: validate credentials, obtain tokens, build [SessionSnapshot].
  Future<AuthResult> signIn({
    required String email,
    required String encodedPassword,
  });

  /// Restore from persisted JWT / startup (optional cold-start path).
  Future<AuthResult> restoreFromStoredToken(String jwt);

  /// If GoTrue already has a session (e.g. after [Supabase.initialize]), maps it to
  /// [SessionSnapshot] and refreshes [SessionStore]. Otherwise returns `null`.
  Future<SessionSnapshot?> tryRestoreActiveSession();

  /// Clear local session; Supabase sign-out should be called by the implementation if used.
  Future<void> signOut();
}
