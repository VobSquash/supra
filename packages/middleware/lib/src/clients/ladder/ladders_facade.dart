import 'package:client_models/client_models.dart';
import 'package:client_supabase/client_supabase.dart';
import 'package:injectable/injectable.dart';
import 'package:middleware/src/clients/settings/i_settings_facade.dart';
import 'package:middleware/src/injection.dart';
import 'package:middleware/src/mappers/ladder/ladder_challenge_targets_applier.dart';
import 'package:middleware/src/mappers/ladder/ladder_entry_with_profile.dart';
import 'package:middleware/src/mappers/ladder/ladder_team_breakdown_applier.dart';
import 'package:middleware/src/mappers/ladder/supabase_ladder_item_mapper.dart';
import 'package:middleware/src/mappers/profiles/supabase_profile_mapper.dart';
import 'package:session_storage/session_storage.dart';

import 'i_ladders_facade.dart';

@LazySingleton(as: ILaddersFacade)
class LaddersFacade implements ILaddersFacade {
  LaddersFacade();

  IClientSupabase get _client => middlewareSl<IClientSupabase>();
  ISettingsFacade get _settings => middlewareSl<ISettingsFacade>();

  @override
  Future<LaddersListDTO> loadLadders() async {
    final apiData = await Future.wait([
      _client.ladders.getLadderMens(),
      _client.ladders.getLadderLadies(),
      _client.ladders.getLadderMasters(),
      _settings.loadSettings(),
    ]);
    final mensRows = apiData[0] as List<LadderEntryWithProfileRow>;
    final ladiesRows = apiData[1] as List<LadderEntryWithProfileRow>;
    final mastersRows = apiData[2] as List<LadderEntryWithProfileRow>;
    final settings = apiData[3] as SettingsDTO;
    final show = settings.systemSettings.showLadderBreakdown;
    final breakdown = settings.ladderBreakdown;

    final session = await middlewareSl<SessionStore>().read();
    final viewerVobGuid = session?.vobGuid?.trim();

    const itemMapper = SupabaseLadderItemMapper();
    const profileMapper = SupabaseProfileMapper();

    LadderItemDTO mapRow(LadderEntryWithProfileRow row) {
      final prof = row.profile != null ? profileMapper.convert<ProfileFull, BasicProfileDTO>(row.profile!) : null;
      return itemMapper.convert<LadderEntryWithProfile, LadderItemDTO>(
        LadderEntryWithProfile(entry: row.entry, profile: prof),
      );
    }

    return LaddersListDTO(
      ladies: applyViewerChallengeTargets(
        items: applyLadderTeamBreakdown(
          items: ladiesRows.map(mapRow).toList(growable: false),
          teams: breakdown.ladiesTeams,
        ),
        showLadderBreakdown: show,
        viewerVobGuid: viewerVobGuid,
      ),
      men: applyViewerChallengeTargets(
        items: applyLadderTeamBreakdown(
          items: mensRows.map(mapRow).toList(growable: false),
          teams: breakdown.mensteams,
        ),
        showLadderBreakdown: show,
        viewerVobGuid: viewerVobGuid,
      ),
      masters: applyViewerChallengeTargets(
        items: applyLadderTeamBreakdown(
          items: mastersRows.map(mapRow).toList(growable: false),
          teams: breakdown.mastersTeams,
        ),
        showLadderBreakdown: show,
        viewerVobGuid: viewerVobGuid,
      ),
      showLadderBreakdown: show,
    );
  }

  @override
  Future<void> saveLadderDivision({required LadderDivision division, required List<LadderItemDTO> items}) async {
    final rows = <LadderEntryUpsert>[];
    for (var i = 0; i < items.length; i++) {
      final guid = items[i].vobGuid?.trim() ?? '';
      if (guid.isEmpty) continue;
      rows.add(
        LadderEntryUpsert(
          vobGuid: guid,
          sortOrder: i + 1,
          team: items[i].team,
          canBeChallenged: items[i].canBeChallenged,
        ),
      );
    }
    final year = DateTime.now().year;
    await _client.ladders.replaceLadderDivisionForYear(table: _tableForDivision(division), year: year, rows: rows);
  }

  @override
  Future<void> addMemberToDivision({
    required LadderDivision division,
    required String vobGuid,
    required int sortOrder,
    int? team,
    bool canBeChallenged = false,
  }) async {
    final guid = vobGuid.trim();
    if (guid.isEmpty) {
      throw ArgumentError('vobGuid must not be empty');
    }
    await _client.ladders.upsertLadderDivisionRows(
      table: _tableForDivision(division),
      rows: <LadderEntryUpsert>[
        LadderEntryUpsert(vobGuid: guid, sortOrder: sortOrder, team: team, canBeChallenged: canBeChallenged),
      ],
    );
  }

  @override
  Future<void> removeMemberFromDivision({required LadderDivision division, required String vobGuid}) {
    return _client.ladders.deleteLadderDivisionMember(table: _tableForDivision(division), vobGuid: vobGuid);
  }

  String _tableForDivision(LadderDivision division) {
    switch (division) {
      case LadderDivision.men:
        return 'ladder_mens';
      case LadderDivision.ladies:
        return 'ladder_ladies';
      case LadderDivision.masters:
        return 'ladder_masters';
    }
  }
}
