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
    this.smtpHost,
    this.smtpUsername,
    this.smtpPassword,
    this.smtpFromEmail,
    this.smtpFromName,
    this.smtpUseSsl,
    this.smtpBookingCc,
    this.smtpWelcomeCc,
    this.emailAssetBaseUrl,
    this.bannerEventsBaseUrl,
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

  @JsonKey(name: 'smtp_host')
  final String? smtpHost;

  @JsonKey(name: 'smtp_username')
  final String? smtpUsername;

  @JsonKey(name: 'smtp_password')
  final String? smtpPassword;

  @JsonKey(name: 'smtp_from_email')
  final String? smtpFromEmail;

  @JsonKey(name: 'smtp_from_name')
  final String? smtpFromName;

  @JsonKey(name: 'smtp_use_ssl')
  final bool? smtpUseSsl;

  @JsonKey(name: 'smtp_booking_cc')
  final dynamic smtpBookingCc;

  @JsonKey(name: 'smtp_welcome_cc')
  final dynamic smtpWelcomeCc;

  /// Public base URL for HTML email images, e.g.
  /// `https://<project>.supabase.co/storage/v1/object/public/email-images/`.
  @JsonKey(name: 'email_asset_base_url')
  final String? emailAssetBaseUrl;

  /// Public base URL for event banner images, e.g.
  /// `https://<project>.supabase.co/storage/v1/object/public/banner_events/`.
  @JsonKey(name: 'banner_events_base_url')
  final String? bannerEventsBaseUrl;

  factory AppConfig.fromJson(Map<String, dynamic> json) =>
      _$AppConfigFromJson(json);

  Map<String, dynamic> toJson() => _$AppConfigToJson(this);
}
