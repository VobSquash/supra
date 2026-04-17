import 'dart:convert';
import 'dart:io';

import '../migration_config_io.dart';
import 'supabase_auth_profile_importer.dart';

/// CLI entry: load config, resolve service role, run [SupabaseAuthProfileImporter].
Future<void> runAuthProfileImport({
  required File configFile,
  required String email,
  required bool dryRun,
  String? supabaseKeyOverride,
}) async {
  final raw = await configFile.readAsString();
  final decoded = jsonDecode(raw);
  if (decoded is! Map<String, dynamic>) {
    stderr.writeln('Config root must be a JSON object');
    exitCode = 2;
    return;
  }

  final migrationFile = MigrationConfigFile.fromJson(decoded);
  final key = (supabaseKeyOverride != null && supabaseKeyOverride.isNotEmpty)
      ? supabaseKeyOverride
      : migrationFile.supabaseServiceRoleKey;

  if (key == null || key.isEmpty) {
    stderr.writeln(
      'Missing service role key. Set supabase_service_role_key in the config file '
      'or pass --supabase-key (never commit this key).',
    );
    exitCode = 2;
    return;
  }

  final importer = SupabaseAuthProfileImporter(
    migrationConfig: migrationFile,
    serviceRoleKey: key,
  );

  final result = await importer.importOneEmail(email: email, dryRun: dryRun);

  switch (result) {
    case AuthProfileImportResultCreated(:final email):
      stdout.writeln('Created auth.users entry for $email');
    case AuthProfileImportResultAlreadyExists(:final email):
      stdout.writeln(
        'Auth user already exists for $email — nothing to do (or use dashboard to reset).',
      );
    case AuthProfileImportResultDryRunOk(:final email):
      stdout.writeln(
        'Dry run OK: profile found, password decrypted. Would create auth user for $email',
      );
    case AuthProfileImportResultFailure(:final message):
      stderr.writeln(message);
      exitCode = 1;
  }
}
