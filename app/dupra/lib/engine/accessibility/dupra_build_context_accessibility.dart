import 'package:flutter/material.dart';

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
  /// Linear text scale from the platform [TextScaler] (`1` → default size).
  double get _dupraTextScaleFactor => MediaQuery.textScalerOf(this).scale(1);

  /// Whether [_dupraTextScaleFactor] is at most [maxInclusive].
  bool _dupraIsTextScaleAtMost(double maxInclusive) => _dupraTextScaleFactor <= maxInclusive;

  /// Whether dense rows (bottom dock, cramped tabs) should still draw small
  /// captions under icons.
  bool get appAccessibilityVisibility =>
      _dupraIsTextScaleAtMost(DupraAccessibilityThresholds.denseSecondaryLabelMaxTextScale);
}
