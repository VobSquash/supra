import 'dart:convert';

import 'package:app_bloc/app_bloc.dart';
import 'package:client_models/client_models.dart';
import 'package:flutter/services.dart';
import 'package:middleware/middleware.dart';

Future<void> bootstrap() async {
  final appConfig = await _loadAppConfigFromAsset();

  // Order matters (see packages/app_bloc/lib/injection.dart).
  registerMiddleware(appConfig);
  registerAppBlocDependencies();
}

Future<AppConfig> _loadAppConfigFromAsset() async {
  final raw = await rootBundle.loadString('app_config.json');
  final json = jsonDecode(raw) as Map<String, dynamic>;
  return AppConfig.fromJson(json);
}
