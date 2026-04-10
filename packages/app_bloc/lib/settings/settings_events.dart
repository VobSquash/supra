part of 'settings_bloc.dart';

@freezed
class SettingsEvent with _$SettingsEvent {
  const factory SettingsEvent.onLoadSettings() = OnLoadSettings;

  const factory SettingsEvent.onResetSettings() = OnResetSettings;
}
