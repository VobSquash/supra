import 'package:client_models/client_models.dart';
import 'package:client_supabase/client_supabase.dart';
import 'package:injectable/injectable.dart';
import 'package:middleware/src/injection.dart';
import 'package:middleware/src/mappers/settings/supabase_settings_mapper.dart';

import 'i_settings_facade.dart';

@LazySingleton(as: ISettingsFacade)
class SettingsFacade implements ISettingsFacade {
  SettingsFacade();

  IClientSupabase get _client => middlewareSl<IClientSupabase>();

  @override
  Future<SettingsDTO> loadSettings() async {
    final rows = await _client.settings.getSettings();
    return const SupabaseSettingsMapper().convert<List<SettingsRow>, SettingsDTO>(rows);
  }
}
