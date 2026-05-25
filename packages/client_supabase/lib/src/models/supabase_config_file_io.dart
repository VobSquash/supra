import 'dart:convert';
import 'dart:io';

import 'supabase_config.dart';

Future<SupabaseConfig> loadSupabaseConfigFromFile(String filePath) async {
  final file = File(filePath);
  final json = jsonDecode(await file.readAsString()) as Map<String, dynamic>;
  return SupabaseConfig.fromJson(json);
}

SupabaseConfig loadSupabaseConfigFromFileSync(String filePath) {
  final file = File(filePath);
  final json = jsonDecode(file.readAsStringSync()) as Map<String, dynamic>;
  return SupabaseConfig.fromJson(json);
}
