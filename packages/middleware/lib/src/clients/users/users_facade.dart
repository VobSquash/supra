import 'package:client_models/client_models.dart';
import 'package:client_supabase/client_supabase.dart';
import 'package:injectable/injectable.dart';
import 'package:middleware/src/injection.dart';
import 'package:middleware/src/mappers/ladder/member_ladder_membership_mapper.dart';
import 'package:middleware/src/mappers/profiles/supabase_profile_mapper.dart';
import 'package:session_storage/session_storage.dart';

import 'i_users_facade.dart';

@LazySingleton(as: IUsersFacade)
class UsersFacade implements IUsersFacade {
  UsersFacade(this._sessionStore);

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
}
