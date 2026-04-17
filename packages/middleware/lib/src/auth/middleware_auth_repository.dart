import 'package:auth/auth.dart';
import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'password_codec.dart';
import 'supabase_session_mapper.dart';

/// Supabase Auth only: [signInWithPassword] after decoding the UI payload ([decodePasswordForSupabaseAuth]).
///
/// Requires [Supabase.initialize] before use (see app `bootstrap`).
@LazySingleton(as: AuthRepository)
class MiddlewareAuthRepository implements AuthRepository {
  MiddlewareAuthRepository();

  SupabaseClient get _client => Supabase.instance.client;

  @override
  Future<AuthResult> obtainSessionToken({required String email}) async {
    final session = _client.auth.currentSession;
    final user = _client.auth.currentUser;
    if (session == null || user == null) {
      return const AuthResult.failure('No Supabase session after sign-in');
    }
    return AuthResult.signedIn(
      sessionSnapshotFromSupabase(session: session, user: user),
    );
  }

  @override
  Future<AuthResult> validateCredentials({
    required String email,
    required String encodedPassword,
  }) async {
    final password = decodePasswordForSupabaseAuth(encodedPassword);
    try {
      await _client.auth.signInWithPassword(
        email: email.trim(),
        password: password,
      );
      return const AuthResult.credentialsOk();
    } on AuthException catch (e) {
      return AuthResult.failure(e.message);
    } catch (e) {
      return AuthResult.failure(e.toString());
    }
  }

  @override
  Future<AuthResult> validateSessionToken(String refreshOrLegacyToken) async {
    final trimmed = refreshOrLegacyToken.trim();
    if (trimmed.isEmpty) {
      return const AuthResult.failure('Empty token');
    }
    try {
      final response = await _client.auth.setSession(trimmed);
      final session = response.session;
      final user = response.user ?? _client.auth.currentUser;
      if (session == null || user == null) {
        return const AuthResult.failure('No session after setSession');
      }
      return AuthResult.signedIn(
        sessionSnapshotFromSupabase(session: session, user: user),
      );
    } on AuthException catch (e) {
      return AuthResult.failure(e.message);
    } catch (e) {
      return AuthResult.failure(e.toString());
    }
  }
}
