import 'dart:convert';
import 'dart:io';

import 'package:json_annotation/json_annotation.dart';

part 'supabase_config.g.dart';

/// Connection settings for Supabase (REST / PostgREST via DIO).
///
/// Load from JSON with [fromJson], or from a file with [fromJsonFile] /
/// [fromJsonFileSync]. Typical keys: `supabase_url`, `anon_key`.
@JsonSerializable()
class SupabaseConfig {
  const SupabaseConfig({
    required this.supabaseUrl,
    required this.anonKey,
  });

  /// Project URL, e.g. `https://xyzcompany.supabase.co` (no trailing slash required).
  @JsonKey(name: 'supabase_url')
  final String supabaseUrl;

  /// Supabase anonymous (or other) API key used for `apikey` and `Authorization`.
  @JsonKey(name: 'anon_key')
  final String anonKey;

  factory SupabaseConfig.fromJson(Map<String, dynamic> json) =>
      _$SupabaseConfigFromJson(json);

  Map<String, dynamic> toJson() => _$SupabaseConfigToJson(this);

  /// Reads and parses a JSON config file (async; for VM / CLI / Flutter IO).
  static Future<SupabaseConfig> fromJsonFile(String filePath) async {
    final file = File(filePath);
    final json =
        jsonDecode(await file.readAsString()) as Map<String, dynamic>;
    return SupabaseConfig.fromJson(json);
  }

  /// Same as [fromJsonFile] but synchronous.
  static SupabaseConfig fromJsonFileSync(String filePath) {
    final file = File(filePath);
    final json =
        jsonDecode(file.readAsStringSync()) as Map<String, dynamic>;
    return SupabaseConfig.fromJson(json);
  }
}
