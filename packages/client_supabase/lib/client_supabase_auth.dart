/// Flutter / GoTrue: Dio interceptor that attaches the Supabase user JWT for PostgREST.
///
/// Import this only from Flutter apps (after [Supabase.initialize]). The main
/// [client_supabase] barrel stays VM-safe for CLI/tests without `dart:ui`.
library;

export 'src/injectables/supabase_auth_dio_interceptor.dart';
