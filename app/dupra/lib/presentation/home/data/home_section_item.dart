import 'package:dupra/engine/theme/dupra_colors.dart';
import 'package:dupra/presentation/home/data/home_overview_destination.dart';
import 'package:flutter/material.dart';

/// Row model for home overview section tiles (presentation data, not domain).
class HomeSectionItem {
  const HomeSectionItem({
    required this.title,
    required this.icon,
    this.destination,
    this.subtitle,
    this.accentColor = DupraColors.secondary,
    this.leadingEdgeAccent = false,
  });

  final String title;
  final String? subtitle;
  final IconData icon;
  /// When null, the row is non-navigating (e.g. placeholder or custom handling later).
  final HomeOverviewDestination? destination;
  final Color accentColor;
  final bool leadingEdgeAccent;
}
