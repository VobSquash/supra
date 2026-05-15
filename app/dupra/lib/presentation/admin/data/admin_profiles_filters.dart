import 'package:client_models/client_models.dart';

bool adminProfileTreatAsActive(BasicProfileDTO p) => p.isActive ?? false;

List<BasicProfileDTO> rosterActiveSubset(List<BasicProfileDTO> source) =>
    source.where(adminProfileTreatAsActive).toList(growable: false);

/// Members with explicitly inactive rows or unknown [BasicProfileDTO.isActive] (treated inactive).
List<BasicProfileDTO> rosterInactiveSubset(List<BasicProfileDTO> source) =>
    source.where((p) => !adminProfileTreatAsActive(p)).toList(growable: false);

/// Limits the roster using display name segments only (admins wishing to focus on identities).
List<BasicProfileDTO> filterAdminProfilesByDisplayNameParts({
  required List<BasicProfileDTO> roster,
  required String rawQuery,
}) {
  final query = rawQuery.trim().toLowerCase();
  if (query.isEmpty) {
    return List.of(roster);
  }

  return roster.where((BasicProfileDTO p) {
    final name = p.displayName.toLowerCase();
    final first = (p.firstName ?? '').toLowerCase();
    final last = (p.lastName ?? '').toLowerCase();
    return name.contains(query) || first.contains(query) || last.contains(query);
  }).toList(growable: false);
}

/// Alphabetical by trimmed [BasicProfileDTO.displayName] (case-insensitive); blank names sort last among peers).
List<BasicProfileDTO> rosterSortedByDisplayName(List<BasicProfileDTO> source) {
  final copy = [...source]
    ..sort((a, b) {
      final na = a.displayName.trim().toLowerCase();
      final nb = b.displayName.trim().toLowerCase();
      if (na.isEmpty && nb.isNotEmpty) {
        return 1;
      }
      if (na.isNotEmpty && nb.isEmpty) {
        return -1;
      }
      return na.compareTo(nb);
    });

  return copy;
}
