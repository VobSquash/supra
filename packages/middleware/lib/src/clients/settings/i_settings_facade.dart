import 'package:client_models/client_models.dart';

/// Facade for aggregated app settings (Supabase `settings` → [SettingsDTO]).
abstract class ISettingsFacade {
  Future<SettingsDTO> loadSettings();

  /// Persists `showLadderBreakdown` inside the `SystemSettings` row JSON `value`,
  /// preserving other keys when possible.
  Future<void> updateShowLadderBreakdown(bool show);

  /// Persists ladder team breakdown arrays on the ladder settings row (`LadderBreakdown2026`),
  /// merging onto the existing JSON payload.
  Future<void> updateLadderTeamBreakdown(BreakdownTeamsDTO breakdown);
}
