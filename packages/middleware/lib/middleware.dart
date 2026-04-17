library;

export 'package:auth/auth.dart';
export 'package:session_storage/session_storage.dart';

/// Deep-import auth implementation files if needed; not exported here to keep VM tests
/// free of `supabase_flutter` (Flutter-only). Resolve [AuthService] via [middlewareSl].
export 'middleware_clients.dart';
export 'src/auth/legacy_jwt_session_mapper.dart';
export 'src/injection.dart';
export 'src/middleware_infrastructure_module.dart';
