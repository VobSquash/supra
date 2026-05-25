import '../models/settings_row.dart';

/// Key-value `settings` rows (aggregated into [SettingsDTO] in middleware).
abstract class IClientSupabaseSettings {
  Future<List<SettingsRow>> getSettings();

  /// Updates the `value` column for the row whose `name` equals [settingName].
  ///
  /// Uses PostgREST `PATCH /settings?name=eq.{settingName}`.
  Future<void> patchSettingValueWhereNameEq({
    required String settingName,
    required String value,
  });

  /// PATCH by row `id`; uses `Prefer: return=representation` and fails if zero rows updated.
  Future<void> patchSettingValueWhereIdEq({
    required String id,
    required String value,
  });
}
