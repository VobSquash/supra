import 'package:json_annotation/json_annotation.dart';

part 'supabase_config.g.dart';

/// Connection settings for Supabase (REST / PostgREST via DIO).
///
/// Load from JSON with [fromJson]. On VM / Flutter (dart:io) platforms use
/// [loadSupabaseConfigFromFile] / [loadSupabaseConfigFromFileSync] from
/// `supabase_config_file.dart` (exported with this library). Typical keys:
/// `supabase_url`, `anon_key`.
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
}
