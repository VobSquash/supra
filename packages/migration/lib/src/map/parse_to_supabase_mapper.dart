import 'package:uuid/uuid.dart';

import '../models/merged_parse_profile.dart';

const _uuid = Uuid();

/// RFC 4122 DNS namespace — used as the v5 namespace for deterministic ids.
const _v5NamespaceDns = '6ba7b810-9dad-11d1-80b4-00c04fd430c8';

/// Deterministic UUIDs so re-running migration targets the same rows.
String extensionIdForVobGuid(String vobGuid) =>
    _uuid.v5(_v5NamespaceDns, 'supra:profile_extensions:$vobGuid');

String profileIdForVobGuid(String vobGuid) =>
    _uuid.v5(_v5NamespaceDns, 'supra:profiles:$vobGuid');

String locationIdForVobGuid(String vobGuid) =>
    _uuid.v5(_v5NamespaceDns, 'supra:locations:$vobGuid');

String settingsIdForName(String name) =>
    _uuid.v5(_v5NamespaceDns, 'supra:settings:${name.trim()}');

String ladderEntryIdFor(String ladderType, String parseObjectId) =>
    _uuid.v5(_v5NamespaceDns, 'supra:ladder_entry:$ladderType:$parseObjectId');

String leagueCaptainIdFor(String parseObjectId) =>
    _uuid.v5(_v5NamespaceDns, 'supra:league_captains:$parseObjectId');

String leagueFixtureIdFor(String parseObjectId) =>
    _uuid.v5(_v5NamespaceDns, 'supra:league_fixtures:$parseObjectId');

String bookingIdFor(String parseObjectId) =>
    _uuid.v5(_v5NamespaceDns, 'supra:bookings:$parseObjectId');

/// Normalizes legacy 32-char hex GUID to hyphenated lowercase UUID when possible.
String? normalizeVobGuid(String? raw) {
  if (raw == null) return null;
  final trimmed = raw.trim();
  if (trimmed.isEmpty) return null;

  final lower = trimmed.toLowerCase();
  final uuidRegex = RegExp(
    r'^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$',
  );
  if (uuidRegex.hasMatch(lower)) return lower;

  final hex32 = RegExp(r'^[0-9a-f]{32}$');
  if (!hex32.hasMatch(lower)) {
    return null;
  }

  return '${lower.substring(0, 8)}-'
      '${lower.substring(8, 12)}-'
      '${lower.substring(12, 16)}-'
      '${lower.substring(16, 20)}-'
      '${lower.substring(20)}';
}

String? _str(dynamic v) {
  if (v == null) return null;
  if (v is String) return v;
  return v.toString();
}

/// True if [v] is a canonical 8-4-4-4-12 lowercase hex UUID.
bool isCanonicalUuid(String v) {
  return RegExp(
    r'^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$',
  ).hasMatch(v.toLowerCase());
}

bool? _bool(dynamic v) {
  if (v == null) return null;
  if (v is bool) return v;
  return null;
}

int? _int(dynamic v) {
  if (v == null) return null;
  if (v is int) return v;
  if (v is num) return v.toInt();
  return null;
}

/// Maps merged Parse rows to PostgREST JSON for `profile_extensions` then `profiles`.
({Map<String, dynamic> ext, Map<String, dynamic> prof}) mapToSupabasePayloads(
  MergedParseProfile merged,
) {
  final p = merged.profile;
  final e = merged.extension;

  final rawGuid = _str(p['Id']);
  final vobGuid = normalizeVobGuid(rawGuid);
  if (vobGuid == null || vobGuid.isEmpty || !isCanonicalUuid(vobGuid)) {
    throw StateError(
      'Invalid or missing Parse Id (vob_guid): raw=$rawGuid objectId=${p['objectId']}',
    );
  }

  final extId = extensionIdForVobGuid(vobGuid);
  final profId = profileIdForVobGuid(vobGuid);

  final membership = e['MembershipType'];
  final membershipStr = membership == null ? null : _str(membership);

  final extensionJson = <String, dynamic>{
    'id': extId,
    'vob_guid': vobGuid,
    'ssa_number': _str(e['SSANumber']),
    'emergency_contact_number': _str(e['EmergencyContactNumber']),
    'firebase_number': _str(e['FirebaseNumber']),
    'membership_type': membershipStr,
    'can_show_birthday': _bool(e['CanShowBirthday']),
    'can_show_email': _bool(e['CanShowEmail']),
    'can_show_contact': _bool(e['CanShowContact']),
    'is_coach': _bool(e['IsCoach']),
  };

  final email = _str(p['Email']);
  final emailLower = email?.toLowerCase();

  final profileJson = <String, dynamic>{
    'id': profId,
    'vob_guid': vobGuid,
    'first_name': _str(p['FirstName']),
    'last_name': _str(p['LastName']),
    'email': emailLower,
    'contact_number': _str(p['ContactNumber']),
    'password': _str(p['Password']),
    'profile_type': _str(p['ProfileType']),
    'is_active': _bool(p['IsActive']) ?? false,
    'date_of_birth': _str(p['DateOfBirth']),
    'date_created': _str(p['DateCreated']),
    'password_hashed': _bool(p['PasswordHashed']) ?? false,
    'profile_extension_id': extId,
  };

  return (ext: extensionJson, prof: profileJson);
}

