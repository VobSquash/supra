import 'package:client_models/client_models.dart';
import 'package:client_supabase/client_supabase.dart';
import 'package:injectable/injectable.dart';
import 'package:middleware/src/injection.dart';
import 'package:middleware/src/mappers/profiles/supabase_profile_mapper.dart';

import 'i_users_facade.dart';

@LazySingleton(as: IUsersFacade)
class UsersFacade implements IUsersFacade {
  UsersFacade();

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
}
