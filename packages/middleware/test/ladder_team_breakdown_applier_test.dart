import 'package:client_models/client_models.dart';
import 'package:middleware/src/mappers/ladder/ladder_team_breakdown_applier.dart';
import 'package:test/test.dart';

void main() {
  test('applyLadderTeamBreakdown sorts by order then assigns teams from breakdown', () {
    final items = [
      LadderItemDTO.empty().copyWith(order: 2, team: null),
      LadderItemDTO.empty().copyWith(order: 0, team: null),
      LadderItemDTO.empty().copyWith(order: 1, team: null),
    ];
    final teams = [
      const BreakdownItemDTO(teamMemberCount: 2, teamNumber: 1),
      const BreakdownItemDTO(teamMemberCount: 1, teamNumber: 2),
    ];

    final out = applyLadderTeamBreakdown(items: items, teams: teams);

    expect(out[0].order, 0);
    expect(out[0].team, 1);
    expect(out[1].order, 1);
    expect(out[1].team, 1);
    expect(out[2].order, 2);
    expect(out[2].team, 2);
  });

  test('applyLadderTeamBreakdown preserves stored team when breakdown list is null', () {
    final items = [
      LadderItemDTO.empty().copyWith(order: 1, team: 5),
    ];
    final out = applyLadderTeamBreakdown(items: items, teams: null);
    expect(out.single.team, 5);
  });
}
