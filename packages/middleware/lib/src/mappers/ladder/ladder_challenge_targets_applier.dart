import 'package:client_models/client_models.dart';

/// Normalizes ladder challenge eligibility for the **current viewer** on reads.
///
/// Ignores persisted `canBeChallenged` from storage; members only see the two
/// ladder slots immediately above themselves as challenge targets ([viewer]
/// must appear on that list).
///
/// Ordering follows [LadderItemDTO.order] ascending (`sort_order`; lower = higher rank).
List<LadderItemDTO> applyViewerChallengeTargets({
  required List<LadderItemDTO> items,
  required String? viewerVobGuid,
}) {
  if (items.isEmpty) return items;

  final trimmedViewer = viewerVobGuid?.trim();
  final viewerNorm =
      trimmedViewer != null && trimmedViewer.isNotEmpty ? trimmedViewer.toLowerCase() : null;

  if (viewerNorm == null) {
    return [
      for (final e in items) e.copyWith(canBeChallenged: false),
    ];
  }

  bool matchesViewer(LadderItemDTO e) {
    final g = e.vobGuid?.trim().toLowerCase();
    if (g != null && g.isNotEmpty && g == viewerNorm) return true;
    final pg = e.profile?.vobGuid?.trim().toLowerCase();
    return pg != null && pg.isNotEmpty && pg == viewerNorm;
  }

  final sorted = List<LadderItemDTO>.of(items)
    ..sort((a, b) {
      final o = (a.order ?? 0).compareTo(b.order ?? 0);
      if (o != 0) return o;
      final ga = a.vobGuid ?? '';
      final gb = b.vobGuid ?? '';
      return ga.compareTo(gb);
    });

  final myIndex = sorted.indexWhere(matchesViewer);
  if (myIndex < 0) {
    return [
      for (final e in items) e.copyWith(canBeChallenged: false),
    ];
  }

  final targetNorm = <String>{};
  void addTarget(LadderItemDTO e) {
    var k = e.vobGuid?.trim().toLowerCase();
    if (k == null || k.isEmpty) k = e.profile?.vobGuid?.trim().toLowerCase();
    if (k != null && k.isNotEmpty) targetNorm.add(k);
  }

  if (myIndex >= 1) addTarget(sorted[myIndex - 1]);
  if (myIndex >= 2) addTarget(sorted[myIndex - 2]);

  return items
      .map((e) {
        var k = e.vobGuid?.trim().toLowerCase();
        if (k == null || k.isEmpty) k = e.profile?.vobGuid?.trim().toLowerCase();
        final flagged = k != null && k.isNotEmpty && targetNorm.contains(k);
        return e.copyWith(canBeChallenged: flagged);
      })
      .toList(growable: false);
}
