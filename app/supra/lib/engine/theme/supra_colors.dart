import 'package:flutter/material.dart';

/// Palette adapted from the legacy Vob / teal–cyan direction
/// (see `example-files/_color_definitions.dart`).
abstract final class SupraColors {
  static const Color scaffoldBackground = Color(0xFF1f1f1f);
  static const Color scaffoldSecondary = Color(0xFF3E4145);
  static const Color primary = Color(0xFF575757);
  static const Color secondary = Color(0xFF28D6F5);
  static const Color tertiary = Color(0xff0B8091);
  static const Color success = Color(0xFF00c59d);
  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xffb0c9c2);
  static const Color error = Color.fromARGB(253, 176, 98, 9);
  static const Color warning = Color(0xFFff8c41);
  static const Color calculator = Color.fromARGB(255, 203, 95, 165);

  /// Solid fill for booked court cells (use with white / near-white text), like legacy `BookedCell`.
  static Color courtBookedFill(int courtNo) {
    List<Color> courtColors = [
      Colors.blue.shade800, // Court 1 - Royal Blue
      Colors.green.shade800, // Court 2 - Lime Green
      Colors.orange.shade800, // Court 3 - Orange
    ];
    return switch (courtNo) {
      1 => courtColors[0],
      2 => courtColors[1],
      3 => courtColors[2],
      _ => tertiary,
    };
  }
}
