import 'package:meta/meta.dart';
import 'package:session_storage/session_storage.dart';

/// Outcome of credential checks, token issuance, or validation.
@immutable
class AuthResult {
  const AuthResult({
    required this.success,
    this.errorMessage,
    this.session,
  });

  /// Credential check passed (no session built yet).
  const AuthResult.credentialsOk()
      : success = true,
        errorMessage = null,
        session = null;

  const AuthResult.signedIn(SessionSnapshot snapshot)
      : success = true,
        errorMessage = null,
        session = snapshot;

  const AuthResult.failure(this.errorMessage)
      : success = false,
        session = null;

  final bool success;
  final String? errorMessage;

  /// Present after full sign-in or token validation.
  final SessionSnapshot? session;
}
