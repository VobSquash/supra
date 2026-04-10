import 'dart:convert';

import 'package:http/http.dart' as http;

/// Fetches Parse class `LeagueFixture` rows (Back4App REST).
class Back4appLeagueFixtureExtractor {
  Back4appLeagueFixtureExtractor({
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

  Future<List<Map<String, dynamic>>> fetchLeagueFixtures({int limit = 2000}) async {
    final uri = _classesUri('LeagueFixture', {
      'limit': '$limit',
      'order': 'gameDate',
    });

    final response = await _client.get(uri, headers: _headers);
    if (response.statusCode != 200) {
      throw StateError(
        'Parse LeagueFixture query failed (${response.statusCode}): ${response.body}',
      );
    }

    final data = jsonDecode(response.body) as Map<String, dynamic>;
    final results = data['results'] as List<dynamic>? ?? [];
    return results.map((e) => Map<String, dynamic>.from(e as Map)).toList(growable: false);
  }

  void close() => _client.close();
}
