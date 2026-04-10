import 'package:client_models/src/dto/export_dto.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'settings.freezed.dart';

@freezed
class SettingsDTO with _$SettingsDTO {
  const SettingsDTO._();
  const factory SettingsDTO({
    required BreakdownTeamsDTO ladderBreakdown,
    required SystemSettingsDTO systemSettings,
    required FeesDTO fees,
  }) = _SettingsDTO;

  factory SettingsDTO.empty() => SettingsDTO(
    ladderBreakdown: BreakdownTeamsDTO.empty(),
    systemSettings: SystemSettingsDTO.empty(),
    fees: FeesDTO.empty(),
  );
}
