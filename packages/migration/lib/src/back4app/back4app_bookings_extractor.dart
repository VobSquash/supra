import 'dart:convert';

import 'package:http/http.dart' as http;

/// Fetches Parse class `Bookings` rows (Back4App REST).
class Back4appBookingsExtractor {
  Back4appBookingsExtractor({
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

  /// Parse `where` — [BookingDate] on or after 1 Jan [minBookingYear] UTC.
  static Map<String, dynamic> _whereBookingDateFromYear(int minBookingYear) {
    final start = DateTime.utc(minBookingYear, 1, 1);
    return <String, dynamic>{
      'BookingDate': <String, dynamic>{
        r'$gte': <String, dynamic>{
          '__type': 'Date',
          'iso': start.toIso8601String(),
        },
      },
    };
  }

  /// Loads bookings with embedded `ProfileId` (for `Id` → vob_guid).
  ///
  /// Only rows with [BookingDate] **≥ 1 Jan [minBookingYear] UTC** are fetched
  /// (the Back4App table can be very large; historical rows are skipped).
  /// Results are paged until a batch shorter than [pageSize].
  Future<List<Map<String, dynamic>>> fetchBookings({
    int minBookingYear = 2026,
    int pageSize = 1000,
  }) async {
    final where = _whereBookingDateFromYear(minBookingYear);
    final all = <Map<String, dynamic>>[];
    var skip = 0;

    while (true) {
      final uri = _classesUri('Bookings', <String, dynamic>{
        'limit': '$pageSize',
        'skip': '$skip',
        'include': 'ProfileId',
        'order': 'BookingDate,CourtNo',
        'where': where,
      });

      final response = await _client.get(uri, headers: _headers);
      if (response.statusCode != 200) {
        throw StateError(
          'Parse Bookings query failed (${response.statusCode}): ${response.body}',
        );
      }

      final data = jsonDecode(response.body) as Map<String, dynamic>;
      final results = data['results'] as List<dynamic>? ?? [];
      final batch = results.map((e) => Map<String, dynamic>.from(e as Map)).toList(growable: false);
      all.addAll(batch);
      if (batch.length < pageSize) {
        break;
      }
      skip += pageSize;
    }

    return all;
  }

  void close() => _client.close();
}
