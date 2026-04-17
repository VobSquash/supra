import 'package:dio/dio.dart';
import 'package:client_models/client_models.dart';

import '../interfaces/i_client_supabase_bookings.dart';
import '../models/booking_with_profile_row.dart';
import '../models/supabase_config.dart';

class ClientSupabaseBookings implements IClientSupabaseBookings {
  ClientSupabaseBookings({required SupabaseConfig config, required Dio dio})
    : _dio = dio;

  final Dio _dio;

  /// PostgREST embed via FK [vob_guid] → [profiles.vob_guid].
  static const _selectWithProfile = '*,profiles(*,profile_extensions(*))';

  @override
  Future<List<BookingWithProfileRow>> getBookings({
    required DateTime forDate,
  }) async {
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

  @override
  Future<void> createBooking({required CreateBookingDto booking}) async {
    final response = await _dio.post(
      '/bookings',
      data: <String, dynamic>{
        'court_no': booking.courtNo,
        'booking_date': booking.bookingDate.toUtc().toIso8601String(),
        'vob_guid': booking.vobGuid,
        'display_name': booking.displayName,
        'group_booking_id': booking.groupBookingId,
        'legacy_object_id': booking.legacyObjectId,
      },
    );

    final status = response.statusCode ?? 0;
    if (status < 200 || status >= 300) {
      final details = _postgrestErrorText(response.data);
      throw DioException(
        requestOptions: response.requestOptions,
        response: response,
        type: DioExceptionType.badResponse,
        error:
            'Failed to create booking (HTTP $status)${details == null ? '' : ': $details'}',
      );
    }
  }

  @override
  Future<void> deleteBooking({required String bookingId}) async {
    // PostgREST returns 2xx even when RLS deletes 0 rows — we must verify a row came back.
    final response = await _dio.delete<dynamic>(
      '/bookings',
      queryParameters: <String, dynamic>{'id': 'eq.$bookingId', 'select': 'id'},
      options: Options(
        headers: <String, dynamic>{'Prefer': 'return=representation'},
      ),
    );

    final status = response.statusCode ?? 0;
    if (status < 200 || status >= 300) {
      final details = _postgrestErrorText(response.data);
      throw DioException(
        requestOptions: response.requestOptions,
        response: response,
        type: DioExceptionType.badResponse,
        error:
            'Failed to delete booking (HTTP $status)${details == null ? '' : ': $details'}',
      );
    }

    final data = response.data;
    if (data == null) {
      throw DioException(
        requestOptions: response.requestOptions,
        response: response,
        type: DioExceptionType.badResponse,
        error:
            'Delete removed no rows (empty body — often RLS blocked delete or wrong id).',
      );
    }
    if (data is List) {
      if (data.isEmpty) {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          type: DioExceptionType.badResponse,
          error:
              'Delete removed no rows (wrong id, or RLS denied — ensure profiles.id = auth.uid() and bookings_delete_own policy exists).',
        );
      }
      return;
    }

    throw DioException(
      requestOptions: response.requestOptions,
      response: response,
      type: DioExceptionType.unknown,
      error:
          'Unexpected delete response: expected a JSON array (Prefer: return=representation).',
    );
  }

  @override
  Future<int> fetchMaxGroupBookingId() async {
    final response = await _dio.get(
      '/bookings',
      queryParameters: <String, dynamic>{
        'select': 'group_booking_id',
        'group_booking_id': 'gt.0',
        'order': 'group_booking_id.desc',
        'limit': 1,
      },
    );

    final status = response.statusCode ?? 0;
    if (status < 200 || status >= 300) {
      throw DioException(
        requestOptions: response.requestOptions,
        response: response,
        type: DioExceptionType.badResponse,
        error: 'Failed to load max group_booking_id (HTTP $status)',
      );
    }

    final data = response.data;
    if (data is! List || data.isEmpty) return 0;
    final row = data.first;
    if (row is! Map<String, dynamic>) return 0;
    final v = row['group_booking_id'];
    if (v is int) return v;
    if (v is num) return v.toInt();
    return 0;
  }
}

String? _postgrestErrorText(Object? data) {
  if (data is! Map) return null;
  final message = data['message']?.toString().trim();
  final details = data['details']?.toString().trim();
  final hint = data['hint']?.toString().trim();
  final parts = <String>[
    if (message != null && message.isNotEmpty) message,
    if (details != null && details.isNotEmpty) details,
    if (hint != null && hint.isNotEmpty) hint,
  ];
  if (parts.isEmpty) return null;
  return parts.join(' | ');
}
