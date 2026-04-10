import 'dart:convert';

import 'package:http/http.dart' as http;

/// Fetches [Profile] and [ProfileExtensions] rows from Parse REST (Back4App).
///
/// Mirrors the query shape used in `packages/examples/back4app_client`
/// (`Back4AppClientUsers._getProfiles` / `_getProfileExtensions`).
class Back4appProfileExtractor {
  Back4appProfileExtractor({
    required this.baseUrl,
    required this.applicationId,
    required this.clientKey,
    this.masterKey,
    http.Client? httpClient,
  }) : _client = httpClient ?? http.Client();

  final String baseUrl;
  final String applicationId;
  final String clientKey;
  final String? masterKey;
  final http.Client _client;

  Map<String, String> get _headers {
    final h = <String, String>{
      'X-Parse-Application-Id': applicationId,
      'X-Parse-Client-Key': clientKey,
      'Content-Type': 'application/json',
    };
    final mk = masterKey;
    if (mk != null && mk.isNotEmpty) {
      h['X-Parse-Master-Key'] = mk;
    }
    return h;
  }

  Uri _classesUri(String className, Map<String, dynamic> query) {
    final uri = Uri.parse('$baseUrl/classes/$className');
    return uri.replace(
      queryParameters: query.map(
        (k, v) => MapEntry(k, v is String ? v : jsonEncode(v)),
      ),
    );
  }

  /// Loads all profiles (optionally active only) with [limit] cap (default 300).
  Future<List<Map<String, dynamic>>> fetchProfiles({
    required bool activeOnly,
    int limit = 300,
  }) async {
    final where = activeOnly ? <String, dynamic>{'IsActive': true} : <String, dynamic>{};
    final uri = _classesUri('Profile', {
      'where': jsonEncode(where),
      'limit': '$limit',
      'order': 'createdAt',
    });

    final response = await _client.get(uri, headers: _headers);
    if (response.statusCode != 200) {
      throw StateError(
        'Parse Profile query failed (${response.statusCode}): ${response.body}',
      );
    }

    final data = jsonDecode(response.body) as Map<String, dynamic>;
    final results = data['results'] as List<dynamic>? ?? [];
    return results.map((e) => Map<String, dynamic>.from(e as Map)).toList(growable: false);
  }

  /// Loads extensions whose [ProfileId] points at one of [profileObjectIds].
  Future<List<Map<String, dynamic>>> fetchProfileExtensionsForProfiles(
    List<String> profileObjectIds, {
    int limit = 300,
  }) async {
    if (profileObjectIds.isEmpty) {
      return [];
    }

    final uri = _classesUri('ProfileExtensions', {
      'where': jsonEncode({
        'ProfileId': {
          r'$inQuery': {
            'where': {
              'objectId': {r'$in': profileObjectIds},
            },
            'className': 'Profile',
          },
        },
      }),
      'limit': '$limit',
    });

    final response = await _client.get(uri, headers: _headers);
    if (response.statusCode != 200) {
      throw StateError(
        'Parse ProfileExtensions query failed (${response.statusCode}): ${response.body}',
      );
    }

    final data = jsonDecode(response.body) as Map<String, dynamic>;
    final results = data['results'] as List<dynamic>? ?? [];
    return results.map((e) => Map<String, dynamic>.from(e as Map)).toList(growable: false);
  }

  void close() => _client.close();
}
