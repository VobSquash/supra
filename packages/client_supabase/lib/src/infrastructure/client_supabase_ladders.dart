import 'package:dio/dio.dart';

import '../interfaces/i_client_supabase_ladders.dart';
import '../models/ladder_entry_row.dart';
import '../models/ladder_entry_upsert.dart';
import '../models/ladder_entry_with_profile_row.dart';
import '../models/member_ladder_membership_with_profile_row.dart';
import '../models/supabase_config.dart';
import 'postgrest_uuid.dart';

class ClientSupabaseLadders implements IClientSupabaseLadders {
  ClientSupabaseLadders({required SupabaseConfig config, required Dio dio}) : _dio = dio;

  final Dio _dio;

  /// PostgREST embed via FK [vob_guid] → [profiles.vob_guid].
  static const _selectWithProfile = '*,profiles(*,profile_extensions(*))';

  @override
  Future<List<LadderEntryWithProfileRow>> getLadderMens() => _getTable('ladder_mens');

  @override
  Future<List<LadderEntryWithProfileRow>> getLadderLadies() => _getTable('ladder_ladies');

  @override
  Future<List<LadderEntryWithProfileRow>> getLadderMasters() => _getTable('ladder_masters');

  static const _viewMembershipWithProfile = 'v_member_ladder_membership_with_profile';

  @override
  Future<List<MemberLadderMembershipWithProfileRow>> getMemberLadderMembershipWithProfile(
    String vobGuid,
  ) async {
    final trimmed = vobGuid.trim();
    if (trimmed.isEmpty) {
      return const [];
    }
    final response = await _dio.get(
      '/$_viewMembershipWithProfile',
      queryParameters: <String, dynamic>{
        'select': '*',
        'vob_guid': 'eq.$trimmed',
        'order': 'ladder_type.asc,ladder_rank.asc',
      },
    );

    final status = response.statusCode ?? 0;
    if (status < 200 || status >= 300) {
      throw DioException(
        requestOptions: response.requestOptions,
        response: response,
        type: DioExceptionType.badResponse,
        error: 'Failed to load $_viewMembershipWithProfile (HTTP $status)',
      );
    }

    final data = response.data;
    if (data is! List) {
      throw DioException(
        requestOptions: response.requestOptions,
        response: response,
        type: DioExceptionType.unknown,
        error: 'Unexpected $_viewMembershipWithProfile payload: expected a JSON array',
      );
    }

    return data
        .whereType<Map<String, dynamic>>()
        .map(MemberLadderMembershipWithProfileRow.fromJson)
        .toList(growable: false);
  }

