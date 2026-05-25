part of 'settings_bloc.dart';

@freezed
class SettingsEvent with _$SettingsEvent {
  const factory SettingsEvent.onLoadSettings() = OnLoadSettings;

  const factory SettingsEvent.onResetSettings() = OnResetSettings;

  /// Persists ladder breakdown visibility; reloads aggregated [SettingsDTO] on success.
  const factory SettingsEvent.onSaveShowLadderBreakdown({required bool show}) = OnSaveShowLadderBreakdown;

  /// Persists ladder team roster counts and reloads settings on success.
  const factory SettingsEvent.onSaveLadderTeamBreakdown({required BreakdownTeamsDTO breakdown}) =
      OnSaveLadderTeamBreakdown;
}
