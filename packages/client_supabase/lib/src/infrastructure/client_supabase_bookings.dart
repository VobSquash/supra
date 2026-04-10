import 'package:dio/dio.dart';

import '../interfaces/i_client_supabase_bookings.dart';
import '../models/booking_with_profile_row.dart';
import '../models/supabase_config.dart';

class ClientSupabaseBookings implements IClientSupabaseBookings {
  ClientSupabaseBookings({required SupabaseConfig config, required Dio dio}) : _dio = dio;

  final Dio _dio;

  /// PostgREST embed via FK [vob_guid] → [profiles.vob_guid].
  static const _selectWithProfile = '*,profiles(*,profile_extensions(*))';

  @override
  Future<List<BookingWithProfileRow>> getBookings({required DateTime forDate}) async {
    final startLocal = DateTime(forDate.year, forDate.month, forDate.day);
    final endLocal = startLocal.add(const Duration(days: 1));
    final startUtc = startLocal.toUtc();
    final endUtc = endLocal.toUtc();
    final a = startUtc.toIso8601String();
    final b = endUtc.toIso8601String();
    // PostgREST: AND two filters on `booking_date` (half-open day range in UTC).
    final and = '(booking_date.gte."$a",booking_date.lt."$b")';

    final response = await _dio.get(
      '/bookings',
      queryParameters: <String, dynamic>{
        'select': _selectWithProfile,
        'and': and,
        'order': 'booking_date.asc,court_no.asc',
      },
    );

    final status = response.statusCode ?? 0;
    if (status < 200 || status >= 300) {
      throw DioException(
        requestOptions: response.requestOptions,
        response: response,
        type: DioExceptionType.badResponse,
        error: 'Failed to load bookings (HTTP $status)',
      );
    }

    final data = response.data;
    if (data is! List) {
      throw DioException(
        requestOptions: response.requestOptions,
        response: response,
        type: DioExceptionType.unknown,
        error: 'Unexpected bookings payload: expected a JSON array',
      );
    }

    return data
        .whereType<Map<String, dynamic>>()
        .map(BookingWithProfileRow.fromPostgrestJson)
        .toList(growable: false);
  }
}
