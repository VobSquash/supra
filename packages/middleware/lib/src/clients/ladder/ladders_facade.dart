import 'package:client_models/client_models.dart';
import 'package:client_supabase/client_supabase.dart';
import 'package:injectable/injectable.dart';
import 'package:middleware/src/clients/settings/i_settings_facade.dart';
import 'package:middleware/src/injection.dart';
import 'package:middleware/src/mappers/ladder/ladder_entry_with_profile.dart';
import 'package:middleware/src/mappers/ladder/ladder_team_breakdown_applier.dart';
import 'package:middleware/src/mappers/ladder/supabase_ladder_item_mapper.dart';
import 'package:middleware/src/mappers/profiles/supabase_profile_mapper.dart';
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

    final settings = await _settings.loadSettings();
    final show = settings.systemSettings.showLadderBreakdown;
    final breakdown = settings.ladderBreakdown;

    const itemMapper = SupabaseLadderItemMapper();
    const profileMapper = SupabaseProfileMapper();

    LadderItemDTO mapRow(LadderEntryWithProfileRow row) {
      final prof = row.profile != null
          ? profileMapper.convert<ProfileFull, BasicProfileDTO>(row.profile!)
          : null;
      return itemMapper.convert<LadderEntryWithProfile, LadderItemDTO>(
        LadderEntryWithProfile(entry: row.entry, profile: prof),
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

  @override
  Future<void> saveLadderDivision({
    required LadderDivision division,
    required List<LadderItemDTO> items,
  }) async {
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
    await _client.ladders.replaceLadderDivisionForYear(
      table: _tableForDivision(division),
      year: year,
      rows: rows,
    );
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
        LadderEntryUpsert(
          vobGuid: guid,
          sortOrder: sortOrder,
          team: team,
          canBeChallenged: canBeChallenged,
        ),
      ],
    );
  }

  @override
  Future<void> removeMemberFromDivision({
    required LadderDivision division,
    required String vobGuid,
  }) {
    return _client.ladders.deleteLadderDivisionMember(
      table: _tableForDivision(division),
      vobGuid: vobGuid,
    );
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