  @override
  Future<void> upsertLadderDivisionRows({
    required String table,
    required List<LadderEntryUpsert> rows,
  }) async {
    final safeTable = table.trim();
    if (!_allowedTables.contains(safeTable)) {
      throw ArgumentError('Unsupported ladder table: $safeTable');
    }
    if (rows.isEmpty) return;

    final existingResp = await _dio.get(
      '/$safeTable',
      queryParameters: const <String, dynamic>{
        'select': 'id,vob_guid,year',
      },
    );
    final existingStatus = existingResp.statusCode ?? 0;
    if (existingStatus < 200 || existingStatus >= 300) {
      throw DioException(
        requestOptions: existingResp.requestOptions,
        response: existingResp,
        type: DioExceptionType.badResponse,
        error: 'Failed to load $safeTable for upsert (HTTP $existingStatus)',
      );
    }
    final existingData = existingResp.data;
    if (existingData is! List) {
      throw DioException(
        requestOptions: existingResp.requestOptions,
        response: existingResp,
        type: DioExceptionType.unknown,
        error: 'Unexpected $safeTable payload while upserting',
      );
    }
    final existingRows = existingData
        .whereType<Map<String, dynamic>>()
        .map(LadderEntryRow.fromJson)
        .toList(growable: false);
    final year = DateTime.now().year;
    final idByGuidForYear = <String, String>{
      for (final r in existingRows)
        if ((r.vobGuid ?? '').trim().isNotEmpty && r.year == year)
          _normalizeGuidKey(r.vobGuid!): r.id,
    };

    final prefer = <String, dynamic>{'Prefer': 'return=representation'};
    var processed = 0;
    for (final row in rows) {
      final guid = row.vobGuid.trim();
      if (guid.isEmpty) continue;
      final currentId = idByGuidForYear[_normalizeGuidKey(guid)];
      if (currentId != null) {
        final patch = await _dio.patch<dynamic>(
          '/$safeTable',
          queryParameters: <String, dynamic>{'id': 'eq.$currentId'},
          data: <String, dynamic>{
            'sort_order': row.sortOrder,
            'team': row.team,
            'can_be_challenged': row.canBeChallenged,
          },
          options: Options(headers: prefer),
        );
        final code = patch.statusCode ?? 0;
        if (code < 200 || code >= 300) {
          throw DioException(
            requestOptions: patch.requestOptions,
            response: patch,
            type: DioExceptionType.badResponse,
            error: 'Failed to update $safeTable row for $guid (HTTP $code)',
          );
        }
        final payload = patch.data;
        final updatedCount = payload is List ? payload.length : 0;
        if (updatedCount == 0) {
          // Some environments can return an empty representation for id-based updates.
          // Retry with a deterministic filter for the active season row.
          final fallbackPatch = await _dio.patch<dynamic>(
            '/$safeTable',
            queryParameters: <String, dynamic>{
              'vob_guid': 'eq.$guid',
              'year': 'eq.$year',
            },
            data: <String, dynamic>{
              'sort_order': row.sortOrder,
              'team': row.team,
              'can_be_challenged': row.canBeChallenged,
            },
            options: Options(headers: prefer),
          );
          final fallbackCode = fallbackPatch.statusCode ?? 0;
          if (fallbackCode < 200 || fallbackCode >= 300) {
            throw DioException(
              requestOptions: fallbackPatch.requestOptions,
              response: fallbackPatch,
              type: DioExceptionType.badResponse,
              error: 'Failed to update $safeTable row for $guid (HTTP $fallbackCode)',
            );
          }
          final fallbackPayload = fallbackPatch.data;
          final fallbackUpdatedCount = fallbackPayload is List ? fallbackPayload.length : 0;
          if (fallbackUpdatedCount == 0) {
            throw DioException(
              requestOptions: fallbackPatch.requestOptions,
              response: fallbackPatch,
              type: DioExceptionType.unknown,
              error:
                  'No ladder rows were updated for $guid (year $year). '
                  'This usually indicates missing admin RLS update policy.',
            );
          }
        }
      } else {
        final id = newUuidV4();
        final insert = await _dio.post<dynamic>(
          '/$safeTable',
          data: <String, dynamic>{
            'id': id,
            'sort_order': row.sortOrder,
            'year': year,
            'vob_guid': guid,
            'team': row.team,
            'can_be_challenged': row.canBeChallenged ?? false,
            'legacy_object_id': id,
          },
          options: Options(headers: prefer),
        );
        final code = insert.statusCode ?? 0;
        if (code < 200 || code >= 300) {
          throw DioException(
            requestOptions: insert.requestOptions,
            response: insert,
            type: DioExceptionType.badResponse,
            error: 'Failed to insert $safeTable row for $guid (HTTP $code)',
          );
        }
        final payload = insert.data;
        final insertedCount = payload is List ? payload.length : 0;
        if (insertedCount == 0) {
          throw DioException(
            requestOptions: insert.requestOptions,
            response: insert,
            type: DioExceptionType.unknown,
            error: 'No ladder rows were inserted for $guid. This usually indicates missing admin RLS insert policy.',
          );
        }
      }
      processed += 1;
    }

    if (processed == 0 && rows.isNotEmpty) {
      throw DioException(
        requestOptions: RequestOptions(path: '/$safeTable'),
        type: DioExceptionType.unknown,
        error: 'No ladder rows were processed. Check vob_guid values on ladder rows.',
      );
    }
  }

