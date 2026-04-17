import 'package:meta/meta.dart';

/// Data persisted between app launches (non-secret fields + optional token handles).
///
/// **Prod:** Prefer [supabaseAccessToken] / [supabaseRefreshToken] from Supabase Auth;
/// `supabase_flutter` also persists sessions — this snapshot duplicates tokens for
/// app-level session UX and [SessionStore] if needed.
///
/// [legacyJwt] is for dev/tests only (HS256); do not use in production.
@immutable
class SessionSnapshot {
  const SessionSnapshot({
    this.email,
    this.displayName,
    this.vobGuid,
    this.profileTypeId,
    this.membershipTypeId,
    this.isCoach,
    this.isActive,
    this.legacyJwt,
    this.supabaseAccessToken,
    this.supabaseRefreshToken,
  });

  final String? email;
  final String? displayName;

  /// Canonical member id (e.g. profiles.vob_guid).
  final String? vobGuid;

  /// [ProfileTypeEnum.id] or equivalent.
  final int? profileTypeId;

  /// [MembershipTypeEnum.id] or equivalent.
  final int? membershipTypeId;

  final bool? isCoach;
  final bool? isActive;

  /// Dev/tests only — not used in prod (Supabase-only tokens).
  final String? legacyJwt;

  /// Supabase Auth access JWT (PostgREST `Authorization` + RLS).
  final String? supabaseAccessToken;

  /// Supabase Auth refresh token ([GoTrueClient.setSession]).
  final String? supabaseRefreshToken;

  bool get hasSupabaseSession =>
      supabaseRefreshToken != null && supabaseRefreshToken!.isNotEmpty;

  bool get isEmpty =>
      email == null &&
      displayName == null &&
      vobGuid == null &&
      profileTypeId == null &&
      membershipTypeId == null &&
      isCoach == null &&
      isActive == null &&
      (legacyJwt == null || legacyJwt!.isEmpty) &&
      (supabaseAccessToken == null || supabaseAccessToken!.isEmpty) &&
      (supabaseRefreshToken == null || supabaseRefreshToken!.isEmpty);

  SessionSnapshot copyWith({
    String? email,
    String? displayName,
    String? vobGuid,
    int? profileTypeId,
    int? membershipTypeId,
    bool? isCoach,
    bool? isActive,
    String? legacyJwt,
    String? supabaseAccessToken,
    String? supabaseRefreshToken,
    bool clearLegacyJwt = false,
    bool clearSupabaseTokens = false,
  }) {
    return SessionSnapshot(
      email: email ?? this.email,
      displayName: displayName ?? this.displayName,
      vobGuid: vobGuid ?? this.vobGuid,
      profileTypeId: profileTypeId ?? this.profileTypeId,
      membershipTypeId: membershipTypeId ?? this.membershipTypeId,
      isCoach: isCoach ?? this.isCoach,
      isActive: isActive ?? this.isActive,
      legacyJwt: clearLegacyJwt ? null : (legacyJwt ?? this.legacyJwt),
      supabaseAccessToken: clearSupabaseTokens
          ? null
          : (supabaseAccessToken ?? this.supabaseAccessToken),
      supabaseRefreshToken: clearSupabaseTokens
          ? null
          : (supabaseRefreshToken ?? this.supabaseRefreshToken),
    );
  }

  Map<String, Object?> toJson() => {
        'email': email,
        'displayName': displayName,
        'vobGuid': vobGuid,
        'profileTypeId': profileTypeId,
        'membershipTypeId': membershipTypeId,
        'isCoach': isCoach,
        'isActive': isActive,
        if (legacyJwt != null) 'legacyJwt': legacyJwt,
        if (supabaseAccessToken != null) 'supabaseAccessToken': supabaseAccessToken,
        if (supabaseRefreshToken != null) 'supabaseRefreshToken': supabaseRefreshToken,
      };

  factory SessionSnapshot.fromJson(Map<String, Object?> json) {
    return SessionSnapshot(
      email: json['email'] as String?,
      displayName: json['displayName'] as String?,
      vobGuid: json['vobGuid'] as String?,
      profileTypeId: (json['profileTypeId'] as num?)?.toInt(),
      membershipTypeId: (json['membershipTypeId'] as num?)?.toInt(),
      isCoach: json['isCoach'] as bool?,
      isActive: json['isActive'] as bool?,
      legacyJwt: json['legacyJwt'] as String?,
      supabaseAccessToken: json['supabaseAccessToken'] as String?,
      supabaseRefreshToken: json['supabaseRefreshToken'] as String?,
    );
  }
}
