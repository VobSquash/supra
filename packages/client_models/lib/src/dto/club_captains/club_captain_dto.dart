import 'package:freezed_annotation/freezed_annotation.dart';

import '../../enums/ladder_types.dart';

part 'club_captain_dto.freezed.dart';

@freezed
class ClubCaptainDTO with _$ClubCaptainDTO {
  const ClubCaptainDTO._();
  const factory ClubCaptainDTO({
    required String? captainName,
    required String? captainContactNo,
    required bool? isCatering,
    required int? leagueTeam,
    required String? clubLocationFk,
    required LadderTypeEnum? ladderType,
  }) = _ClubCaptainDTO;

  factory ClubCaptainDTO.empty() => ClubCaptainDTO(
        captainName: null,
        captainContactNo: null,
        isCatering: null,
        leagueTeam: null,
        clubLocationFk: null,
        ladderType: null,
      );
}
