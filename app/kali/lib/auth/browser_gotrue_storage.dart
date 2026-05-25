import 'package:supabase/supabase.dart';
import 'package:web/web.dart' as web;

/// Persists PKCE **code verifier** keys for pure-Dart [`SupabaseClient`] on web.
///
/// Full session persistence is handled separately (see
/// [supabase_web_session_persistence.dart]) using the same `localStorage` key
/// as `supabase_flutter` on web (`sb-<ref>-auth-token`).
class BrowserGotrueStorage extends GotrueAsyncStorage {
  @override
  Future<String?> getItem({required String key}) async => web.window.localStorage.getItem(key);

  @override
  Future<void> removeItem({required String key}) async => web.window.localStorage.removeItem(key);

  @override
  Future<void> setItem({required String key, required String value}) async =>
      web.window.localStorage.setItem(key, value);
}
