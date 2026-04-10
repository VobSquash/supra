import 'package:client_models/src/extensions/export_extensions.dart';

extension ListExtensions on List {
  Map<String, List<T>> toAlphaMap<T>() {
    final groupedAlpha = <String, List<T>>{};
    if (isEmpty) return groupedAlpha;

    for (final item in this) {
      groupedAlpha.putIfAbsent(item.displayName[0], () => <T>[]).add(item);
    }
    final alphas = _getAlphabet();
    for (var letter in alphas) {
      if (!groupedAlpha.containsKey(letter.toUpperCase())) {
        groupedAlpha.putIfAbsent(letter.capitalize(), () => <T>[]);
      }
    }
    groupedAlpha.keys.toList().sort((a, b) => a.compareTo(b));
    final sortedByKey = groupedAlpha.orderByKeys(compareTo: (a, b) => a.compareTo(b));
    return sortedByKey;
  }

  List<String> _getAlphabet() {
    final lettes = <String>[];
    for (int i = 1; i <= 26; i++) {
      String letter = String.fromCharCode(64 + i);

      lettes.add(letter);
    }
    return lettes;
  }
}

class Utilities {}
