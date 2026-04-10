/// Extensions on [Map] of <[K], [V]>
extension ExtendsionsOnMapDynamicDynamic<K, V> on Map<K, V> {
  /// Order by keys
  Map<K, V> orderByKeys({required int Function(K a, K b) compareTo}) {
    return Map.fromEntries(entries.toList()..sort((a, b) => compareTo(a.key, b.key)));
  }

  /// Order by values
  Map<K, V> orderByValues({required int Function(V a, V b) compareTo}) {
    return Map.fromEntries(entries.toList()..sort((a, b) => compareTo(a.value, b.value)));
  }
}

// extension ExtendsionsOnMapIntList on List<LadderItemDTO>? {
//   Map<int, List<LadderItemDTO?>> convertToTeam() {
//     final groups = <int, List<LadderItemDTO?>>{};
//     if (this == null || this!.isEmpty) return groups;

//     this!.expand((item) => [item]).forEach((item) {
//       if (item.team != null) {
//         groups.putIfAbsent(item.team!, () => []).add(item);
//       }
//     });
//     return groups;
//   }
// }
