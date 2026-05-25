import 'dart:async';

import 'package:app_bloc/app_bloc.dart';
import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';

import '../utils/booking_slot_label.dart';

/// Admin **one‑day court grid** aligned with Dupra’s admin court usage card.
class BookingAdminHeatmapPanel extends StatefulComponent {
  const BookingAdminHeatmapPanel({super.key});

  @override
  State<StatefulComponent> createState() => _BookingAdminHeatmapPanelState();
}

class _BookingAdminHeatmapPanelState extends State<BookingAdminHeatmapPanel> {
  late final BookingHeatmapBloc _bloc;
  StreamSubscription<BookingHeatmapState>? _sub;

  DateTime _forDay = _dateOnly(DateTime.now());

  static DateTime _dateOnly(DateTime d) => DateTime(d.year, d.month, d.day);

  @override
  void initState() {
    super.initState();
    _bloc = appBlocSl<BookingHeatmapBloc>();
    _sub = _bloc.stream.listen((_) {
      if (mounted) setState(() {});
    });
    Future<void>.microtask(() {
      if (mounted) {
        _bloc.add(BookingHeatmapEvent.loadAdminDay(forDay: _forDay));
      }
    });
  }

  void _shiftDay(int deltaDays) {
    setState(() {
      _forDay = _dateOnly(_forDay.add(Duration(days: deltaDays)));
    });
    _bloc.add(BookingHeatmapEvent.loadAdminDay(forDay: _forDay));
  }

  @override
  void dispose() {
    _sub?.cancel();
    _bloc.close();
    super.dispose();
  }

  @override
  Component build(BuildContext context) {
    final state = _bloc.state;
    final loadingStatus = state.status.status;

    Component body;
    if (loadingStatus == BaseLoadingStatus.initial || loadingStatus == BaseLoadingStatus.loading) {
      body = div(classes: 'heatmap-loading', [Component.text('Loading court usage…')]);
    } else if (loadingStatus == BaseLoadingStatus.loadingFailed) {
      final msg = state.status.message?.trim();
      body = div(classes: 'heatmap-error', [
        Component.text(msg != null && msg.isNotEmpty ? msg : 'Could not load court usage.'),
      ]);
    } else {
      final grid = state.adminDayGrid;
      if (grid == null) {
        body = div(classes: 'heatmap-loading', [Component.text('No grid data.')]);
      } else {
        final slots = grid.slotStartMinutes.length;
        final template = '52px repeat($slots, minmax(10px, 14px))';

        body = div(classes: 'heatmap-panel-inner', [
          p(classes: 'heatmap-hint', [
            Component.text(
              'Courts on the side; each column is a 45‑minute slot. Hover a cell for time and booking holder.',
            ),
          ]),
          div(classes: 'heatmap-scroll', [
            div(classes: 'heatmap-rows', [
              for (var courtIdx = 0; courtIdx < grid.occupantLabels.length; courtIdx++)
                div(
                  classes: 'heatmap-slot-row',
                  attributes: {
                    'style':
                        'display:grid;column-gap:3px;row-gap:0;align-items:center;grid-template-columns:$template;',
                  },
                  [
                    div(
                      classes: 'heatmap-court-label',
                      [Component.text('Court ${courtIdx + 1}')],
                    ),
                    ...List<Component>.generate(slots, (si) {
                      final occupant = grid.occupantLabels[courtIdx][si];
                      final booked = occupant != null;
                      final tip = booked
                          ? 'Court ${courtIdx + 1} · '
                                '${formatSlotRangeLabel(grid.slotStartMinutes[si])} · $occupant'
                          : 'Court ${courtIdx + 1} · '
                                '${formatSlotRangeLabel(grid.slotStartMinutes[si])} · Available';
                      final cellClasses = booked
                          ? 'heatmap-cell heatmap-cell-booked'
                          : 'heatmap-cell heatmap-cell-free';
                      // Non-empty subtree so hydration keeps a stable node; invisible char for hit-testing.
                      // Native `title` is flaky on client-only Jaspr patches; `--slot-tip` CSS shows on hover.
                      return div(
                        classes: cellClasses,
                        attributes: {'data-slot-tip': tip, 'title': tip},
                        [Component.text('\u2060')],
                      );
                    }),
                  ],
                ),
            ]),
          ]),
        ]);
      }
    }

    return div(classes: 'heatmap-panel', [
      div(classes: 'heatmap-panel-head', [
        h2(classes: 'heatmap-panel-title', [Component.text('Court usage')]),
        div(classes: 'heatmap-day-nav', [
          button(
            type: ButtonType.button,
            attributes: {'aria-label': 'Previous day'},
            events: {'click': (_) => _shiftDay(-1)},
            [Component.text('‹')],
          ),
          span(classes: 'heatmap-day-label', [Component.text(formatCalendarDayHeading(_forDay))]),
          button(
            type: ButtonType.button,
            attributes: {'aria-label': 'Next day'},
            events: {'click': (_) => _shiftDay(1)},
            [Component.text('›')],
          ),
        ]),
      ]),
      body,
    ]);
  }
}
