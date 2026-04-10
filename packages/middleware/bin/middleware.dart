import 'dart:convert';
import 'dart:io';

import 'package:client_models/client_models.dart';
import 'package:middleware/middleware.dart';

Future<void> main(List<String> args) async {
  final configPath = args.isNotEmpty ? args.first : 'app_config.json';
  final json = jsonDecode(await File(configPath).readAsString()) as Map<String, dynamic>;
  final appConfig = AppConfig.fromJson(json);

  registerMiddleware(appConfig);

  // Example: show that downstream configs are derived from AppConfig.
  final supabase = middlewareSl<ClientConfigs>().supabaseConfig;
  stdout.writeln('Supabase URL: ${supabase.supabaseUrl}');
}
