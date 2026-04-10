import '../models/settings_row.dart';

/// Key-value `settings` rows (aggregated into [SettingsDTO] in middleware).
abstract class IClientSupabaseSettings {
  Future<List<SettingsRow>> getSettings();
}
