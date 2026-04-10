import 'package:client_models/client_models.dart';
import 'package:client_supabase/client_supabase.dart';
import 'package:injectable/injectable.dart';
import 'package:middleware/src/clients/settings/i_settings_facade.dart';
import 'package:middleware/src/injection.dart';
import 'package:middleware/src/mappers/ladder/ladder_entry_with_profile.dart';
import 'package:middleware/src/mappers/ladder/ladder_team_breakdown_applier.dart';
import 'package:middleware/src/mappers/ladder/supabase_ladder_item_mapper.dart';
import 'package:middleware/src/mappers/profiles/supabase_profile_mapper.dart';
import 'package:middleware/src/utils/vob_guid_normalize.dart';

import 'i_ladders_facade.dart';

@LazySingleton(as: ILaddersFacade)
class LaddersFacade implements ILaddersFacade {
  LaddersFacade();

  IClientSupabase get _client => middlewareSl<IClientSupabase>();
  ISettingsFacade get _settings => middlewareSl<ISettingsFacade>();

  @override
  Future<LaddersListDTO> loadLadders() async {
    final ladderLists = await Future.wait([
      _client.ladders.getLadderMens(),
      _client.ladders.getLadderLadies(),
      _client.ladders.getLadderMasters(),
    ]);
    final mensRows = ladderLists[0];
    final ladiesRows = ladderLists[1];
    final mastersRows = ladderLists[2];
    final profileRows = await _client.profiles.getProfiles();

    final byNormalizedVob = <String, BasicProfileDTO>{};
    for (final p in profileRows) {
      final basic = const SupabaseProfileMapper().convert<ProfileFull, BasicProfileDTO>(p);
      final key = normalizeVobGuid(basic.vobGuid);
      if (key != null && key.isNotEmpty) {
        byNormalizedVob[key] = basic;
      }
    }

    final settings = await _settings.loadSettings();
    final show = settings.systemSettings.showLadderBreakdown;
    final breakdown = settings.ladderBreakdown;

    const itemMapper = SupabaseLadderItemMapper();

    LadderItemDTO mapRow(LadderEntryRow e) {
      final v = normalizeVobGuid(e.vobGuid);
      final prof = v != null ? byNormalizedVob[v] : null;
      return itemMapper.convert<LadderEntryWithProfile, LadderItemDTO>(
        LadderEntryWithProfile(entry: e, profile: prof),
      );
    }

    return LaddersListDTO(
      ladies: applyLadderTeamBreakdown(
        items: ladiesRows.map(mapRow).toList(growable: false),
        teams: breakdown.ladiesTeams,
      ),
      men: applyLadderTeamBreakdown(
        items: mensRows.map(mapRow).toList(growable: false),
        teams: breakdown.mensteams,
      ),
      masters: applyLadderTeamBreakdown(
        items: mastersRows.map(mapRow).toList(growable: false),
        teams: breakdown.mastersTeams,
      ),
      showLadderBreakdown: show,
    );
  }
}
