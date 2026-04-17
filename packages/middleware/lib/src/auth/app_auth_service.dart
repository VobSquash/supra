import 'package:auth/auth.dart';
import 'package:client_supabase/client_supabase.dart';
import 'package:injectable/injectable.dart';
import 'package:session_storage/session_storage.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'supabase_session_mapper.dart';

/// Orchestrates [AuthRepository] and [SessionStore] for sign-in, restore, and logout.
///
/// **Sign-in:** [AuthRepository.validateCredentials] → [AuthRepository.obtainSessionToken]
/// (Supabase session snapshot) → [SessionStore.write].
///
/// **Sign-out:** Supabase global sign-out + clear [SessionStore].
@LazySingleton(as: AuthService)
class AppAuthService implements AuthService {
  AppAuthService(
    this._repository,
    this._sessionStore,
    this._clientSupabase,
  );

  final AuthRepository _repository;
  final SessionStore _sessionStore;
  final IClientSupabase _clientSupabase;

  @override
  Future<AuthResult> restoreFromStoredToken(String refreshToken) async {
    final result = await _repository.validateSessionToken(refreshToken);
    if (result.success && result.session != null) {
      await _sessionStore.write(result.session!);
    }
    return result;
  }

  @override
  Future<SessionSnapshot?> tryRestoreActiveSession() async {
    // `Supabase.initialize` starts `recoverSession()` without awaiting it; poll briefly so
    // cold start sees persisted GoTrue session.
    Session? session = Supabase.instance.client.auth.currentSession;
    User? user = Supabase.instance.client.auth.currentUser;
    for (var i = 0; i < 20 && session == null; i++) {
      await Future<void>.delayed(const Duration(milliseconds: 25));
      session = Supabase.instance.client.auth.currentSession;
      user = Supabase.instance.client.auth.currentUser;
    }
    if (session == null || user == null) return null;
    final baseSnapshot = sessionSnapshotFromSupabase(session: session, user: user);
    final snapshot = await _enrichFromProfiles(baseSnapshot, user);
    // Access token is always present on a real session; refresh token can be absent in edge cases.
    if (snapshot.supabaseAccessToken == null || snapshot.supabaseAccessToken!.isEmpty) {
      return null;
    }
    await _sessionStore.write(snapshot);
    return snapshot;
  }

  @override
  Future<void> signOut() async {
    await Supabase.instance.client.auth.signOut();
    await _sessionStore.clear();
  }

  @override
  Future<AuthResult> signIn({
    required String email,
    required String encodedPassword,
  }) async {
    final check = await _repository.validateCredentials(
      email: email,
      encodedPassword: encodedPassword,
    );
    if (!check.success) return check;

    final tokenResult = await _repository.obtainSessionToken(email: email);
    if (!tokenResult.success) return tokenResult;

    final session = tokenResult.session;
    if (session == null ||
        session.supabaseAccessToken == null ||
        session.supabaseAccessToken!.isEmpty) {
      return const AuthResult.failure('No Supabase session after sign-in');
    }

    final currentUser = Supabase.instance.client.auth.currentUser;
    final enriched = await _enrichFromProfiles(session, currentUser);
    await _sessionStore.write(enriched);
    return AuthResult.signedIn(enriched);
  }

  Future<SessionSnapshot> _enrichFromProfiles(
    SessionSnapshot base,
    User? user,
  ) async {
    ProfileFull? full;
    try {
      final userId = user?.id.trim();
      if (userId != null && userId.isNotEmpty) {
        full = await _clientSupabase.profiles.getByAuthUserId(userId);
      }

      if (full == null) {
        final email = user?.email?.trim();
        if (email != null && email.isNotEmpty) {
          full = await _clientSupabase.profiles.getByEmail(email);
        }
      }

      if (full == null) {
        final guid = base.vobGuid?.trim();
        if (guid != null && guid.isNotEmpty) {
          full = await _clientSupabase.profiles.getByVobGuid(guid);
        }
      }
    } catch (_) {
      // Best-effort enrichment; keep auth flow resilient.
      return base;
    }

    if (full == null) return base;

    final first = full.profile.firstName?.trim();
    final last = full.profile.lastName?.trim();
    final nameFromProfile = [if (first != null && first.isNotEmpty) first, if (last != null && last.isNotEmpty) last]
        .join(' ')
        .trim();

    return base.copyWith(
      email: full.profile.email ?? base.email,
      displayName: nameFromProfile.isNotEmpty ? nameFromProfile : base.displayName,
      vobGuid: full.profile.vobGuid ?? base.vobGuid,
      profileTypeId: _profileTypeToId(full.profile.profileType) ?? base.profileTypeId,
      membershipTypeId:
          _membershipTypeToId(full.extension?.membershipType) ?? base.membershipTypeId,
      isCoach: full.extension?.isCoach ?? base.isCoach,
      isActive: full.profile.isActive ?? base.isActive,
    );
  }
}

int? _profileTypeToId(String? raw) {
  if (raw == null) return null;
  switch (raw.trim().toLowerCase()) {
    case 'user':
      return 1;
    case 'administrator':
      return 2;
    case 'elivated':
    case 'elevated':
      return 3;
    default:
      return null;
  }
}

int? _membershipTypeToId(String? raw) {
  if (raw == null) return null;
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
