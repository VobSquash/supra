import 'package:client_models/client_models.dart';
import 'package:dio/dio.dart';

import '../interfaces/i_client_supabase_profiles.dart';
import '../models/profile_full.dart';
import '../models/supabase_config.dart';
import 'postgrest_uuid.dart';

class ClientSupabaseProfiles implements IClientSupabaseProfiles {
  ClientSupabaseProfiles({required SupabaseConfig config, required Dio dio}) : _dio = dio;

  // Intentionally keep `config` in the constructor signature for future
  // expansion (e.g. schema selection, key switching), even if unused today.
  final Dio _dio;

  @override
  Future<List<ProfileFull>> getProfiles() async {
    final response = await _dio.get(
      '/profiles',
      queryParameters: const <String, dynamic>{'select': '*,profile_extensions(*)', 'order': 'email.asc'},
    );

    final status = response.statusCode ?? 0;
    if (status < 200 || status >= 300) {
      throw DioException(
        requestOptions: response.requestOptions,
        response: response,
        type: DioExceptionType.badResponse,
        error: 'Failed to load profiles (HTTP $status)',
      );
    }

    final data = response.data;
    if (data is! List) {
      throw DioException(
        requestOptions: response.requestOptions,
        response: response,
        type: DioExceptionType.unknown,
        error: 'Unexpected profiles payload: expected a JSON array',
      );
    }

    return data.whereType<Map<String, dynamic>>().map(ProfileFull.fromPostgrestJson).toList(growable: false);
  }

  @override
  Future<ProfileFull?> getByVobGuid(String vobGuid) async {
    final normalized = _normalizeUuidLike(vobGuid);
    final candidates = <String>{vobGuid.trim(), ?normalized}.where((s) => s.isNotEmpty).toList(growable: false);

    for (final candidate in candidates) {
      final response = await _dio.get(
        '/profiles',
        queryParameters: <String, dynamic>{
          'select': '*,profile_extensions(*)',
          'vob_guid': 'eq.$candidate',
          'limit': 1,
        },
      );

      final status = response.statusCode ?? 0;
      if (status < 200 || status >= 300) {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          type: DioExceptionType.badResponse,
          error: 'Failed to load profile by vob_guid (HTTP $status)',
        );
      }

      final data = response.data;
      if (data is! List) {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          type: DioExceptionType.unknown,
          error: 'Unexpected profile payload: expected a JSON array',
        );
      }

      if (data.isEmpty) {
        continue;
      }

      final row = data.first;
      if (row is! Map<String, dynamic>) {
        continue;
      }

