/// Sign-in orchestration contracts and result types for the Supra app.
///
/// **Production session contract (Supabase-only tokens; no legacy JWT in prod;
/// fix-forward, no rollback):**
///
/// 1. **Cold app open** — No session is stored yet for this release’s cutover, so
///    “logged in?” is **false** until the user signs in (or until persisted Supabase
///    session restore succeeds).
///
/// 2. **Sign-in** — Password verified (existing backend) → **Supabase Auth session**
///    (access/refresh JWTs) → persist via `session_storage` what the app needs for
///    restarts. **RLS** applies to all calls using the authenticated Supabase JWT.
///
/// 3. **Later app opens** — **true** until explicit **logout** (clear storage +
///    Supabase `signOut`). Session implies Supabase auth has succeeded.
///
/// Concrete implementations live in middleware; this package stays free of HTTP /
/// `client_supabase` details.
///
/// **Supabase-specific glue** (e.g. Dio `Authorization` from GoTrue) lives in
/// `client_supabase` next to the REST client.
library;

export 'src/auth_repository.dart';
export 'src/auth_result.dart';
export 'src/auth_service.dart';
