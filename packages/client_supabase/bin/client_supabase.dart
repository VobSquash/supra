import 'dart:io';

import 'package:client_supabase/client_supabase.dart';

/// Demo: load JSON config and print resolved REST base URL.
///
/// Usage: `dart run client_supabase -- path/to/supabase.json`
void main(List<String> arguments) async {
  if (arguments.isEmpty) {
    stderr.writeln('Usage: dart run client_supabase -- <path-to-config.json>');
    exitCode = 64;
    return;
  }
  final path = arguments.first;
  final config = await SupabaseConfig.fromJsonFile(path);
  final client = ClientSupabase(config: config);
  stdout.writeln('REST base URL: ${client.dio.options.baseUrl}');
}
