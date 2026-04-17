import 'dart:convert';

import 'package:http/http.dart' as http;

import '../migration_config_io.dart';
import 'plaintext_from_profile_password.dart';

/// One-off: read [profiles] row → decrypt `password` → `POST /auth/v1/admin/users`.
///
/// Requires [MigrationConfigFile.supabaseServiceRoleKey] (bypasses RLS on `profiles`,
/// and GoTrue admin permission).
class SupabaseAuthProfileImporter {
  SupabaseAuthProfileImporter({
    required this.migrationConfig,
    required this.serviceRoleKey,
  });

  final MigrationConfigFile migrationConfig;
  final String serviceRoleKey;

  String get _restBase {
    final u = migrationConfig.appConfig.supabaseUrl.trim();
    return u.endsWith('/') ? u.substring(0, u.length - 1) : u;
  }

  /// Fetches `email` + `password` from `public.profiles` and creates the Auth user.
  ///
  /// [dryRun] decrypts and validates but does not call Admin API.
  Future<AuthProfileImportResult> importOneEmail({
    required String email,
    required bool dryRun,
  }) async {
    final normalized = email.trim();
    if (normalized.isEmpty) {
      return AuthProfileImportResultFailure('Email is empty.');
    }

    final profile = await _fetchProfileRow(normalized);
    if (profile == null) {
      return AuthProfileImportResultFailure(
        'No profile row in public.profiles for email: $normalized',
      );
    }

    final stored = profile['password'];
    if (stored is! String || stored.isEmpty) {
      return AuthProfileImportResultFailure(
        'Profile has no non-empty password column for: $normalized',
      );
    }

    final plaintext = plaintextPasswordFromProfileField(stored);
    if (plaintext == null || plaintext.isEmpty) {
      return AuthProfileImportResultFailure(
        'Could not decrypt legacy password blob for: $normalized',
      );
    }

    if (dryRun) {
      return AuthProfileImportResultDryRunOk(
        email: profile['email'] as String? ?? normalized,
      );
    }

    final authEmail = (profile['email'] as String?)?.trim().isNotEmpty == true
        ? (profile['email'] as String).trim()
        : normalized;

    return _createAuthUser(
      email: authEmail,
      password: plaintext,
    );
  }

  Future<Map<String, dynamic>?> _fetchProfileRow(String email) async {
    final uri = Uri.parse('$_restBase/rest/v1/profiles').replace(
      queryParameters: <String, String>{
        'select': 'email,password',
        'email': 'eq.$email',
        'limit': '1',
      },
    );

    final response = await http.get(
      uri,
      headers: _restHeaders,
    );

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw StateError(
        'PostgREST profiles read failed (HTTP ${response.statusCode}): ${response.body}',
      );
    }

    final data = jsonDecode(response.body);
    if (data is! List || data.isEmpty) return null;
    final row = data.first;
    if (row is! Map<String, dynamic>) return null;
    return row;
  }

  Map<String, String> get _restHeaders => <String, String>{
        'apikey': serviceRoleKey,
        'Authorization': 'Bearer $serviceRoleKey',
        'Accept': 'application/json',
      };

  Future<AuthProfileImportResult> _createAuthUser({
    required String email,
    required String password,
  }) async {
    final uri = Uri.parse('$_restBase/auth/v1/admin/users');
    final response = await http.post(
      uri,
      headers: <String, String>{
        ..._restHeaders,
        'Content-Type': 'application/json',
      },
      body: jsonEncode(<String, dynamic>{
        'email': email,
        'password': password,
        'email_confirm': true,
      }),
    );

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return AuthProfileImportResultCreated(email: email);
    }

    final body = response.body;
    final lower = body.toLowerCase();
    if (response.statusCode == 422 ||
        (lower.contains('already') && lower.contains('registered'))) {
      return AuthProfileImportResultAlreadyExists(email: email);
    }

    return AuthProfileImportResultFailure(
      'Auth admin API failed (HTTP ${response.statusCode}): $body',
    );
  }
}

sealed class AuthProfileImportResult {}

class AuthProfileImportResultCreated extends AuthProfileImportResult {
  AuthProfileImportResultCreated({required this.email});
  final String email;
}

class AuthProfileImportResultAlreadyExists extends AuthProfileImportResult {
  AuthProfileImportResultAlreadyExists({required this.email});
  final String email;
}

class AuthProfileImportResultDryRunOk extends AuthProfileImportResult {
  AuthProfileImportResultDryRunOk({required this.email});
  final String email;
}

class AuthProfileImportResultFailure extends AuthProfileImportResult {
  AuthProfileImportResultFailure(this.message);
  final String message;
}
