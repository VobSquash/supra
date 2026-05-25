import 'dart:convert';

import 'package:supabase/supabase.dart';
import 'package:web/web.dart' as web;

/// Same key as [supabase_flutter] `SharedPreferencesLocalStorage` on web
/// (`Supabase.initialize` default), so Kali shares session storage with Dupra web
/// when pointed at the same project URL.
String supabaseFlutterWebPersistKey(String supabaseUrl) {
  final host = Uri.parse(supabaseUrl.trim()).host.toLowerCase();
  if (host.isEmpty) {
    throw ArgumentError.value(supabaseUrl, 'supabaseUrl', 'must resolve to a host');
  }
  return 'sb-${host.split('.').first}-auth-token';
}

/// Persists session JSON to `localStorage` (Flutter-web compatible). Call before
/// [restoreSupabaseSessionFromBrowser] so recovery events are also written.
void listenPersistSupabaseSession(SupabaseClient client, String persistKey) {
  client.auth.onAuthStateChange.listen((AuthState data) {
    if (data.session != null) {
      web.window.localStorage.setItem(
        persistKey,
        jsonEncode(data.session!.toJson()),
      );
    } else if (data.event == AuthChangeEvent.signedOut) {
      web.window.localStorage.removeItem(persistKey);
    }
  });
}

/// Loads a previously persisted session and applies it to [client], refreshing
/// when the access token is expired (same idea as `SupabaseAuth.recoverSession`).
Future<void> restoreSupabaseSessionFromBrowser(
  SupabaseClient client,
  String persistKey,
) async {
  final raw = web.window.localStorage.getItem(persistKey);
  if (raw == null || raw.isEmpty) return;
  try {
    await client.auth.recoverSession(raw);
  } catch (_) {
    web.window.localStorage.removeItem(persistKey);
  }
}
