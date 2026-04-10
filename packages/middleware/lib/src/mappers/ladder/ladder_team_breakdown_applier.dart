import 'package:client_models/client_models.dart';

/// Assigns [LadderItemDTO.team] from league breakdown settings, in ladder order.
///
/// Mirrors `LadderListMapper` in `packages/examples/ladder/ladder_list_mapper.dart`:
/// sort by [LadderItemDTO.order], then for each [BreakdownItemDTO] in order,
/// set `team` to [BreakdownItemDTO.teamNumber] for the next [teamMemberCount] players.
///
/// When [teams] is null, returns items sorted by order only (teams from storage/row unchanged).
List<LadderItemDTO> applyLadderTeamBreakdown({
  required List<LadderItemDTO> items,
  required List<BreakdownItemDTO>? teams,
}) {
  final sorted = [...items]..sort((a, b) => (a.order ?? 0).compareTo(b.order ?? 0));
  if (teams == null) return sorted;

  var index = 0;
  final out = List<LadderItemDTO>.from(sorted);
  for (final team in teams) {
    final count = team.teamMemberCount ?? 0;
    final number = team.teamNumber ?? 0;
    for (var i = 0; i < count && index < out.length; i++) {
      out[index] = out[index].copyWith(team: number);
      index++;
    }
  }
  return out;
}