/// Maps a Parse `Locations` REST row to PostgREST JSON for `public.locations`.
///
/// Parse fields: [Id] (vob guid), [Name], [Latitude], [Longitude], [Lookup].
Map<String, dynamic> mapParseLocationToSupabaseRow(Map<String, dynamic> parseRow) {
  final rawGuid = _str(parseRow['Id']);
  final vobGuid = normalizeVobGuid(rawGuid);
  if (vobGuid == null || vobGuid.isEmpty || !isCanonicalUuid(vobGuid)) {
    throw StateError(
      'Invalid or missing Parse Locations Id (vob_guid): raw=$rawGuid objectId=${parseRow['objectId']}',
    );
  }

  final id = locationIdForVobGuid(vobGuid);
  final lat = parseRow['Latitude'];
  final lng = parseRow['Longitude'];
  String? latStr;
  String? lngStr;
  if (lat != null) {
    latStr = lat is num ? lat.toString() : _str(lat);
  }
  if (lng != null) {
    lngStr = lng is num ? lng.toString() : _str(lng);
  }

  return <String, dynamic>{
    'id': id,
    'vob_guid': vobGuid,
    'name': _str(parseRow['Name']),
    'latitude': latStr,
    'longitude': lngStr,
    'lookup': _str(parseRow['Lookup']),
  };
}

/// Maps a Parse `Settings` REST row to PostgREST JSON for `public.settings`.
///
/// Parse fields: [Name] (unique key), [Value], [objectId].
Map<String, dynamic> mapParseSettingsToSupabaseRow(Map<String, dynamic> parseRow) {
  final name = _str(parseRow['Name']);
  if (name == null || name.isEmpty) {
    throw StateError('Missing or empty Settings Name: objectId=${parseRow['objectId']}');
  }
  final id = settingsIdForName(name);
  return <String, dynamic>{
    'id': id,
    'name': name,
    'value': _str(parseRow['Value']),
    'legacy_object_id': _str(parseRow['objectId']),
  };
}

String? _vobFromLadderProfilePointer(Map<String, dynamic> parseRow) {
  final p = parseRow['ProfileId'];
  if (p is Map<String, dynamic>) {
    return _str(p['Id']);
  }
  return null;
}

/// Maps a Parse ladder row (`LadderMens` / `LadderLadies` / `LadderMasters`) with
/// included [ProfileId] to PostgREST `public.ladder_mens` | `ladder_ladies` | `ladder_masters`.
///
/// [ladderTypeIdentifier] is [LadderTypeEnum.identifierType] — used only for deterministic [id].
Map<String, dynamic> mapParseLadderRowToSupabase({
  required Map<String, dynamic> parseRow,
  required String ladderTypeIdentifier,
}) {
  final objectId = parseRow['objectId'] as String?;
  if (objectId == null || objectId.isEmpty) {
    throw StateError('Missing ladder objectId');
  }
  final rawVob = _vobFromLadderProfilePointer(parseRow);
  final vob = normalizeVobGuid(rawVob);

  return <String, dynamic>{
    'id': ladderEntryIdFor(ladderTypeIdentifier, objectId),
    'sort_order': _int(parseRow['Order']),
    'year': _int(parseRow['Year']),
    'vob_guid': vob,
    'team': _int(parseRow['Team']),
    'can_be_challenged': _bool(parseRow['CanBeChallenged']),
    'legacy_object_id': objectId,
  };
}

String? _pointerObjectId(dynamic v) {
  if (v == null) return null;
  if (v is String) return v;
  if (v is Map<String, dynamic>) {
    return _str(v['objectId']);
  }
  return null;
}

