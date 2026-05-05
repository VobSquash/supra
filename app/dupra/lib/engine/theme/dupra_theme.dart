import 'package:dupra/engine/theme/dupra_colors.dart';
import 'package:flutter/material.dart';

abstract final class DupraTheme {
  static ThemeData get dark {
    final base = ThemeData(useMaterial3: true, brightness: Brightness.dark);

    const scheme = ColorScheme.dark(
      surface: DupraColors.scaffoldSecondary,
      primary: DupraColors.secondary,
      onPrimary: Color(0xFF0a0a0a),
      secondary: DupraColors.tertiary,
      onSecondary: DupraColors.textPrimary,
      tertiary: DupraColors.success,
      onTertiary: Color(0xFF0a0a0a),
      error: DupraColors.error,
      onError: DupraColors.textPrimary,
      onSurfaceVariant: DupraColors.textSecondary,
      outline: DupraColors.primary,
    );

    return base.copyWith(
      colorScheme: scheme,
      // Gradient lives in [MaterialApp.builder] ([GlassicBackground]); keep scaffolds transparent.
      scaffoldBackgroundColor: Colors.transparent,
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        foregroundColor: DupraColors.textPrimary,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
      ),
      cardTheme: CardThemeData(
        color: DupraColors.scaffoldSecondary.withValues(alpha: 0.85),
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          foregroundColor: scheme.onPrimary,
          backgroundColor: DupraColors.secondary,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
      listTileTheme: const ListTileThemeData(
        textColor: DupraColors.textPrimary,
        iconColor: DupraColors.textSecondary,
      ),
      dividerTheme: DividerThemeData(
        color: DupraColors.textSecondary.withValues(alpha: 0.25),
      ),
    );
  }
}
