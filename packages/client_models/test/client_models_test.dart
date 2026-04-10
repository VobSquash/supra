import 'package:client_models/client_models.dart';
import 'package:test/test.dart';

void main() {
  test('calculate', () {
    // Placeholder to keep the package test harness.
    expect(AppConfig.fromJson(const {
      'back_4_app_client_id': 'x',
      'back_4_app_app_id': 'y',
      'back_4_app_base_url': 'https://example.com',
      'back_4_app_master_key': 'z',
      'box_name': 'box',
      'supabase_url': 'https://supabase.example.com',
      'anon_key': 'anon',
    }).supabaseUrl, 'https://supabase.example.com');
  });
}
