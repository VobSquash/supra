import 'package:flutter/material.dart';

/// Dupra accessibility layout conventions (text scaling):
/// - Prefer `ThemeData.textTheme` roles over one-off font sizes; scale with the system.
/// - Do not wrap primary reading text in a fixed height that forces `FittedBox` scale-down; let rows grow
///   or use `Expanded` / `Flexible` with maxLines and ellipsis.
/// - Reserve `FittedBox` for fixed max-width chrome only (e.g. dock labels in narrow columns), not badges/cards.
/// - Use `dupraScaled` and `dupraScaledIconSize` on `BuildContext` for gaps and icons so they track text.

/// Named limits for adapting UI when the user has enlarged system text.
///
/// Tune these centrally so behavior stays consistent across the app.
abstract final class DupraAccessibilityThresholds {
  DupraAccessibilityThresholds._();

  /// Above this `_dupraTextScaleFactor` (see extension on `BuildContext`), omit
  /// secondary captions in tight horizontal chrome (icon bars, docks).
  ///
  /// Screen readers should still receive the same meaning via `Semantics`,
  /// tooltips, or route titles.
  static const double denseSecondaryLabelMaxTextScale = 1.28;
}

extension DupraAccessibilityBuildContext on BuildContext {
  /// Platform [TextScaler] (system large text).
  TextScaler get dupraTextScaler => MediaQuery.textScalerOf(this);

  /// Scales a layout value (padding, gap) with the system text scaler.
  double dupraScaled(double logicalPixels) => dupraTextScaler.scale(logicalPixels);

  /// Icon size from a 1.0-scale baseline, optionally clamped when a hard cap prevents blow-ups.
  double dupraScaledIconSize(double base, {double? min, double? max}) {
    final s = dupraTextScaler.scale(base);
    final lo = min ?? 0.0;
    final hi = max ?? double.infinity;
    return s.clamp(lo, hi);
  }

  EdgeInsets dupraScaledEdgeInsetsSymmetric({double horizontal = 0, double vertical = 0}) {
    return EdgeInsets.symmetric(
      horizontal: dupraScaled(horizontal),
      vertical: dupraScaled(vertical),
    );
  }

  /// Linear text scale from the platform [TextScaler] (`1` → default size).
  double get _dupraTextScaleFactor => dupraTextScaler.scale(1);

  /// Whether [_dupraTextScaleFactor] is at most [maxInclusive].
  bool _dupraIsTextScaleAtMost(double maxInclusive) => _dupraTextScaleFactor <= maxInclusive;

  /// Whether dense rows (bottom dock, cramped tabs) should still draw small
  /// captions under icons.
  bool get appAccessibilityVisibility =>
      _dupraIsTextScaleAtMost(DupraAccessibilityThresholds.denseSecondaryLabelMaxTextScale);
}
