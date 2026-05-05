import 'package:dupra/engine/theme/dupra_colors.dart';
import 'package:flutter/material.dart';

/// Row model for home overview section tiles (presentation data, not domain).
class HomeSectionItem {
  const HomeSectionItem({
    required this.title,
    required this.icon,
    this.subtitle,
    this.accentColor = DupraColors.secondary,
    this.leadingEdgeAccent = false,
  });

  final String title;
  final String? subtitle;
  final IconData icon;
  final Color accentColor;
  final bool leadingEdgeAccent;
}
