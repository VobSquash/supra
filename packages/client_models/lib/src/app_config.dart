import 'package:json_annotation/json_annotation.dart';

part 'app_config.g.dart';

@JsonSerializable()
class AppConfig {
  const AppConfig({
    required this.back4AppClientId,
    required this.back4AppAppId,
    required this.back4AppBaseUrl,
    required this.back4AppMasterKey,
    required this.boxName,
    this.skinId,
    required this.supabaseUrl,
    required this.anonKey,
  });

  @JsonKey(name: 'back_4_app_client_id')
  final String back4AppClientId;

  @JsonKey(name: 'back_4_app_app_id')
  final String back4AppAppId;

  @JsonKey(name: 'back_4_app_base_url')
  final String back4AppBaseUrl;

  @JsonKey(name: 'back_4_app_master_key')
  final String back4AppMasterKey;

  @JsonKey(name: 'box_name')
  final String boxName;

  @JsonKey(name: 'skin_id')
  final String? skinId;

  @JsonKey(name: 'supabase_url')
  final String supabaseUrl;

  @JsonKey(name: 'anon_key')
  final String anonKey;

  factory AppConfig.fromJson(Map<String, dynamic> json) =>
      _$AppConfigFromJson(json);

  Map<String, dynamic> toJson() => _$AppConfigToJson(this);
}
