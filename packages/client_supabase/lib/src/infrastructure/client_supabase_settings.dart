import 'package:dio/dio.dart';

import '../interfaces/i_client_supabase_settings.dart';
import '../models/settings_row.dart';
import '../models/supabase_config.dart';

class ClientSupabaseSettings implements IClientSupabaseSettings {
  ClientSupabaseSettings({required SupabaseConfig config, required Dio dio}) : _dio = dio;

  final Dio _dio;

  @override
  Future<List<SettingsRow>> getSettings() async {
    final response = await _dio.get(
      '/settings',
      queryParameters: const <String, dynamic>{'order': 'name.asc'},
    );

    final status = response.statusCode ?? 0;
    if (status < 200 || status >= 300) {
      throw DioException(
        requestOptions: response.requestOptions,
        response: response,
        type: DioExceptionType.badResponse,
        error: 'Failed to load settings (HTTP $status)',
      );
    }

    final data = response.data;
    if (data is! List) {
      throw DioException(
        requestOptions: response.requestOptions,
        response: response,
        type: DioExceptionType.unknown,
        error: 'Unexpected settings payload: expected a JSON array',
      );
    }

    return data.whereType<Map<String, dynamic>>().map(SettingsRow.fromJson).toList(growable: false);
  }

  @override
  Future<void> patchSettingValueWhereNameEq({
    required String settingName,
    required String value,
  }) async {
    final response = await _dio.patch<dynamic>(
      '/settings',
      queryParameters: <String, dynamic>{'name': 'eq.$settingName'},
      data: <String, dynamic>{'value': value},
      options: Options(headers: const <String, dynamic>{'Prefer': 'return=minimal'}),
    );

    final status = response.statusCode ?? 0;
    if (status < 200 || status >= 300) {
      throw DioException(
        requestOptions: response.requestOptions,
        response: response,
        type: DioExceptionType.badResponse,
        error: 'Failed to update settings row (HTTP $status)',
      );
    }
  }

  @override
  Future<void> patchSettingValueWhereIdEq({
    required String id,
    required String value,
  }) async {
    final response = await _dio.patch<dynamic>(
      '/settings',
      queryParameters: <String, dynamic>{'id': 'eq.$id'},
      data: <String, dynamic>{'value': value},
      options: Options(headers: const <String, dynamic>{
        'Prefer': 'return=representation',
      }),
    );

    final status = response.statusCode ?? 0;
    if (status < 200 || status >= 300) {
      throw DioException(
        requestOptions: response.requestOptions,
        response: response,
        type: DioExceptionType.badResponse,
        error: 'Failed to update settings row (HTTP $status)',
      );
    }

    final data = response.data;
    if (data is! List || data.isEmpty) {
      throw DioException(
        requestOptions: response.requestOptions,
        response: response,
        type: DioExceptionType.badResponse,
        error:
            'Settings PATCH returned no updated rows — check Supabase RLS (UPDATE policy on `settings`) or row id.',
      );
    }
  }
}
