part of 'settings_bloc.dart';

@freezed
class SettingsState with _$SettingsState {
  const factory SettingsState({
    required SettingsDTO settings,
    required BaseLoading status,
  }) = _SettingsState;

  factory SettingsState.initial() => SettingsState(
        settings: SettingsDTO.empty(),
        status: BaseLoading.initial(),
      );
}
