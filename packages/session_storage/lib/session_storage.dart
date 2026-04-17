/// Persisted session snapshot and storage contracts for the Supra app.
///
/// **Prod:** Stores **Supabase session material** (and any non-secret profile fields
/// needed for UX) after password sign-in — **not** legacy HS256 `VobData` JWTs.
/// Persisted data + Supabase client session drive “still logged in” on app reopen.
///
/// **Logout** clears this store so the next cold start is logged out.
library;

export 'src/in_memory_session_store.dart';
export 'src/session_snapshot.dart';
export 'src/session_store.dart';
