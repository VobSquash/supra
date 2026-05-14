import 'package:client_models/client_models.dart';
import 'package:flutter/material.dart';

/// Mens ladder, 1st league team: venue display overrides by fixture date (local calendar day).
final Map<DateTime, String> kMensLeagueFirstTeamVenueOverrides = {
  DateTime(2026, 4, 9): 'VOB',
  DateTime(2026, 4, 16): 'WPCC',
  DateTime(2026, 4, 23): 'Stellenbosch',
  DateTime(2026, 5, 7): 'Camps Bay',
  DateTime(2026, 5, 21): 'Fish Hoek',
  DateTime(2026, 5, 28): 'WPCC',
  DateTime(2026, 6, 4): 'UCT',
  DateTime(2026, 6, 11): 'Camps Bay',
  DateTime(2026, 6, 25): 'VOB',
  DateTime(2026, 7, 23): 'Stellenbosch',
  DateTime(2026, 7, 30): 'Fish Hoek',
  DateTime(2026, 8, 6): 'UCT',
  DateTime(2026, 8, 13): 'WPCC',
  DateTime(2026, 8, 20): 'VOB',
};

DateTime dateOnlyLocal(DateTime d) {
  final l = d.toLocal();
  return DateTime(l.year, l.month, l.day);
}

/// Venue label: API value unless mens + 1st league + date has an override.
String displayVenueForFixture(LeagueFixtureDto fixture) {
  final base = fixture.venue.trim().isEmpty ? '—' : fixture.venue;
  if (fixture.ladderType != LadderTypeEnum.mens) return base;
  if (fixture.leagueTeam != 1) return base;
  final key = dateOnlyLocal(fixture.fixtureDate);
  final override = kMensLeagueFirstTeamVenueOverrides[key];
  if (override != null && override.trim().isNotEmpty) return override;
  return base;
}

bool isVobSide(String team) => team.trim().toUpperCase() == 'VOB';

bool isVobHomeFixture(LeagueFixtureDto f) => isVobSide(f.homeTeam);

/// Stripe colour for a fixture row: varies per match so a single-league list is not one hue.
Color accentStripeColorForFixture(LeagueFixtureDto fixture) {
  if (fixture.leagueTeam <= 0) return const Color(0xFF607D8E);
  final n = _kFixtureStripeColors.length;
  var h = _fixtureAccentSeed(fixture);
  if (h < 0) h = -h;
  return _kFixtureStripeColors[h % n];
}

int _fixtureAccentSeed(LeagueFixtureDto fixture) {
  if (fixture.id.isNotEmpty) {
    return fixture.id.hashCode;
  }
  return Object.hash(
    fixture.fixtureDate.millisecondsSinceEpoch,
    fixture.homeTeam,
    fixture.awayTeam,
    fixture.ladderType,
    fixture.leagueTeam,
  );
}

const List<Color> _kFixtureStripeColors = <Color>[
  Color(0xFF1565C0),
  Color(0xFF2E7D32),
  Color(0xFFE65100),
  Color(0xFF6A1B9A),
  Color(0xFF00838F),
  Color(0xFFC62828),
];

String englishOrdinal(int n) {
  final a = n.abs();
  if (a % 100 >= 11 && a % 100 <= 13) return '${n}th';
  switch (a % 10) {
    case 1:
      return '${n}st';
    case 2:
      return '${n}nd';
    case 3:
      return '${n}rd';
    default:
      return '${n}th';
  }
}

String leagueWithOrdinalLabel(int leagueTeam) => 'League ${englishOrdinal(leagueTeam)}';
