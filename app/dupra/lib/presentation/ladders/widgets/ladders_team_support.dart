part of '../ladders_page.dart';

/// Sorted list of (teamId, members ordered by ladder `order`).
List<MapEntry<int, List<LadderItemDTO>>> _groupByTeamSorted(List<LadderItemDTO> items) {
  final map = <int, List<LadderItemDTO>>{};
  for (final e in items) {
    final t = e.team ?? 0;
    map.putIfAbsent(t, () => []).add(e);
  }
  for (final list in map.values) {
    list.sort((a, b) => (a.order ?? 0).compareTo(b.order ?? 0));
  }
  final keys = map.keys.toList()
    ..sort((a, b) {
      if (a == 0 && b != 0) return 1;
      if (b == 0 && a != 0) return -1;
      return a.compareTo(b);
    });
  return [for (final k in keys) MapEntry(k, map[k]!)];
}

Color _accentForTeam(int team) {
  if (team <= 0) return const Color(0xFF607D8E);
  return _kTeamStripeColors[(team - 1) % _kTeamStripeColors.length];
}

/// English ordinal for positive integers (e.g. 1 → "1st", 22 → "22nd").
String _ordinalEnglish(int n) {
  if (n <= 0) return '$n';
  final mod100 = n % 100;
  if (mod100 >= 11 && mod100 <= 13) return '${n}th';
  switch (n % 10) {
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

String _leagueTitle(int team) {
  if (team <= 0) return 'Open Ladder';
  return '${_ordinalEnglish(team)} League';
}