      return ProfileFull.fromPostgrestJson(row);
    }

    return null;
  }

  @override
  Future<ProfileFull?> getByAuthUserId(String authUserId) async {
    final normalized = authUserId.trim();
    if (normalized.isEmpty) return null;
    return _getSingleByFilter('id', 'eq.$normalized');
  }

  @override
  Future<ProfileFull?> getByEmail(String email) async {
    final normalized = email.trim().toLowerCase();
    if (normalized.isEmpty) return null;
    return _getSingleByFilter('email', 'eq.$normalized');
  }

  Future<ProfileFull?> _getSingleByFilter(String field, String filter) async {
    final response = await _dio.get(
      '/profiles',
      queryParameters: <String, dynamic>{
        'select': '*,profile_extensions(*)',
        field: filter,
        'limit': 1,
      },
    );

    final status = response.statusCode ?? 0;
    if (status < 200 || status >= 300) {
      throw DioException(
        requestOptions: response.requestOptions,
        response: response,
        type: DioExceptionType.badResponse,
        error: 'Failed to load profile by $field (HTTP $status)',
      );
    }

    final data = response.data;
    if (data is! List) {
      throw DioException(
        requestOptions: response.requestOptions,
        response: response,
        type: DioExceptionType.unknown,
        error: 'Unexpected profile payload: expected a JSON array',
      );
    }

    if (data.isEmpty) return null;
    final row = data.first;
    if (row is! Map<String, dynamic>) return null;
    return ProfileFull.fromPostgrestJson(row);
  }

  @override
  Future<ProfileFull> createMemberProfile({required CreateMemberProfileDto dto}) async {
    final email = dto.email.trim().toLowerCase();
    if (email.isEmpty) {
      throw ArgumentError('email must not be empty');
    }
    final first = dto.firstName.trim();
    final last = dto.lastName.trim();
    if (first.isEmpty || last.isEmpty) {
      throw ArgumentError('firstName and lastName must not be empty');
    }
    if (dto.membershipType == MembershipTypeEnum.unknown) {
      throw ArgumentError('membershipType must not be unknown');
    }

    final profileId = newUuidV4();
    final vobGuid = newUuidV4();
    final extensionId = newUuidV4();

    final dob = DateTime(dto.dateOfBirth.year, dto.dateOfBirth.month, dto.dateOfBirth.day);
    final dobStr =
        '${dob.year.toString().padLeft(4, '0')}-${dob.month.toString().padLeft(2, '0')}-${dob.day.toString().padLeft(2, '0')}';

    final prefer = <String, dynamic>{'Prefer': 'return=representation'};

    final profileRes = await _dio.post<dynamic>(
      '/profiles',
      data: <String, dynamic>{
        'id': profileId,
        'vob_guid': vobGuid,
        'first_name': first,
        'last_name': last,
        'email': email,
        'contact_number': dto.contactNumber.trim(),
        'password': 'unset',
        'profile_type': 'user',
        'is_active': true,
        'date_of_birth': dobStr,
        'password_hashed': false,
      },
      options: Options(headers: prefer),
    );

    final pStatus = profileRes.statusCode ?? 0;
    if (pStatus < 200 || pStatus >= 300) {
      final msg = _httpFailDetail(profileRes, 'Failed to create profile');
      throw DioException(
        requestOptions: profileRes.requestOptions,
        response: profileRes,
        type: DioExceptionType.badResponse,
        error: msg,
      );
    }

    final extRes = await _dio.post<dynamic>(
      '/profile_extensions',
      data: <String, dynamic>{
        'id': extensionId,
        'vob_guid': vobGuid,
        'emergency_contact_number': dto.emergencyContactNumber.trim(),
        'membership_type': dto.membershipType.identifierType,
        'is_coach': false,
        'can_show_email': true,
        'can_show_contact': true,
        'can_show_birthday': false,
        'ssa_number': null,
        'firebase_number': null,
      },
      options: Options(headers: prefer),
    );

    final eStatus = extRes.statusCode ?? 0;
    if (eStatus < 200 || eStatus >= 300) {
      final msg = _httpFailDetail(extRes, 'Profile row created but extension insert failed');
      throw DioException(
        requestOptions: extRes.requestOptions,
        response: extRes,
        type: DioExceptionType.badResponse,
        error: msg,
      );
    }

    final patchRes = await _dio.patch<dynamic>(
      '/profiles',
      queryParameters: <String, dynamic>{'id': 'eq.$profileId'},
      data: <String, dynamic>{'profile_extension_id': extensionId},
      options: Options(headers: prefer),
    );

    final patchStatus = patchRes.statusCode ?? 0;
    if (patchStatus < 200 || patchStatus >= 300) {
      final msg = _httpFailDetail(
        patchRes,
        'Profile and extension created but could not link profile_extension_id',
      );
      throw DioException(
        requestOptions: patchRes.requestOptions,
        response: patchRes,
        type: DioExceptionType.badResponse,
        error: msg,
      );
    }

    final full = await getByVobGuid(vobGuid);
    if (full == null) {
      throw DioException(
        requestOptions: profileRes.requestOptions,
        response: profileRes,
        type: DioExceptionType.unknown,
        error: 'Profile created but could not reload row for vob_guid $vobGuid',
      );
    }
    return full;
  }

  @override
  Future<ProfileFull> patchMemberProfileFields({
    required String profileRowId,
    required String? vobGuid,
    String? extensionId,
    required UpdateOwnProfileDto dto,
  }) async {
    final first = dto.firstName.trim();
    final last = dto.lastName.trim();
    if (first.isEmpty || last.isEmpty) {
      throw ArgumentError('firstName and lastName must not be empty');
    }

    final dob = DateTime(dto.dateOfBirth.year, dto.dateOfBirth.month, dto.dateOfBirth.day);
    final dobStr =
        '${dob.year.toString().padLeft(4, '0')}-${dob.month.toString().padLeft(2, '0')}-${dob.day.toString().padLeft(2, '0')}';

    final prefer = <String, dynamic>{'Prefer': 'return=minimal'};

    final profilePatch = await _dio.patch<dynamic>(
      '/profiles',
      queryParameters: <String, dynamic>{'id': 'eq.$profileRowId'},
      data: <String, dynamic>{
        'first_name': first,
        'last_name': last,
        'contact_number': dto.contactNumber.trim(),
        'date_of_birth': dobStr,
      },
      options: Options(headers: prefer),
    );

    final pStatus = profilePatch.statusCode ?? 0;
    if (pStatus < 200 || pStatus >= 300) {
      final msg = _httpFailDetail(profilePatch, 'Failed to update profile');
      throw DioException(
        requestOptions: profilePatch.requestOptions,
        response: profilePatch,
        type: DioExceptionType.badResponse,
        error: msg,
      );
    }

    final ext = extensionId?.trim();
    if (ext != null && ext.isNotEmpty) {
      final ssa = dto.ssaNumber.trim();
      final extRes = await _dio.patch<dynamic>(
        '/profile_extensions',
        queryParameters: <String, dynamic>{'id': 'eq.$ext'},
        data: <String, dynamic>{
          'emergency_contact_number': dto.emergencyContactNumber.trim(),
          'can_show_email': dto.canShowEmail,
          'can_show_contact': dto.canShowContactNumber,
          'can_show_birthday': dto.canShowDateOfBirth,
          'ssa_number': ssa.isEmpty ? null : ssa,
        },
        options: Options(headers: prefer),
      );
      final eStatus = extRes.statusCode ?? 0;
      if (eStatus < 200 || eStatus >= 300) {
        final msg = _httpFailDetail(extRes, 'Failed to update profile extension');
        throw DioException(
          requestOptions: extRes.requestOptions,
          response: extRes,
          type: DioExceptionType.badResponse,
          error: msg,
        );
      }
    }

    final guid = vobGuid?.trim();
    if (guid != null && guid.isNotEmpty) {
      final reloaded = await getByVobGuid(guid);
      if (reloaded != null) return reloaded;
    }
    final byId = await getByAuthUserId(profileRowId.trim());
    if (byId != null) return byId;
    throw DioException(
      requestOptions: profilePatch.requestOptions,
      response: profilePatch,
      type: DioExceptionType.unknown,
      error: 'Profile updated but could not reload row',
    );
  }

  @override
  Future<ProfileFull> patchOwnProfilePictureUrl({
    required String profileRowId,
    required String? vobGuid,
    String? publicUrl,
    DateTime? updatedAt,
  }) async {
    final prefer = <String, dynamic>{'Prefer': 'return=minimal'};
    final trimmedUrl = publicUrl?.trim();
    final Map<String, dynamic> data;
    if (trimmedUrl == null || trimmedUrl.isEmpty) {
      data = <String, dynamic>{
        'profile_picture_url': null,
        'profile_picture_updated_at': null,
      };
    } else {
      final ts = (updatedAt ?? DateTime.now()).toUtc();
      data = <String, dynamic>{
        'profile_picture_url': trimmedUrl,
        'profile_picture_updated_at': ts.toIso8601String(),
      };
    }

    final profilePatch = await _dio.patch<dynamic>(
      '/profiles',
      queryParameters: <String, dynamic>{'id': 'eq.${profileRowId.trim()}'},
      data: data,
      options: Options(headers: prefer),
    );

    final pStatus = profilePatch.statusCode ?? 0;
    if (pStatus < 200 || pStatus >= 300) {
      final msg = _httpFailDetail(profilePatch, 'Failed to update profile picture');
      throw DioException(
        requestOptions: profilePatch.requestOptions,
        response: profilePatch,
        type: DioExceptionType.badResponse,
        error: msg,
      );
    }

    final guid = vobGuid?.trim();
    if (guid != null && guid.isNotEmpty) {
      final reloaded = await getByVobGuid(guid);
      if (reloaded != null) return reloaded;
    }
    final byId = await getByAuthUserId(profileRowId.trim());
    if (byId != null) return byId;
    throw DioException(
      requestOptions: profilePatch.requestOptions,
      response: profilePatch,
      type: DioExceptionType.unknown,
      error: 'Profile picture updated but could not reload row',
    );
  }

  @override
  Future<ProfileFull> patchProfileAdminFields({
    required String profileRowId,
    required String? vobGuid,
    String? extensionId,
    required UpdateAdminProfileDto dto,
  }) async {
    final email = dto.email.trim().toLowerCase();
    if (email.isEmpty) {
      throw ArgumentError('email must not be empty');
    }
    final first = dto.firstName.trim();
    final last = dto.lastName.trim();
    if (first.isEmpty || last.isEmpty) {
      throw ArgumentError('firstName and lastName must not be empty');
    }

    final dob = DateTime(dto.dateOfBirth.year, dto.dateOfBirth.month, dto.dateOfBirth.day);
    final dobStr =
        '${dob.year.toString().padLeft(4, '0')}-${dob.month.toString().padLeft(2, '0')}-${dob.day.toString().padLeft(2, '0')}';

    final prefer = <String, dynamic>{'Prefer': 'return=minimal'};

    final profilePatch = await _dio.patch<dynamic>(
      '/profiles',
      queryParameters: <String, dynamic>{'id': 'eq.$profileRowId'},
      data: <String, dynamic>{
        'email': email,
        'is_active': dto.isActive,
        'first_name': first,
        'last_name': last,
        'contact_number': dto.contactNumber.trim(),
        'date_of_birth': dobStr,
      },
      options: Options(headers: prefer),
    );

    final pStatus = profilePatch.statusCode ?? 0;
    if (pStatus < 200 || pStatus >= 300) {
      final msg = _httpFailDetail(profilePatch, 'Failed to update profile (admin)');
      throw DioException(
        requestOptions: profilePatch.requestOptions,
        response: profilePatch,
        type: DioExceptionType.badResponse,
        error: msg,
      );
    }

    final ext = extensionId?.trim();
    if (ext != null && ext.isNotEmpty) {
      final ssa = dto.ssaNumber.trim();
      final extRes = await _dio.patch<dynamic>(
        '/profile_extensions',
        queryParameters: <String, dynamic>{'id': 'eq.$ext'},
        data: <String, dynamic>{
          'emergency_contact_number': dto.emergencyContactNumber.trim(),
          'can_show_email': dto.canShowEmail,
          'can_show_contact': dto.canShowContactNumber,
          'can_show_birthday': dto.canShowDateOfBirth,
          'ssa_number': ssa.isEmpty ? null : ssa,
        },
        options: Options(headers: prefer),
      );
      final eStatus = extRes.statusCode ?? 0;
      if (eStatus < 200 || eStatus >= 300) {
        final msg = _httpFailDetail(extRes, 'Failed to update profile extension (admin)');
        throw DioException(
          requestOptions: extRes.requestOptions,
          response: extRes,
          type: DioExceptionType.badResponse,
          error: msg,
        );
      }
    }

    final guid = vobGuid?.trim();
    if (guid != null && guid.isNotEmpty) {
      final reloaded = await getByVobGuid(guid);
      if (reloaded != null) return reloaded;
    }
    final byEmail = await getByEmail(email);
    if (byEmail != null) return byEmail;
    final byId = await getByAuthUserId(profileRowId.trim());
    if (byId != null) return byId;
    throw DioException(
      requestOptions: profilePatch.requestOptions,
      response: profilePatch,
      type: DioExceptionType.unknown,
      error: 'Profile updated but could not reload row',
    );
  }
}

String _httpFailDetail(Response<dynamic> response, String fallback) {
  final code = response.statusCode ?? 0;
  final pg = _postgrestErrorText(response.data);
  if (pg != null) return 'HTTP $code: $pg';
  final raw = response.data;
  if (raw != null && raw.toString().isNotEmpty) {
    return 'HTTP $code: $raw';
  }
  return 'HTTP $code: $fallback';
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

String? _normalizeUuidLike(String input) {
  final trimmed = input.trim().toLowerCase();
  if (trimmed.isEmpty) return null;

  // Already UUID-ish: accept.
  final uuidRegex = RegExp(r'^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$');
  if (uuidRegex.hasMatch(trimmed)) return trimmed;

  // Handle legacy normalized form: 32 hex chars (no hyphens).
  final hex32 = RegExp(r'^[0-9a-f]{32}$');
  if (!hex32.hasMatch(trimmed)) return null;

  return '${trimmed.substring(0, 8)}-'
      '${trimmed.substring(8, 12)}-'
      '${trimmed.substring(12, 16)}-'
      '${trimmed.substring(16, 20)}-'
      '${trimmed.substring(20)}';
}
