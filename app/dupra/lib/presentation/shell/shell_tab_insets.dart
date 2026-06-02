import 'package:flutter/material.dart';

/// Inner height of the floating dock (gradient strip + tab row).
const double kDupraDockNavBarHeight = 59;

/// Gap between the dock pill and the bottom safe area.
const double kDupraDockNavFloatMargin = 12;

/// Horizontal inset of the floating dock from screen edges.
const double kDupraDockNavHorizontalMargin = 16;

/// Scroll/content clearance for shell tabs above the floating dock.
double dupraShellTabBottomInset(BuildContext context) {
  final safeBottom = MediaQuery.paddingOf(context).bottom;
  return 24 + kDupraDockNavBarHeight + kDupraDockNavFloatMargin + safeBottom;
}

/// Bottom inset for dock + safe area; used by shell [PageView] tabs.
EdgeInsets dupraShellTabPadding(BuildContext context, {double top = 16}) {
  return EdgeInsets.fromLTRB(24, top, 24, dupraShellTabBottomInset(context));
}
