import 'dart:typed_data';

import 'package:client_models/client_models.dart';
import 'package:client_supabase/client_supabase.dart';
import 'package:injectable/injectable.dart';
import 'package:middleware/src/injection.dart';
import 'package:middleware/src/mappers/ladder/member_ladder_membership_mapper.dart';
import 'package:middleware/src/mappers/profiles/supabase_profile_mapper.dart';
import 'package:session_storage/session_storage.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'i_users_facade.dart';

@LazySingleton(as: IUsersFacade)
class UsersFacade implements IUsersFacade {
  UsersFacade(this._sessionStore);

  static const _avatarsBucket = 'avatars';

  final SessionStore _sessionStore;

  IClientSupabase get _client => middlewareSl<IClientSupabase>();

  BasicProfileDTO _toBasic(ProfileFull full) {
    return const SupabaseProfileMapper().convert<ProfileFull, BasicProfileDTO>(full);
  }

  @override
  Future<List<BasicProfileDTO>> loadBasicProfiles() async {
    final rows = await _client.profiles.getProfiles();
    final list = rows.map(_toBasic).toList(growable: false);
    list.sort((a, b) => a.displayName.compareTo(b.displayName));
    return list;
  }

  @override
  Future<List<BasicProfileDTO>> loadActiveBasicProfiles() async {
    final rows = await _client.profiles.getProfiles();
    final active = rows.where((r) => r.profile.isActive == true);
    final list = active.map(_toBasic).toList(growable: false);
    list.sort((a, b) => a.displayName.compareTo(b.displayName));
    return list;
  }

  @override
  Future<BasicProfileDTO?> loadProfileByVobGuid(String vobGuid) async {
    final full = await _client.profiles.getByVobGuid(vobGuid);
    if (full == null) return null;
    return _toBasic(full);
  }

  @override
  Future<List<MemberLadderMembershipWithProfileDTO>> loadMemberLadderMembership(String vobGuid) async {
    final rows = await _client.ladders.getMemberLadderMembershipWithProfile(vobGuid);
    return rows.map(mapMemberLadderMembershipWithProfileRow).toList(growable: false);
  }

  @override
  Future<BasicProfileDTO> createMemberProfileAsAdmin({required CreateMemberProfileDto dto}) async {
    final session = await _sessionStore.read();
    final pt = ProfileTypeEnum.get(session?.profileTypeId ?? -1);
    if (!pt.isAdminOrElevated) {
      throw StateError('Only administrators or elevated users can add member profiles.');
    }

    final full = await _client.profiles.createMemberProfile(dto: dto);
    return _toBasic(full);
  }

  Future<ProfileFull?> _profileFullForCurrentAuthUser() async {
    final uid = Supabase.instance.client.auth.currentUser?.id.trim();
    if (uid == null || uid.isEmpty) return null;
    var full = await _client.profiles.getByAuthUserId(uid);
    if (full == null) {
      final email = Supabase.instance.client.auth.currentUser?.email?.trim().toLowerCase();
      if (email != null && email.isNotEmpty) {
        full = await _client.profiles.getByEmail(email);
      }
    }
    return full;
  }

  @override
  Future<BasicProfileDTO?> loadCurrentUserProfile() async {
    final full = await _profileFullForCurrentAuthUser();
    if (full == null) return null;
    return _toBasic(full);
  }

  @override
  Future<BasicProfileDTO> updateOwnProfile({required UpdateOwnProfileDto dto}) async {
    final full = await _profileFullForCurrentAuthUser();
    if (full == null) {
      throw StateError('Could not load your profile.');
    }
    final patched = await _client.profiles.patchMemberProfileFields(
      profileRowId: full.profile.id,
      vobGuid: full.profile.vobGuid,
      extensionId: full.extension?.id ?? full.profile.profileExtensionId,
      dto: dto,
    );
    return _toBasic(patched);
  }

  String _avatarExtensionForContentType(String contentType) {
    final lower = contentType.toLowerCase();
    if (lower.contains('png')) return 'png';
    if (lower.contains('webp')) return 'webp';
    return 'jpg';
  }

  @override
  Future<BasicProfileDTO> uploadOwnProfilePicture({
    required Uint8List bytes,
    required String contentType,
  }) async {
    final full = await _profileFullForCurrentAuthUser();
    if (full == null) {
      throw StateError('Could not load your profile.');
    }
    final uid = Supabase.instance.client.auth.currentUser?.id.trim();
    if (uid == null || uid.isEmpty) {
      throw StateError('Not signed in.');
    }
    final ext = _avatarExtensionForContentType(contentType);
    final path = '$uid/avatar.$ext';
    await Supabase.instance.client.storage.from(_avatarsBucket).uploadBinary(
          path,
          bytes,
          fileOptions: FileOptions(
            contentType: contentType,
            upsert: true,
          ),
        );
    final publicUrl = Supabase.instance.client.storage.from(_avatarsBucket).getPublicUrl(path);
    final patched = await _client.profiles.patchOwnProfilePictureUrl(
      profileRowId: full.profile.id,
      vobGuid: full.profile.vobGuid,
      publicUrl: publicUrl,
      updatedAt: DateTime.now().toUtc(),
    );
    return _toBasic(patched);
  }

  @override
  Future<BasicProfileDTO> updateMemberProfileAsAdmin({
    required String profileRowId,
    required String? vobGuid,
    String? extensionId,
    required UpdateAdminProfileDto dto,
  }) async {
    final session = await _sessionStore.read();
    final pt = ProfileTypeEnum.get(session?.profileTypeId ?? -1);
    if (!pt.isAdminOrElevated) {
      throw StateError('Only administrators or elevated users can update member profiles.');
    }

    final patched = await _client.profiles.patchProfileAdminFields(
      profileRowId: profileRowId,
      vobGuid: vobGuid,
      extensionId: extensionId,
      dto: dto,
    );
    return _toBasic(patched);
  }
}
