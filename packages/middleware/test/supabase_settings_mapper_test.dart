import 'package:client_models/client_models.dart';
import 'package:client_supabase/client_supabase.dart';
import 'package:middleware/src/mappers/settings/supabase_settings_mapper.dart';
import 'package:test/test.dart';

void main() {
  test('SupabaseSettingsMapper aggregates three enum keys', () {
    final rows = [
      SettingsRow(
        id: 'a',
        name: SettingsTypeEnum.currentLeagueTeamBreakdown.identifierType,
        value: '{"objectId":"x","LeagueTeams":[],"LeagueLadiesTeams":[],"LeagueMastersTeams":[]}',
      ),
      SettingsRow(
        id: 'b',
        name: SettingsTypeEnum.fees2026.identifierType,
        value: '[{"Cost":1.0,"ProRataCost":null,"FeeType":"t"}]',
      ),
      SettingsRow(
        id: 'c',
        name: SettingsTypeEnum.systemSettings.identifierType,
        value: '{"objectId":"s","showLadderBreakdown":true}',
      ),
    ];

    final dto = const SupabaseSettingsMapper().convert<List<SettingsRow>, SettingsDTO>(rows);

    expect(dto.fees.items.length, 1);
    expect(dto.fees.items.first.feeType, 't');
    expect(dto.systemSettings.showLadderBreakdown, true);
    expect(dto.fees.items.first.cost, 1.0);
  });
}
