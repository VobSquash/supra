import 'auth_result.dart';

/// Low-level credential and token operations (backend-specific).
///
/// Implemented in middleware using your API / legacy Parse proxy / future Supabase edge.
abstract class AuthRepository {
  /// Validates credentials with the canonical password backend (e.g. base64-encoded secret).
  Future<AuthResult> validateCredentials({
    required String email,
    required String encodedPassword,
  });

  /// Optional: obtain or refresh a legacy JWT after successful validation.
  Future<AuthResult> obtainSessionToken({required String email});

  /// Validate an existing JWT and produce a [AuthResult.session] snapshot.
  Future<AuthResult> validateSessionToken(String jwt);
}
