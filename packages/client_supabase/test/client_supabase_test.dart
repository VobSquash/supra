import 'dart:io';

import 'package:client_supabase/client_supabase.dart';
import 'package:path/path.dart' as p;
import 'package:test/test.dart';

void main() {
  test('SupabaseConfig round-trips JSON', () {
    final config = SupabaseConfig(
      supabaseUrl: 'https://abc.supabase.co',
      anonKey: 'test-key',
    );
    final json = config.toJson();
    final restored = SupabaseConfig.fromJson(json);
    expect(restored.supabaseUrl, config.supabaseUrl);
    expect(restored.anonKey, config.anonKey);
  });

  test('SupabaseConfig.fromJsonFile reads file', () async {
    final dir = Directory.systemTemp.createTempSync('client_supabase_test');
    addTearDown(() => dir.deleteSync(recursive: true));
    final file = File(p.join(dir.path, 'supabase.json'));
    await file.writeAsString(
      '{"supabase_url":"https://x.supabase.co","anon_key":"k"}',
    );
    final config = await SupabaseConfig.fromJsonFile(file.path);
    expect(config.supabaseUrl, 'https://x.supabase.co');
    expect(config.anonKey, 'k');
  });

  test('ClientSupabase registers Dio with rest/v1 base URL', () {
    final config = SupabaseConfig(
      supabaseUrl: 'https://proj.supabase.co/',
      anonKey: 'anon',
    );
    final client = ClientSupabase(config: config);
    expect(client.dio.options.baseUrl, 'https://proj.supabase.co/rest/v1');
    expect(client.dio.options.headers['apikey'], 'anon');
  });

  test('ProfileRow and ProfileExtensionRow round-trip Supabase-style JSON', () {
    final ext = ProfileExtensionRow(
      id: 'ext-1',
      vobGuid: 'guid-ext',
      ssaNumber: 'ssa',
      emergencyContactNumber: '000',
      firebaseNumber: 'fb',
      membershipType: 'gold',
      canShowBirthday: true,
      canShowEmail: false,
      canShowContact: true,
      isCoach: false,
    );
    final extJson = ext.toJson();
    expect(ProfileExtensionRow.fromJson(extJson).id, ext.id);

    final profile = ProfileRow(
      id: 'p1',
      vobGuid: 'guid-p',
      firstName: 'A',
      lastName: 'B',
      email: 'a@b.c',
      contactNumber: '1',
      password: null,
      profileType: 'user',
      isActive: true,
      dateOfBirth: '1990-01-01',
      dateCreated: '2020-01-01T00:00:00Z',
      passwordHashed: true,
      profileExtensionId: 'ext-1',
    );
    final pJson = profile.toJson();
    final restored = ProfileRow.fromJson(pJson);
    expect(restored.profileExtensionId, profile.profileExtensionId);
    expect(pJson['first_name'], 'A');
    expect(pJson['profile_extension_id'], 'ext-1');
  });

  test('LocationRow round-trips Supabase-style JSON', () {
    final loc = LocationRow(
      id: 'a0000000-0000-4000-8000-000000000001',
      vobGuid: '11111111-1111-1111-1111-111111111101',
      name: 'Auckland CBD',
      latitude: '-36.8485',
      longitude: '174.7633',
      lookup: 'akl-cbd',
    );
    final json = loc.toJson();
    final restored = LocationRow.fromJson(json);
    expect(restored.id, loc.id);
    expect(restored.lookup, loc.lookup);
    expect(json['vob_guid'], loc.vobGuid);
  });

  test('SettingsRow round-trips Supabase-style JSON', () {
    final s = SettingsRow(
      id: 'b0000000-0000-4000-8000-000000000001',
      name: 'SystemSettings',
      value: '{"objectId":"x","showLadderBreakdown":true}',
      legacyObjectId: 'parseObj1',
    );
    final json = s.toJson();
    final restored = SettingsRow.fromJson(json);
    expect(restored.name, 'SystemSettings');
    expect(restored.legacyObjectId, 'parseObj1');
    expect(json['legacy_object_id'], 'parseObj1');
  });

  test('LadderEntryWithProfileRow parses PostgREST embed', () {
    final json = <String, dynamic>{
      'id': 'c0000000-0000-4000-8000-000000000001',
      'sort_order': 1,
      'year': 2026,
      'vob_guid': '11111111-1111-1111-1111-111111111101',
      'team': 2,
      'can_be_challenged': true,
      'legacy_object_id': 'parseL1',
      'profiles': <String, dynamic>{
        'id': 'p1',
        'vob_guid': '11111111-1111-1111-1111-111111111101',
        'first_name': 'A',
        'last_name': 'B',
        'email': 'a@b.c',
        'contact_number': '1',
        'profile_type': 'user',
        'is_active': true,
        'date_of_birth': '1990-01-01',
        'date_created': '2020-01-01T00:00:00Z',
        'password_hashed': true,
        'profile_extension_id': 'ext-1',
        'profile_extensions': <String, dynamic>{
          'id': 'ext-1',
          'vob_guid': '11111111-1111-1111-1111-111111111101',
          'ssa_number': 'ssa',
          'emergency_contact_number': '000',
          'firebase_number': 'fb',
          'membership_type': 'gold',
          'can_show_birthday': true,
          'can_show_email': false,
          'can_show_contact': true,
          'is_coach': false,
        },
      },
    };
    final wrapped = LadderEntryWithProfileRow.fromPostgrestJson(json);
    expect(wrapped.entry.sortOrder, 1);
    expect(wrapped.profile?.profile.vobGuid, '11111111-1111-1111-1111-111111111101');
    expect(wrapped.profile?.profile.firstName, 'A');
    expect(wrapped.profile?.extension?.ssaNumber, 'ssa');
  });

  test('LadderEntryRow round-trips Supabase-style JSON', () {
    final row = LadderEntryRow(
      id: 'c0000000-0000-4000-8000-000000000001',
      sortOrder: 1,
      year: 2026,
      vobGuid: '11111111-1111-1111-1111-111111111101',
      team: 2,
      canBeChallenged: true,
      legacyObjectId: 'parseL1',
    );
    final json = row.toJson();
    final restored = LadderEntryRow.fromJson(json);
    expect(restored.sortOrder, 1);
    expect(json.containsKey('ladder_type'), false);
  });
}
