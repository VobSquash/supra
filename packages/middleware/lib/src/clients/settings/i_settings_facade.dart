import 'package:client_models/client_models.dart';

/// Facade for aggregated app settings (Supabase `settings` → [SettingsDTO]).
abstract class ISettingsFacade {
  Future<SettingsDTO> loadSettings();
}