/// Maps a Parse `LeagueCaptains` row to PostgREST `public.league_captains`.
///
/// Parse fields align with [DatabaseClubCaptains] / `packages/examples/file_examples/data_club_captains.dart`.
Map<String, dynamic> mapParseLeagueCaptainToSupabaseRow(Map<String, dynamic> parseRow) {
  final objectId = parseRow['objectId'] as String?;
  if (objectId == null || objectId.isEmpty) {
    throw StateError('Missing LeagueCaptains objectId');
  }
  return <String, dynamic>{
    'id': leagueCaptainIdFor(objectId),
    'club_name': _str(parseRow['ClubName']),
    'captain_name': _str(parseRow['CaptainName']),
    'captain_contact_no': _str(parseRow['ContactNumber']),
    'is_catering': _bool(parseRow['Catering']) ?? _bool(parseRow['IsCatering']),
    'league_team': _int(parseRow['LeagueTeam']),
    'club_location_fk': _pointerObjectId(parseRow['ClubLocationFK']),
    'ladder_type': _int(parseRow['LadderType']),
    'legacy_object_id': objectId,
  };
}

DateTime? _parseParseDate(dynamic v) {
  if (v == null) return null;
  if (v is String) return DateTime.tryParse(v);
  if (v is Map<String, dynamic>) {
    final iso = v['iso'];
    if (iso is String) return DateTime.tryParse(iso);
  }
  return null;
}

String _gameDateIsoForSupabase(Map<String, dynamic> parseRow) {
  final dt = _parseParseDate(parseRow['gameDate']);
  if (dt == null) {
    throw StateError('Missing or invalid gameDate: objectId=${parseRow['objectId']}');
  }
  return dt.toUtc().toIso8601String();
}

/// Maps a Parse `LeagueFixture` row to PostgREST `public.league_fixtures`.
///
/// Aligns with [DatabaseLeagueFixture] / `packages/examples/file_examples/data_league_fixture.dart`.
Map<String, dynamic> mapParseLeagueFixtureToSupabaseRow(Map<String, dynamic> parseRow) {
  final objectId = parseRow['objectId'] as String?;
  if (objectId == null || objectId.isEmpty) {
    throw StateError('Missing LeagueFixture objectId');
  }
  return <String, dynamic>{
    'id': leagueFixtureIdFor(objectId),
    'game_date': _gameDateIsoForSupabase(parseRow),
    'opponent': _str(parseRow['opponent']),
    'opponent_location_id': _pointerObjectId(parseRow['opponentLocationId']),
    'is_home': _bool(parseRow['isHome']),
    'league_team': _int(parseRow['leagueTeam']),
    'ladder_type': _int(parseRow['ladderType']),
    'legacy_object_id': objectId,
  };
}

String? _bookingVobGuid(Map<String, dynamic> parseRow) {
  final fk = parseRow['ProfileFk'];
  if (fk is String) {
    final n = normalizeVobGuid(fk.trim());
    if (n != null && n.isNotEmpty) return n;
  }
  if (fk is Map<String, dynamic>) {
    final idFromFk = _str(fk['Id']);
    if (idFromFk != null) {
      final n = normalizeVobGuid(idFromFk.trim());
      if (n != null && n.isNotEmpty) return n;
    }
  }
  final p = parseRow['ProfileId'];
  if (p is Map<String, dynamic>) {
    return normalizeVobGuid(_str(p['Id']));
  }
  return null;
}

String _bookingDateIsoForSupabase(Map<String, dynamic> parseRow) {
  final dt = _parseParseDate(parseRow['BookingDate']);
  if (dt == null) {
    throw StateError('Missing or invalid BookingDate: objectId=${parseRow['objectId']}');
  }
  return dt.toUtc().toIso8601String();
}

/// Maps a Parse `Bookings` row (with optional included `ProfileId`) to PostgREST `public.bookings`.
///
/// Aligns with [DatabaseBooking] / `packages/examples/file_examples/data_booking.dart`.
Map<String, dynamic> mapParseBookingToSupabaseRow(Map<String, dynamic> parseRow) {
  final objectId = parseRow['objectId'] as String?;
  if (objectId == null || objectId.isEmpty) {
    throw StateError('Missing Bookings objectId');
  }
  final vob = _bookingVobGuid(parseRow);
  if (vob == null || vob.isEmpty) {
    throw StateError('Missing ProfileFk / ProfileId.Id (vob_guid): objectId=$objectId');
  }
  return <String, dynamic>{
    'id': bookingIdFor(objectId),
    'vob_guid': vob,
    'court_no': _int(parseRow['CourtNo']),
    'booking_date': _bookingDateIsoForSupabase(parseRow),
    'display_name': _str(parseRow['DisplayName']),
    'group_booking_id': _int(parseRow['GroupBookingId']) ?? 0,
    'legacy_object_id': objectId,
  };
}
