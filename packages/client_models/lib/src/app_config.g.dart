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
  smtpHost: json['smtp_host'] as String?,
  smtpUsername: json['smtp_username'] as String?,
  smtpPassword: json['smtp_password'] as String?,
  smtpFromEmail: json['smtp_from_email'] as String?,
  smtpFromName: json['smtp_from_name'] as String?,
  smtpUseSsl: json['smtp_use_ssl'] as bool?,
  smtpBookingCc: json['smtp_booking_cc'],
  smtpWelcomeCc: json['smtp_welcome_cc'],
  emailAssetBaseUrl: json['email_asset_base_url'] as String?,
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
  'smtp_host': instance.smtpHost,
  'smtp_username': instance.smtpUsername,
  'smtp_password': instance.smtpPassword,
  'smtp_from_email': instance.smtpFromEmail,
  'smtp_from_name': instance.smtpFromName,
  'smtp_use_ssl': instance.smtpUseSsl,
  'smtp_booking_cc': instance.smtpBookingCc,
  'smtp_welcome_cc': instance.smtpWelcomeCc,
  'email_asset_base_url': instance.emailAssetBaseUrl,
};