  @override
  Future<void> replaceLadderDivisionForYear({
    required String table,
    required int year,
    required List<LadderEntryUpsert> rows,
  }) async {
    final safeTable = table.trim();
    if (!_allowedTables.contains(safeTable)) {
      throw ArgumentError('Unsupported ladder table: $safeTable');
    }

    // Prefer SECURITY DEFINER RPC so ladder-table RLS cannot block purge+insert (403 on REST insert).
    final rpcBody = <String, dynamic>{
      'p_division': _rpcDivision(safeTable),
      'p_year': year,
      'p_rows': <Map<String, dynamic>>[
        for (final r in rows)
          if (r.vobGuid.trim().isNotEmpty)
            <String, dynamic>{
              'vob_guid': r.vobGuid.trim(),
              'sort_order': r.sortOrder,
              if (r.team != null) 'team': r.team,
              if (r.canBeChallenged != null) 'can_be_challenged': r.canBeChallenged,
            },
      ],
    };

    final rsp = await _dio.post<dynamic>('/rpc/admin_replace_ladder_division', data: rpcBody);
    final code = rsp.statusCode ?? 0;
    if (code < 200 || code >= 300) {
      final detail = _postgrestErrorMessage(rsp);
      throw DioException(
        requestOptions: rsp.requestOptions,
        response: rsp,
        type: DioExceptionType.badResponse,
        error: detail ??
            'admin_replace_ladder_division failed for $safeTable year $year (HTTP $code). '
            'Apply supabase/sql/ladders_admin_replace_rpc.sql in the Supabase SQL editor.',
      );
    }
  }

  @override
  Future<void> deleteLadderDivisionMember({
    required String table,
    required String vobGuid,
  }) async {
    final safeTable = table.trim();
    if (!_allowedTables.contains(safeTable)) {
      throw ArgumentError('Unsupported ladder table: $safeTable');
    }
    final guid = vobGuid.trim();
    if (guid.isEmpty) return;
    final year = DateTime.now().year;
    final response = await _dio.delete<dynamic>(
      '/$safeTable',
      queryParameters: <String, dynamic>{
        'vob_guid': 'eq.$guid',
        'year': 'eq.$year',
      },
      options: Options(headers: const <String, dynamic>{'Prefer': 'return=minimal'}),
    );
    final status = response.statusCode ?? 0;
    if (status < 200 || status >= 300) {
      throw DioException(
        requestOptions: response.requestOptions,
        response: response,
        type: DioExceptionType.badResponse,
        error: 'Failed to delete $safeTable row for $guid (HTTP $status)',
      );
    }
  }

  Future<List<LadderEntryWithProfileRow>> _getTable(String table) async {
    final response = await _dio.get(
      '/$table',
      queryParameters: const <String, dynamic>{
        'select': _selectWithProfile,
        'order': 'sort_order.asc',
      },
    );

    final status = response.statusCode ?? 0;
    if (status < 200 || status >= 300) {
      throw DioException(
        requestOptions: response.requestOptions,
        response: response,
        type: DioExceptionType.badResponse,
        error: 'Failed to load $table (HTTP $status)',
      );
    }

    final data = response.data;
    if (data is! List) {
      throw DioException(
        requestOptions: response.requestOptions,
        response: response,
        type: DioExceptionType.unknown,
        error: 'Unexpected $table payload: expected a JSON array',
      );
    }

    return data
        .whereType<Map<String, dynamic>>()
        .map(LadderEntryWithProfileRow.fromPostgrestJson)
        .toList(growable: false);
  }

  static const Set<String> _allowedTables = <String>{
    'ladder_mens',
    'ladder_ladies',
    'ladder_masters',
  };

  static String _rpcDivision(String safeTable) {
    switch (safeTable) {
      case 'ladder_mens':
        return 'men';
      case 'ladder_ladies':
        return 'ladies';
      case 'ladder_masters':
        return 'masters';
      default:
        throw ArgumentError('Unsupported ladder table: $safeTable');
    }
  }

  static String? _postgrestErrorMessage(Response<dynamic> response) {
    final data = response.data;
    if (data is Map<String, dynamic>) {
      final message = data['message'];
      if (message is String && message.trim().isNotEmpty) {
        final details = data['details'];
        if (details is String && details.trim().isNotEmpty) {
          return '$message ($details)';
        }
        return message;
      }
    }
    return null;
  }

  static String _normalizeGuidKey(String raw) =>
      raw.trim().toLowerCase().replaceAll('-', '');
}
