import 'package:session_storage/session_storage.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Maps Supabase Auth [Session] + [User] into [SessionSnapshot].
///
/// Expects optional `user_metadata` keys: `vob_guid`, `display_name`, `profile_type_id`,
/// `membership_type_id`, `is_coach`, `is_active` — adjust when you sync auth.users.
SessionSnapshot sessionSnapshotFromSupabase({
  required Session session,
  required User user,
}) {
  final userMeta = user.userMetadata ?? {};
  final appMeta = user.appMetadata;
  final identityMeta = _identityMetadata(user);
  final displayName = _resolveDisplayName(identityMeta, userMeta, appMeta);

  return SessionSnapshot(
    email: user.email,
    displayName: displayName,
    vobGuid: _stringFromSources(identityMeta, userMeta, appMeta, 'vob_guid', 'vobGuid'),
    profileTypeId: _intFromEither(
      identityMeta,
      userMeta,
      appMeta,
      'profile_type_id',
      'profileTypeId',
      fallbackKeys: const ['profile_type', 'profileType'],
    ),
    membershipTypeId: _intFromEither(
      identityMeta,
      userMeta,
      appMeta,
      'membership_type_id',
      'membershipTypeId',
      fallbackKeys: const ['membership_type', 'membershipType'],
    ),
    isCoach: _boolFromEither(identityMeta, userMeta, appMeta, 'is_coach', 'isCoach'),
    isActive: _boolFromEither(identityMeta, userMeta, appMeta, 'is_active', 'isActive'),
    supabaseAccessToken: session.accessToken,
    supabaseRefreshToken: session.refreshToken,
  );
}

String? _resolveDisplayName(
  Map<String, dynamic> identityMeta,
  Map<String, dynamic> userMeta,
  Map<String, dynamic> appMeta,
) {
  final explicit = _stringFromSources(
    identityMeta,
    userMeta,
    appMeta,
    'display_name',
    'displayName',
    fallbackKeys: const ['full_name', 'fullName', 'name'],
  );
  if (explicit != null && explicit.trim().isNotEmpty) {
    return explicit.trim();
  }

  final firstName = _stringFromSources(
    identityMeta,
    userMeta,
    appMeta,
    'first_name',
    'firstName',
    fallbackKeys: const ['given_name', 'givenName'],
  );
  final lastName = _stringFromSources(
    identityMeta,
    userMeta,
    appMeta,
    'last_name',
    'lastName',
    fallbackKeys: const ['family_name', 'familyName', 'surname'],
  );
  final full = [if (firstName != null) firstName.trim(), if (lastName != null) lastName.trim()]
      .where((v) => v.isNotEmpty)
      .join(' ');
  return full.isEmpty ? null : full;
}

Map<String, dynamic> _identityMetadata(User user) {
  final identities = user.identities;
  if (identities == null || identities.isEmpty) return const <String, dynamic>{};
  for (final identity in identities) {
    final data = identity.identityData;
    if (data is Map<String, dynamic> && data.isNotEmpty) {
      return data;
    }
  }
  return const <String, dynamic>{};
}

String? _stringFromSources(
  Map<String, dynamic> first,
  Map<String, dynamic> second,
  Map<String, dynamic> third,
  String a,
  String b, {
  List<String> fallbackKeys = const [],
}) {
  final candidates = <Object?>[
    first[a],
    first[b],
    second[a],
    second[b],
    third[a],
    third[b],
    for (final key in fallbackKeys) first[key],
    for (final key in fallbackKeys) second[key],
    for (final key in fallbackKeys) third[key],
  ];
  for (final candidate in candidates) {
    if (candidate == null) continue;
    final value = candidate.toString();
    if (value.trim().isNotEmpty) return value;
  }
  return null;
}

int? _intFromEither(
  Map<String, dynamic> first,
  Map<String, dynamic> second,
  Map<String, dynamic> third,
  String a,
  String b, {
  List<String> fallbackKeys = const [],
}) {
  return _int(first, a, b, fallbackKeys: fallbackKeys) ??
      _int(second, a, b, fallbackKeys: fallbackKeys) ??
      _int(third, a, b, fallbackKeys: fallbackKeys);
}

bool? _boolFromEither(
  Map<String, dynamic> first,
  Map<String, dynamic> second,
  Map<String, dynamic> third,
  String a,
  String b,
) {
  return _bool(first, a, b) ?? _bool(second, a, b) ?? _bool(third, a, b);
}

int? _int(
  Map<String, dynamic> m,
  String a,
  String b, {
  List<String> fallbackKeys = const [],
}) {
  final candidates = <Object?>[m[a], m[b], for (final key in fallbackKeys) m[key]];
  Object? v;
  for (final candidate in candidates) {
    if (candidate != null) {
      v = candidate;
      break;
    }
  }
  if (v == null) return null;
  if (v is int) return v;
  if (v is num) return v.toInt();
  if (v is String) {
    final asInt = int.tryParse(v);
    if (asInt != null) return asInt;
    if (fallbackKeys.isNotEmpty) {
      final profileType = _stringToProfileTypeId(v);
      if (profileType != null) return profileType;
      final membershipType = _stringToMembershipTypeId(v);
      if (membershipType != null) return membershipType;
    }
  }
  return int.tryParse(v.toString());
}

bool? _bool(Map<String, dynamic> m, String a, String b) {
  final v = m[a] ?? m[b];
  if (v == null) return null;
  if (v is bool) return v;
  if (v is String) {
    if (v.toLowerCase() == 'true') return true;
    if (v.toLowerCase() == 'false') return false;
  }
  return null;
}

int? _stringToProfileTypeId(String raw) {
  switch (raw.trim().toLowerCase()) {
    case 'user':
    case 'member':
      return 1;
    case 'administrator':
    case 'admin':
    case 'super_admin':
    case 'superadmin':
      return 2;
    case 'elivated':
    case 'elevated':
      return 3;
    default:
      return null;
  }
}

int? _stringToMembershipTypeId(String raw) {
  switch (raw.trim().toLowerCase()) {
    case 'leaguemen':
      return 1;
    case 'leagueandmasters':
      return 2;
    case 'leaguestudent':
      return 3;
    case 'leaguescholar':
      return 4;
    case 'mastersonly':
      return 5;
    case 'social':
      return 6;
    case 'socialstudent':
      return 7;
    case 'socialscholar':
      return 8;
    case 'ladiesleague':
      return 9;
    default:
      return null;
  }
}
