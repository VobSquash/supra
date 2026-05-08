import 'package:flutter/material.dart';

/// Bottom inset for dock + safe area; used by shell [PageView] tabs.
EdgeInsets dupraShellTabPadding(BuildContext context, {double top = 16}) {
  final bottom = MediaQuery.paddingOf(context).bottom;
  return EdgeInsets.fromLTRB(24, top, 24, 24 + bottom + 2);
}
