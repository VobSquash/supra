import 'package:dio/dio.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// On PostgREST **401** with a user JWT, refreshes the GoTrue session once and retries.
///
/// Pair with [SupabaseAuthDioInterceptor] (request interceptor runs first on retry).
/// Skips refresh when the request used the anon key or there is no refresh token.
class SupabaseRefreshOn401Interceptor extends Interceptor {
  SupabaseRefreshOn401Interceptor({required Dio dio, required this.anonKey}) : _dio = dio;

  static const retryExtraKey = 'supabase_dio_auth_retry';

  final Dio _dio;
  final String anonKey;

  Future<void>? _refreshInFlight;

  bool _requestUsedUserJwt(RequestOptions options) {
    final auth = options.headers['Authorization']?.toString() ?? '';
    if (!auth.startsWith('Bearer ')) return false;
    return auth != 'Bearer $anonKey';
  }

  Future<void> _refreshSessionCoalesced() {
    final inFlight = _refreshInFlight;
    if (inFlight != null) return inFlight;

    final future = Supabase.instance.client.auth.refreshSession().then((_) {});
    _refreshInFlight = future.whenComplete(() {
      _refreshInFlight = null;
    });
    return _refreshInFlight!;
  }

  @override
  Future<void> onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode != 401) {
      handler.next(err);
      return;
    }

    final options = err.requestOptions;
    if (options.extra[retryExtraKey] == true) {
      handler.next(err);
      return;
    }

    if (!_requestUsedUserJwt(options)) {
      handler.next(err);
      return;
    }

    final refreshToken = Supabase.instance.client.auth.currentSession?.refreshToken;
    if (refreshToken == null || refreshToken.isEmpty) {
      handler.next(err);
      return;
    }

    try {
      await _refreshSessionCoalesced();
    } catch (_) {
      handler.next(err);
      return;
    }

    options.extra[retryExtraKey] = true;
    try {
      final response = await _dio.fetch<dynamic>(options);
      handler.resolve(response);
    } on DioException catch (retryErr) {
      handler.next(retryErr);
    }
  }
}
