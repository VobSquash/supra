import 'package:app_bloc/app_bloc.dart';
import 'package:dupra/engine/theme/dupra_colors.dart';
import 'package:dupra/presentation/widgets/dupra_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

enum _MemberHeatTab { rolling28, courtWeekday }

/// Member home: toggle **last 28 days** (daily activity, any court) vs **court × weekday** for the month.
class DupraMemberBookingHeatmapCard extends StatefulWidget {
  const DupraMemberBookingHeatmapCard({super.key});

  @override
  State<DupraMemberBookingHeatmapCard> createState() => _DupraMemberBookingHeatmapCardState();
}

class _DupraMemberBookingHeatmapCardState extends State<DupraMemberBookingHeatmapCard> {
  _MemberHeatTab _tab = _MemberHeatTab.rolling28;

  static const _weekdayLabels = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];

  static const _weekdayNames = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday',
  ];

  static const double _labelColWidth = 56;
  static const double _cellGap = 6;
  static const double _sectionGap = 18;
  static const double _blockBottomGap = 8;
  static const EdgeInsets _cardPadding = EdgeInsets.fromLTRB(22, 18, 22, 22);

  int _maxCountMonth(BookingHeatmapMemberMonth data) {
    var max = 1;
    for (final row in data.courtWeekdayCounts) {
      for (final n in row) {
        if (n > max) max = n;
      }
    }
    return max;
  }

  int _maxCountRolling(List<int> dayTotals) {
    var max = 1;
    for (final n in dayTotals) {
      if (n > max) max = n;
    }
    return max;
  }

  Color _cellColor(BuildContext context, int count, int maxCount) {
    final scheme = Theme.of(context).colorScheme;
    if (count <= 0) {
      return scheme.surface.withValues(alpha: 0.28);
    }
    final t = maxCount <= 0 ? 0.0 : count / maxCount;
    return Color.lerp(
          scheme.surfaceContainerHigh,
          scheme.primary,
          0.22 + 0.78 * t,
        ) ??
        scheme.primary;
  }

  Widget _rollingBody(
    BuildContext context, {
    required BookingHeatmapMemberRolling4Week rolling,
    required ColorScheme scheme,
    required Color variant,
  }) {
    final maxC = _maxCountRolling(rolling.dayTotals);
    final firstDay = rolling.anchorToday.subtract(const Duration(days: 27));
    final rangeEndLabel = DateFormat.yMMMd().format(rolling.anchorToday);
    final rangeStartLabel = DateFormat.yMMMd().format(firstDay);

    const rows = 4;
    const cols = 7;
    const labelColWidth = _labelColWidth;
    const gap = _cellGap;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$rangeStartLabel – $rangeEndLabel',
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w700,
                color: scheme.onSurface,
                height: 1.25,
              ),
        ),
        const SizedBox(height: 10),
        Text(
          'Each square is one day. Darker means more booked slots that day (any court). Today is bottom-right.',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(color: variant, height: 1.35),
        ),
        const SizedBox(height: _sectionGap),
        Column(
          children: [
            const SizedBox(height: _blockBottomGap),
            ...List.generate(rows, (row) {
              return Padding(
                padding: EdgeInsets.only(bottom: row < rows - 1 ? gap : 0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: labelColWidth,
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          'Wk ${row + 1}',
                          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                color: variant,
                                fontWeight: FontWeight.w600,
                              ),
                        ),
                      ),
                    ),
                    const SizedBox(width: gap),
                    Expanded(
                      child: Row(
                        children: [
                          for (var col = 0; col < cols; col++) ...[
                            if (col > 0) const SizedBox(width: gap),
                            Expanded(
                              child: Builder(
                                builder: (context) {
                                  final i = row * cols + col;
                                  final count = rolling.dayTotals[i];
                                  final day = firstDay.add(Duration(days: i));
                                  final tip =
                                      '${DateFormat.yMMMEd().format(day)}: $count slot${count == 1 ? '' : 's'}';
                                  return AspectRatio(
                                    aspectRatio: 1,
                                    child: Tooltip(
                                      message: tip,
                                      child: DecoratedBox(
                                        decoration: BoxDecoration(
                                          color: _cellColor(context, count, maxC),
                                          borderRadius: BorderRadius.circular(5),
                                          border: Border.all(
                                            color: scheme.outlineVariant.withValues(
                                              alpha: count > 0 ? 0.38 : 0.14,
                                            ),
                                          ),
                                        ),
                                        child: const SizedBox.expand(),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }),
          ],
        ),
      ],
    );
  }

  Widget _courtWeekdayBody(
    BuildContext context, {
    required BookingHeatmapMemberMonth data,
    required ColorScheme scheme,
    required Color variant,
  }) {
    final monthLabel = DateFormat.yMMMM().format(DateTime(data.year, data.month));
    final maxC = _maxCountMonth(data);
    const labelColWidth = _labelColWidth;
    const gap = _cellGap;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          monthLabel,
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w700,
                color: scheme.onSurface,
                height: 1.25,
              ),
        ),
        const SizedBox(height: 10),
        Text(
          'Rows are courts; columns are weekdays. Shows how often you play each court on each weekday this month — good for spotting favourites.',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(color: variant, height: 1.35),
        ),
        const SizedBox(height: _sectionGap),
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            const SizedBox(width: labelColWidth),
            const SizedBox(width: gap),
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  for (var w = 0; w < 7; w++) ...[
                    if (w > 0) const SizedBox(width: gap),
                    Expanded(
                      child: Center(
                        child: Text(
                          _weekdayLabels[w],
                          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                color: variant,
                                fontWeight: FontWeight.w600,
                              ),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        for (var courtIdx = 0; courtIdx < data.courtWeekdayCounts.length; courtIdx++) ...[
          if (courtIdx > 0) const SizedBox(height: gap),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: labelColWidth,
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    'Court ${courtIdx + 1}',
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                          color: variant,
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                ),
              ),
              const SizedBox(width: gap),
              Expanded(
                child: Row(
                  children: [
                    for (var w = 0; w < 7; w++) ...[
                      if (w > 0) const SizedBox(width: gap),
                      Expanded(
                        child: Builder(
                          builder: (context) {
                            final count = data.courtWeekdayCounts[courtIdx][w];
                            final tooltip =
                                'Court ${courtIdx + 1}, ${_weekdayNames[w]}: $count slot${count == 1 ? '' : 's'} in $monthLabel';
                            return AspectRatio(
                              aspectRatio: 1,
                              child: Tooltip(
                                message: tooltip,
                                child: DecoratedBox(
                                  decoration: BoxDecoration(
                                    color: _cellColor(context, count, maxC),
                                    borderRadius: BorderRadius.circular(5),
                                    border: Border.all(
                                      color: scheme.outlineVariant.withValues(
                                        alpha: count > 0 ? 0.38 : 0.14,
                                      ),
                                    ),
                                  ),
                                  child: const SizedBox.expand(),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final variant = Theme.of(context).colorScheme.onSurfaceVariant;
    final scheme = Theme.of(context).colorScheme;

    return BlocBuilder<BookingHeatmapBloc, BookingHeatmapState>(
      buildWhen: (p, c) =>
          p.status != c.status ||
          p.memberMonth != c.memberMonth ||
          p.memberRolling4Week != c.memberRolling4Week ||
          p.mode != c.mode,
      builder: (context, state) {
        final status = state.status.status;

        Widget cardBody;
        if (status == BaseLoadingStatus.initial || status == BaseLoadingStatus.loading) {
          cardBody = const Padding(
            padding: EdgeInsets.symmetric(vertical: 36),
            child: Center(child: CircularProgressIndicator.adaptive()),
          );
        } else if (status == BaseLoadingStatus.loadingFailed) {
          final msg = state.status.message?.trim();
          cardBody = Padding(
            padding: const EdgeInsets.all(22),
            child: Text(
              (msg != null && msg.isNotEmpty) ? msg : 'Could not load booking activity',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: DupraColors.error),
            ),
          );
        } else {
          final month = state.memberMonth;
          final rolling = state.memberRolling4Week;
          if (month == null || rolling == null) {
            cardBody = const SizedBox.shrink();
          } else {
            cardBody = Padding(
              padding: _cardPadding,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SegmentedButton<_MemberHeatTab>(
                    expandedInsets: EdgeInsets.zero,
                    style: SegmentedButton.styleFrom(
                      visualDensity: VisualDensity.comfortable,
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                    ),
                    segments: const [
                      ButtonSegment(
                        value: _MemberHeatTab.rolling28,
                        label: Text('Last 4 weeks'),
                        icon: Icon(Icons.calendar_view_month_outlined, size: 18),
                      ),
                      ButtonSegment(
                        value: _MemberHeatTab.courtWeekday,
                        label: Text('Court & weekday'),
                        icon: Icon(Icons.grid_on_outlined, size: 18),
                      ),
                    ],
                    selected: {_tab},
                    onSelectionChanged: (next) {
                      setState(() => _tab = next.first);
                    },
                  ),
                  const SizedBox(height: 22),
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 200),
                    child: KeyedSubtree(
                      key: ValueKey<_MemberHeatTab>(_tab),
                      child: _tab == _MemberHeatTab.rolling28
                          ? _rollingBody(context, rolling: rolling, scheme: scheme, variant: variant)
                          : _courtWeekdayBody(context, data: month, scheme: scheme, variant: variant),
                    ),
                  ),
                ],
              ),
            );
          }
        }

        return DupraSection(
          title: 'Your court activity',
          cardChild: cardBody,
        );
      },
    );
  }
}
