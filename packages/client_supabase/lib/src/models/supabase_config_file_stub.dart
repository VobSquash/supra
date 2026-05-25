import 'supabase_config.dart';

/// Throws on web/WASM builds (no dart:io). Use HTTP / `fromJson` instead.
Future<SupabaseConfig> loadSupabaseConfigFromFile(String filePath) async {
  throw UnsupportedError(
    'loadSupabaseConfigFromFile is only supported where dart:io is available '
    '(CLI, Flutter mobile/desktop). Pass JSON via SupabaseConfig.fromJson on '
    'the web.',
  );
}

SupabaseConfig loadSupabaseConfigFromFileSync(String filePath) {
  throw UnsupportedError(
    'loadSupabaseConfigFromFileSync is only supported where dart:io is available '
    '(CLI, Flutter mobile/desktop). Pass JSON via SupabaseConfig.fromJson on '
    'the web.',
  );
}
