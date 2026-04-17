import 'dart:convert';

import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:auth/auth.dart';
import 'package:session_storage/session_storage.dart';

/// Matches legacy `TokenService` / `TokenData.create` field names (`ProfileId`, `Email`, …).

/// Maps decoded `VobData` JSON (object or stringified JSON) to [SessionSnapshot].
SessionSnapshot mapVobDataToSessionSnapshot(
  Object? vobData, {
  required String legacyJwt,
}) {
  final map = _asMap(vobData);
  return SessionSnapshot(
    email: _string(map, 'Email', 'email'),
    displayName: _string(map, 'DisplayName', 'displayName'),
    vobGuid: _readProfileId(map),
    profileTypeId: _int(map, 'ProfileType', 'profileType'),
    membershipTypeId: _int(map, 'MembershipType', 'membershipType'),
    isCoach: _bool(map, 'IsCoach', 'isCoach'),
    isActive: _bool(map, 'IsActive', 'isActive'),
    legacyJwt: legacyJwt,
  );
}

Map<String, dynamic> _asMap(Object? vobData) {
  if (vobData == null) return {};
  if (vobData is Map<String, dynamic>) return vobData;
  if (vobData is String) {
    final decoded = jsonDecode(vobData);
    if (decoded is Map<String, dynamic>) return decoded;
  }
  return {};
}

String? _readProfileId(Map<String, dynamic> map) {
  final v = map['ProfileId'] ?? map['profileId'];
  if (v == null) return null;
  return v.toString();
}

String? _string(Map<String, dynamic> map, String a, String b) {
  final v = map[a] ?? map[b];
  if (v == null) return null;
  return v.toString();
}

int? _int(Map<String, dynamic> map, String a, String b) {
  final v = map[a] ?? map[b];
  if (v == null) return null;
  if (v is int) return v;
  if (v is num) return v.toInt();
  return int.tryParse(v.toString());
}

bool? _bool(Map<String, dynamic> map, String a, String b) {
  final v = map[a] ?? map[b];
  if (v == null) return null;
  if (v is bool) return v;
  return null;
}

/// Verifies HS256 JWT and builds [AuthResult] with [SessionSnapshot] from `VobData`.
AuthResult verifyLegacyJwtAndMapToSession(
  String token,
  String secret,
) {
  try {
    final jwt = JWT.verify(token, SecretKey(secret));
    final payload = jwt.payload;
    if (payload is! Map<String, dynamic>) {
      return const AuthResult.failure('Invalid JWT payload shape');
    }
    final raw = payload['VobData'];
    if (raw == null) {
      return const AuthResult.failure('JWT missing VobData');
    }
    final snapshot = mapVobDataToSessionSnapshot(
      raw is String ? jsonDecode(raw) : raw,
      legacyJwt: token,
    );
    return AuthResult.signedIn(snapshot);
  } on JWTExpiredException {
    return const AuthResult.failure('JWT expired');
  } on JWTException catch (e) {
    return AuthResult.failure(e.message);
  } catch (e) {
    return AuthResult.failure('JWT validation failed: $e');
  }
}
