import 'package:auto_mappr_annotation/auto_mappr_annotation.dart';
import 'package:client_models/client_models.dart';
import 'package:client_supabase/client_supabase.dart' show SupabaseConfig;

import 'app_config_mapper.auto_mappr.dart';

@AutoMappr([
  MapType<AppConfig, SupabaseConfig>(),
])
class AppConfigMapper extends $AppConfigMapper {
  const AppConfigMapper() : super();

  SupabaseConfig toSupabaseConfig(AppConfig input) =>
      convert<AppConfig, SupabaseConfig>(input);
}

