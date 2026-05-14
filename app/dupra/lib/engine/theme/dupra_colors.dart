import 'package:flutter/material.dart';

/// Carried forward from legacy Supra palette (see supra `SupraColors`).
abstract final class DupraColors {
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

  /// Accent for list rows keyed by first letter of [displayName] (A→…→Z cycling hues).
  /// Non-letter starts use a deterministic bucket via `codeUnit % 26`.
  static Color accentForUserDirectoryRow(String displayName) {
    final trimmed = displayName.trim();
    if (trimmed.isEmpty) {
      return secondary;
    }
    final firstLetter = trimmed.characters.first.toUpperCase();
    if (firstLetter.isEmpty) {
      return secondary;
    }
    final cu = firstLetter.codeUnits.first;

    final int bucket;
    if (cu >= 65 && cu <= 90) {
      bucket = cu - 65;
    } else {
      bucket = cu % 26;
    }

    final hue = bucket * (360 / 26) % 360;
    return HSLColor.fromAHSL(1, hue, 0.55, 0.56).toColor();
  }

  /// Solid fill for booked court cells (pair with light / white foreground), aligned with Supra bookings.
  static Color courtBookedFill(int courtNo) {
    final courtColors = [
      Colors.blue.shade800,
      Colors.green.shade800,
      Colors.orange.shade800,
    ];
    return switch (courtNo) {
      1 => courtColors[0],
      2 => courtColors[1],
      3 => courtColors[2],
      _ => tertiary,
    };
  }
}
