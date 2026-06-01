/// Flutter / GoTrue: Dio interceptors for PostgREST auth and 401 session refresh.
///
/// Import this only from Flutter apps (after [Supabase.initialize]). The main
/// [client_supabase] barrel stays VM-safe for CLI/tests without `dart:ui`.
library;

export 'src/injectables/attach_supabase_dio_auth.dart';
export 'src/injectables/supabase_auth_dio_interceptor.dart';
export 'src/injectables/supabase_refresh_on_401_dio_interceptor.dart';
