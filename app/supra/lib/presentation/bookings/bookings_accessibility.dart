import 'package:flutter/material.dart';

/// Above this effective text scale, the 3-column court grid is too cramped;
/// use the stacked (4-row per slot) layout instead.
///
/// Tuned so default / slightly larger text keeps the grid; OS “larger text”
/// settings typically cross this threshold.
const double kBookingsCompactGridMaxTextScale = 1.12;

/// `true` = default 3-column grid; `false` = accessibility stacked rows per slot.
bool useCompactBookingsTimeslotGrid(BuildContext context) {
  final ts = MediaQuery.textScalerOf(context);
  final factor = ts.scale(14) / 14.0;
  return factor < kBookingsCompactGridMaxTextScale;
}
