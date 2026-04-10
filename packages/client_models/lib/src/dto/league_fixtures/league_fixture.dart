import 'package:freezed_annotation/freezed_annotation.dart';

import '../../enums/ladder_types.dart';
import '../club_captains/club_captain_dto.dart';

part 'league_fixture.freezed.dart';

@freezed
class LeagueFixtureDto with _$LeagueFixtureDto {
  const LeagueFixtureDto._();
  const factory LeagueFixtureDto({
    required String id,
    required String homeTeam,
    required String awayTeam,
    required DateTime fixtureDate,
    required String venue,
    required String status,
    required int leagueTeam,
    required LadderTypeEnum ladderType,
    required ClubCaptainDTO? clubCaptain,
  }) = _LeagueFixtureDto;

  factory LeagueFixtureDto.empty() => LeagueFixtureDto(
    id: '',
    homeTeam: '',
    awayTeam: '',
    fixtureDate: DateTime.now(),
    venue: '',
    status: '',
    leagueTeam: 0,
    ladderType: LadderTypeEnum.values[0],
    clubCaptain: null,
  );
}
