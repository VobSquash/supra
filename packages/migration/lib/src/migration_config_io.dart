import 'package:client_models/client_models.dart';

/// Same shape as [AppConfig] JSON, plus optional [supabaseServiceRoleKey] for CLI migrations.
///
/// The service role value must not be committed; keep it in `migration_config.json` (gitignored).
class MigrationConfigFile {
  const MigrationConfigFile({
    required this.appConfig,
    this.supabaseServiceRoleKey,
  });

  final AppConfig appConfig;

  /// Used for PostgREST writes when `--migrate` is set (overrides anon key for [SupabaseConfig]).
  final String? supabaseServiceRoleKey;

  /// Strips migration-only keys, then parses the rest as [AppConfig].
  factory MigrationConfigFile.fromJson(Map<String, dynamic> json) {
    final copy = Map<String, dynamic>.from(json);
    final rawRole = copy.remove('supabase_service_role_key');
    String? serviceRole;
    if (rawRole is String) {
      final t = rawRole.trim();
      if (t.isNotEmpty) {
        serviceRole = t;
      }
    }

    return MigrationConfigFile(
      appConfig: AppConfig.fromJson(copy),
      supabaseServiceRoleKey: serviceRole,
    );
  }
}
