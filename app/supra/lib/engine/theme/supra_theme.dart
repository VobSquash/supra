import 'package:flutter/material.dart';

import 'supra_colors.dart';

/// Dark theme aligned with [SupraColors] for Material 3 widgets.
abstract final class SupraTheme {
  static ThemeData get dark {
    final base = ThemeData(useMaterial3: true, brightness: Brightness.dark);

    final scheme = ColorScheme.dark(
      surface: SupraColors.scaffoldSecondary,
      primary: SupraColors.secondary,
      onPrimary: const Color(0xFF0a0a0a),
      secondary: SupraColors.tertiary,
      onSecondary: SupraColors.textPrimary,
      tertiary: SupraColors.success,
      onTertiary: const Color(0xFF0a0a0a),
      error: SupraColors.error,
      onError: SupraColors.textPrimary,
      onSurface: SupraColors.textPrimary,
      onSurfaceVariant: SupraColors.textSecondary,
      outline: SupraColors.primary,
      
    );

    return base.copyWith(
      colorScheme: scheme,
      // Gradient lives in [MaterialApp.builder] ([GlassicBackground]); keep scaffolds transparent.
      scaffoldBackgroundColor: Colors.transparent,
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        foregroundColor: SupraColors.textPrimary,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
      ),
      cardTheme: CardThemeData(
        color: SupraColors.scaffoldSecondary.withValues(alpha: 0.85),
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          foregroundColor: scheme.onPrimary,
          backgroundColor: SupraColors.secondary,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      listTileTheme: const ListTileThemeData(
        textColor: SupraColors.textPrimary,
        iconColor: SupraColors.textSecondary,
      ),
      dividerTheme: DividerThemeData(
        color: SupraColors.textSecondary.withValues(alpha: 0.25),
      ),
    );
  }
}
