// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'supabase_config.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SupabaseConfig _$SupabaseConfigFromJson(Map<String, dynamic> json) =>
    SupabaseConfig(
      supabaseUrl: json['supabase_url'] as String,
      anonKey: json['anon_key'] as String,
    );

Map<String, dynamic> _$SupabaseConfigToJson(SupabaseConfig instance) =>
    <String, dynamic>{
      'supabase_url': instance.supabaseUrl,
      'anon_key': instance.anonKey,
    };
