import 'package:app_bloc/app_bloc.dart';
import 'package:dupra/engine/theme/dupra_colors.dart';
import 'package:dupra/presentation/bookings/data/booking_schedule.dart';
import 'package:dupra/presentation/widgets/dupra_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

/// One day: **rows** = courts, **columns** = schedule time slots (squares).
/// Tap a cell for the slot range and who holds the booking (if any).
/// Chevrons step the selected calendar day.
class DupraAdminCourtHeatmapCard extends StatefulWidget {
  const DupraAdminCourtHeatmapCard({super.key});

  @override
  State<DupraAdminCourtHeatmapCard> createState() => _DupraAdminCourtHeatmapCardState();
}

class _DupraAdminCourtHeatmapCardState extends State<DupraAdminCourtHeatmapCard> {
  late DateTime _forDay;

  static const double _labelColWidth = 52;
  static const double _gap = 3;

  @override
  void initState() {
    super.initState();
    _forDay = DateUtils.dateOnly(DateTime.now());
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      context.read<BookingHeatmapBloc>().add(BookingHeatmapEvent.loadAdminDay(forDay: _forDay));
    });
  }

  void _shiftDay(int delta) {
    setState(() {
      _forDay = DateUtils.dateOnly(_forDay.add(Duration(days: delta)));
    });
    context.read<BookingHeatmapBloc>().add(BookingHeatmapEvent.loadAdminDay(forDay: _forDay));
  }

  Color _cellColor(BuildContext context, {required bool booked}) {
    final scheme = Theme.of(context).colorScheme;
    if (!booked) {
      return scheme.surface.withValues(alpha: 0.25);
    }
    return Color.lerp(scheme.surfaceContainerHigh, scheme.primary, 0.55) ?? scheme.primary;
  }

  @override
  Widget build(BuildContext context) {
    final variant = Theme.of(context).colorScheme.onSurfaceVariant;
    final scheme = Theme.of(context).colorScheme;
    final headerStyle = Theme.of(
      context,
    ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600, color: scheme.onSurface);

    return BlocBuilder<BookingHeatmapBloc, BookingHeatmapState>(
      buildWhen: (p, c) => p.status != c.status || p.adminDayGrid != c.adminDayGrid || p.mode != c.mode,
      builder: (context, state) {
        final status = state.status.status;
        final loading = status == BaseLoadingStatus.initial || status == BaseLoadingStatus.loading;

        final titleAction = Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              visualDensity: VisualDensity.compact,
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
              tooltip: 'Previous day',
              onPressed: () => _shiftDay(-1),
              icon: Icon(Icons.chevron_left_rounded, color: scheme.onSurface),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Text(DateFormat.MMMEd().format(_forDay), style: headerStyle),
            ),
            IconButton(
              visualDensity: VisualDensity.compact,
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
              tooltip: 'Next day',
              onPressed: () => _shiftDay(1),
              icon: Icon(Icons.chevron_right_rounded, color: scheme.onSurface),
            ),
          ],
        );

        Widget cardBody;
        if (loading) {
          cardBody = const Padding(
            padding: EdgeInsets.symmetric(vertical: 28),
            child: Center(child: CircularProgressIndicator.adaptive()),
          );
        } else if (status == BaseLoadingStatus.loadingFailed) {
          final msg = state.status.message?.trim();
          cardBody = Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              (msg != null && msg.isNotEmpty) ? msg : 'Could not load court usage',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: DupraColors.error),
            ),
          );
        } else {
          final grid = state.adminDayGrid;
          if (grid == null) {
            cardBody = const SizedBox.shrink();
          } else {
            final slotCount = grid.slotStartMinutes.length;
            const labelColWidth = _labelColWidth;
            const gap = _gap;

            cardBody = Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Courts down the side; each column is a time slot. Tap a square for the slot time and occupant.',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(color: variant),
                  ),
                  const SizedBox(height: 12),
                  LayoutBuilder(
                    builder: (context, c) {
                      const minCell = 10.0;
                      const maxCell = 18.0;
                      final avail = c.maxWidth - labelColWidth - gap;
                      final cellW = (avail - gap * (slotCount - 1)) / slotCount;
                      final cell = (cellW.isFinite ? cellW : minCell).clamp(minCell, maxCell);
                      final gridWidth = slotCount * cell + gap * (slotCount - 1);

                      Widget slotGrid() {
                        return Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            for (var courtIdx = 0; courtIdx < grid.occupantLabels.length; courtIdx++) ...[
                              if (courtIdx > 0) const SizedBox(height: gap),
                              Row(
                                children: [
                                  SizedBox(
                                    width: labelColWidth,
                                    child: Align(
                                      alignment: Alignment.centerRight,
                                      child: Text(
                                        'Court ${courtIdx + 1}',
                                        style: Theme.of(
                                          context,
                                        ).textTheme.labelMedium?.copyWith(color: variant, fontWeight: FontWeight.w600),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: gap),
                                  ...List.generate(slotCount, (si) {
                                    final occupant = grid.occupantLabels[courtIdx][si];
                                    final booked = occupant != null;
                                    final startMin = grid.slotStartMinutes[si];
                                    final range = formatSlotRangeLabel(startMin);
                                    final tip = booked
                                        ? 'Court ${courtIdx + 1} · $range · $occupant'
                                        : 'Court ${courtIdx + 1} · $range · Available';
                                    return Padding(
                                      padding: EdgeInsets.only(left: si == 0 ? 0 : gap),
                                      child: Tooltip(
                                        triggerMode: TooltipTriggerMode.tap,
                                        message: tip,
                                        child: DecoratedBox(
                                          decoration: BoxDecoration(
                                            color: _cellColor(context, booked: booked),
                                            borderRadius: BorderRadius.circular(4),
                                            border: Border.all(
                                              color: scheme.outlineVariant.withValues(alpha: booked ? 0.4 : 0.12),
                                            ),
                                          ),
                                          child: SizedBox(width: cell, height: cell),
                                        ),
                                      ),
                                    );
                                  }),
                                ],
                              ),
                            ],
                          ],
                        );
                      }

                      if (gridWidth <= avail || !avail.isFinite) {
                        return slotGrid();
                      }
                      return SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: SizedBox(width: labelColWidth + gap + gridWidth, child: slotGrid()),
                      );
                    },
                  ),
                ],
              ),
            );
          }
        }

        return DupraSection(
          title: 'Court usage',
          titleAction: titleAction,
          cardChild: cardBody,
          horizontalInset: 0,
        );
      },
    );
  }
}
