import 'package:client_models/client_models.dart';
import 'package:flutter/material.dart';

/// Parses [BasicProfileDTO.dateOfBirth] (typically `yyyy-MM-dd` from Supabase) to local date-only.
DateTime? parseProfileDateOnly(String? raw) {
  if (raw == null) return null;
  final s = raw.trim();
  if (s.isEmpty) return null;

  final parts = s.split('-');
  if (parts.length == 3) {
    final y = int.tryParse(parts[0]);
    final m = int.tryParse(parts[1]);
    final d = int.tryParse(parts[2]);
    if (y != null && m != null && d != null) {
      return DateTime(y, m, d);
    }
  }

  try {
    final dt = DateTime.parse(s);
    return DateUtils.dateOnly(dt);
  } catch (_) {
    return null;
  }
}

int _lastDayOfMonth(int year, int month) => DateTime(year, month + 1, 0).day;

DateTime _safeLocalBirthday(int year, int month, int desiredDay) {
  final last = _lastDayOfMonth(year, month);
  final d = desiredDay > last ? last : desiredDay;
  return DateTime(year, month, d);
}

/// Earliest local calendar date matching parts month/day that is not before startInclusive.
DateTime _occurrenceOnOrAfter(_LocalMonthDay parts, DateTime startInclusive) {
  final start = DateUtils.dateOnly(startInclusive);
  final m = parts.month;
  final d = parts.day;
  var y = start.year;
  var cand = DateUtils.dateOnly(_safeLocalBirthday(y, m, d));
  if (cand.isBefore(start)) {
    y += 1;
    cand = DateUtils.dateOnly(_safeLocalBirthday(y, m, d));
  }
  return cand;
}

class _LocalMonthDay {
  const _LocalMonthDay({required this.month, required this.day});

  factory _LocalMonthDay.from(DateTime localDateOnly) =>
      _LocalMonthDay(month: localDateOnly.month, day: localDateOnly.day);

  final int month;
  final int day;
}

/// Resolved birthday in the administrative horizon (local calendar).
class UpcomingAdminBirthday {
  const UpcomingAdminBirthday({required this.profile, required this.celebrationLocal});

  final BasicProfileDTO profile;

  /// Local date-only — next occurrence matching the stored month/day.
  final DateTime celebrationLocal;
}

String adminProfileDisplayLabel(BasicProfileDTO p) {
  final n = p.displayName.trim();
  if (n.isNotEmpty) return n;
  final e = p.email?.trim();
  if (e != null && e.isNotEmpty) return e;
  return 'Member';
}

/// Profiles whose birthday falls on today through today plus [daysAheadInclusive] (local TZ).
List<UpcomingAdminBirthday> upcomingAdminBirthdays(
  List<BasicProfileDTO> profiles,
  DateTime nowLocal, {
  required int daysAheadInclusive,
}) {
  final today = DateUtils.dateOnly(nowLocal);
  final endInclusive = today.add(Duration(days: daysAheadInclusive));

  final hits = <UpcomingAdminBirthday>[];

  for (final profile in profiles) {
    final birth = parseProfileDateOnly(profile.dateOfBirth);
    if (birth == null) {
      continue;
    }

    final parts = _LocalMonthDay.from(birth);
    final celebration = _occurrenceOnOrAfter(parts, today);

    if (!celebration.isAfter(endInclusive)) {
      hits.add(UpcomingAdminBirthday(profile: profile, celebrationLocal: celebration));
    }
  }

  hits.sort((a, b) {
    final byDate = a.celebrationLocal.compareTo(b.celebrationLocal);
    if (byDate != 0) {
      return byDate;
    }
    return adminProfileDisplayLabel(a.profile).compareTo(adminProfileDisplayLabel(b.profile));
  });

  return hits;
}
