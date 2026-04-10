// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_config.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AppConfig _$AppConfigFromJson(Map<String, dynamic> json) => AppConfig(
  back4AppClientId: json['back_4_app_client_id'] as String,
  back4AppAppId: json['back_4_app_app_id'] as String,
  back4AppBaseUrl: json['back_4_app_base_url'] as String,
  back4AppMasterKey: json['back_4_app_master_key'] as String,
  boxName: json['box_name'] as String,
  skinId: json['skin_id'] as String?,
  supabaseUrl: json['supabase_url'] as String,
  anonKey: json['anon_key'] as String,
);

Map<String, dynamic> _$AppConfigToJson(AppConfig instance) => <String, dynamic>{
  'back_4_app_client_id': instance.back4AppClientId,
  'back_4_app_app_id': instance.back4AppAppId,
  'back_4_app_base_url': instance.back4AppBaseUrl,
  'back_4_app_master_key': instance.back4AppMasterKey,
  'box_name': instance.boxName,
  'skin_id': instance.skinId,
  'supabase_url': instance.supabaseUrl,
  'anon_key': instance.anonKey,
};
