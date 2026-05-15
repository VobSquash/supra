import 'package:characters/characters.dart';

/// First grapheme of [displayLine] for scroll chrome (matches directory display casing).
String usersDirectoryLeadLetter(String displayLine) {
  final t = displayLine.trim();
  if (t.isEmpty) {
    return '?';
  }
  final g = t.characters.first.toUpperCase();
  return g.isEmpty ? '?' : g;
}
