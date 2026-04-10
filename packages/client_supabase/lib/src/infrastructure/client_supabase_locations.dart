import 'package:dio/dio.dart';

import '../interfaces/i_client_supabase_locations.dart';
import '../models/location_row.dart';
import '../models/supabase_config.dart';

class ClientSupabaseLocations implements IClientSupabaseLocations {
  ClientSupabaseLocations({required SupabaseConfig config, required Dio dio}) : _dio = dio;

  final Dio _dio;

  @override
  Future<List<LocationRow>> getLocations() async {
    final response = await _dio.get(
      '/locations',
      queryParameters: const <String, dynamic>{'order': 'name.asc'},
    );

    final status = response.statusCode ?? 0;
    if (status < 200 || status >= 300) {
      throw DioException(
        requestOptions: response.requestOptions,
        response: response,
        type: DioExceptionType.badResponse,
        error: 'Failed to load locations (HTTP $status)',
      );
    }

    final data = response.data;
    if (data is! List) {
      throw DioException(
        requestOptions: response.requestOptions,
        response: response,
        type: DioExceptionType.unknown,
        error: 'Unexpected locations payload: expected a JSON array',
      );
    }

    return data.whereType<Map<String, dynamic>>().map(LocationRow.fromJson).toList(growable: false);
  }
}
