import 'package:freezed_annotation/freezed_annotation.dart';

part 'system_settings.freezed.dart';
part 'system_settings.g.dart';

@freezed
class SystemSettingsDTO with _$SystemSettingsDTO {
  const SystemSettingsDTO._();
  const factory SystemSettingsDTO({
    required String objectId,
    required bool showLadderBreakdown,
  }) = _SystemSettingsDTO;

  factory SystemSettingsDTO.empty() => const SystemSettingsDTO(
        objectId: '',
        showLadderBreakdown: false,
      );
  factory SystemSettingsDTO.fromJson(Map<String, dynamic> json) =>
      _$SystemSettingsDTOFromJson(json);
}
