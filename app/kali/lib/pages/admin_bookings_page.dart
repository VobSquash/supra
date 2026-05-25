import 'dart:async';

import 'package:app_bloc/app_bloc.dart';
import 'package:client_models/client_models.dart';
import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';
import 'package:middleware/middleware_clients.dart';
import 'package:web/web.dart' as web;

import '../utils/admin_bookings_helpers.dart';
import '../utils/booking_slot_label.dart';

/// Admin bookings: fixture blocks + day list — same contracts as Dupra [`AdminBookingsPlaceholderPage`].
class AdminBookingsPage extends StatefulComponent {
  const AdminBookingsPage({super.key});

  @override
  State<StatefulComponent> createState() => _AdminBookingsPageState();
}

class _AdminBookingsPageState extends State<AdminBookingsPage> {
  late final BookingsBloc _bloc;
  StreamSubscription<BookingsState>? _sub;

  final List<bool> _courtSelected = [false, false, false];

  DateTime _selectedDate = adminBookingsCalendarTodayLocal();
  String _titleText = '';

  late int _slotStartMin;
  late int _slotEndMin;

  bool _busy = false;
  String? _flashOk;
  String? _flashError;

  List<int> get _allSlotStarts => BookingSlotSchedule.allSlotStartsMinutes();

  @override
  void initState() {
    super.initState();
    _slotStartMin = 14 * 60 + 15;
    _slotEndMin = 14 * 60 + 15;

    _bloc = appBlocSl<BookingsBloc>();
    _sub = _bloc.stream.listen((_) {
      if (mounted) setState(() {});
    });
    Future<void>.microtask(() {
      if (mounted) _reloadList();
    });
  }

  void _reloadList() {
    _bloc.add(BookingsEvent.onLoadBookings(forDate: _selectedDate));
  }

  void _setFlashOk(String msg) => setState(() {
    _flashOk = msg;
    _flashError = null;
  });

  void _setFlashErr(String msg) => setState(() {
    _flashError = msg;
    _flashOk = null;
  });

  List<int> get _endSlotChoices {
    final starts = _allSlotStarts.where((m) => m >= _slotStartMin).toList();
    return starts.isEmpty ? [_slotStartMin] : starts;
  }

  int get _effectiveEndMin {
    final choices = _endSlotChoices;
    if (choices.contains(_slotEndMin)) return _slotEndMin;
    return choices.last;
  }

  Future<void> _createBlock() async {
    if (_busy) return;
    if (_effectiveEndMin < _slotStartMin) {
      _setFlashErr('End time must be on or after start time.');
      return;
    }
    if (!_courtSelected.any((c) => c)) {
      _setFlashErr('Select at least one court.');
      return;
    }
    final title = _titleText.trim();
    if (title.isEmpty) {
      _setFlashErr('Enter a booking title.');
      return;
    }

    setState(() => _busy = true);
    try {
      await _bloc.createAdminBookings(
        dto: CreateAdminBookingDto(
          bookingTitle: title,
          selectedDate: _selectedDate,
          timeslotStart: adminBookingsHhmm(_slotStartMin),
          timeslotEnd: adminBookingsHhmm(_effectiveEndMin),
          court1: _courtSelected[0],
          court2: _courtSelected[1],
          court3: _courtSelected[2],
        ),
      );
      if (!mounted) return;
      _reloadList();
      _setFlashOk('Admin block created for ${formatCalendarDayHeading(_selectedDate)}.');
    } catch (e) {
      if (!mounted) return;
      _setFlashErr(adminBookingsAdminErrorMessage(e));
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _deleteRow(BookingDto b) async {
    if (_busy) return;
    final id = b.objectId?.trim();
    if (id == null || id.isEmpty) return;
    final bd = b.bookingDate;
    final ok = web.window.confirm(
      bd != null
          ? 'Delete this booking for ${formatCalendarDayHeading(DateTime(bd.year, bd.month, bd.day))}?'
          : 'Delete this booking?',
    );
    if (!ok || !mounted) return;
    setState(() => _busy = true);
    try {
      await _bloc.deleteBookingAsAdmin(bookingId: id);
      if (!mounted) return;
      _reloadList();
      _setFlashOk('Booking deleted.');
    } catch (e) {
      if (!mounted) return;
      _setFlashErr(adminBookingsAdminErrorMessage(e));
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _clearDay() async {
    if (_busy) return;
    final dayUi = formatCalendarDayHeading(_selectedDate);
    final ok = web.window.confirm(
      'Delete ALL bookings on $dayUi?\nThis cannot be undone.',
    );
    if (!ok || !mounted) return;
    setState(() => _busy = true);
    try {
      await _bloc.deleteAllBookingsForDateAsAdmin(forDate: _selectedDate);
      if (!mounted) return;
      _reloadList();
      _setFlashOk('All bookings removed for $dayUi.');
    } catch (e) {
      if (!mounted) return;
      _setFlashErr(adminBookingsAdminErrorMessage(e));
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  /// Jaspr binds [InputType.date] to [`HTMLInputElement.valueAsDate`], i.e. [DateTime], not `String`.
  void _onPickDate(DateTime? picked) {
    if (_busy || picked == null) return;
    setState(() {
      _selectedDate = adminCalendarDayFromDatePickerValue(picked);
    });
    _reloadList();
  }

  Component _slotSelect({
    required String caption,
    required List<int> items,
    required int current,
    required void Function(int) onPick,
    bool disabled = false,
  }) {
    return div(classes: 'bookings-field', [
      label(classes: 'bookings-field-label', [Component.text(caption)]),
      select(
        classes: 'bookings-select',
        disabled: disabled,
        value: '$current',
        onChange: disabled
            ? null
            : (list) {
                final raw = list.isEmpty ? null : list.first;
                final v = int.tryParse(raw ?? '');
                if (v != null) onPick(v);
              },
        [
          for (final m in items) option(value: '$m', [Component.text(formatSlotRangeLabel(m))]),
        ],
      ),
    ]);
  }

  @override
  void dispose() {
    _sub?.cancel();
    _bloc.close();
    super.dispose();
  }

  Component _bookingListBody(BookingsState state, BaseLoadingStatus loadingStatus, String? errMsg) {
    if (loadingStatus == BaseLoadingStatus.loading || loadingStatus == BaseLoadingStatus.initial) {
      return div(classes: 'bookings-list-status', [Component.text('Loading bookings…')]);
    }
    if (loadingStatus == BaseLoadingStatus.loadingFailed) {
      final m = errMsg?.trim();
      return div(classes: 'bookings-list-error', [
        Component.text(m != null && m.isNotEmpty ? m : 'Failed to load bookings'),
      ]);
    }

    final rows = state.bookings;
    if (rows.isEmpty) {
      return div(classes: 'bookings-empty', [
        p(classes: 'bookings-empty-title', [Component.text('No bookings on this date')]),
        p(classes: 'bookings-empty-hint', [
          Component.text('Create a block above or pick another day.'),
        ]),
      ]);
    }

    return div(classes: 'bookings-row-list', [
      for (final b in rows)
        div(classes: 'bookings-row', [
          div(classes: 'bookings-row-bar ${adminBookingsCourtAccentClass(b.courtNo ?? 0)}', []),
          div(classes: 'bookings-row-main', [
            p(classes: 'bookings-row-title', [Component.text(b.displayName ?? '—')]),
            p(classes: 'bookings-row-meta', [
              Component.text(
                'Court ${b.courtNo ?? 0} · ${adminBookingsFormatWallUtc(b.bookingDate)} · '
                'Group ${b.groupBookingId ?? 0}',
              ),
            ]),
          ]),
          button(
            type: ButtonType.button,
            classes: 'bookings-row-delete',
            disabled: _busy,
            attributes: {'title': 'Delete booking'},
            events: {'click': (_) => _deleteRow(b)},
            [Component.text('Delete')],
          ),
        ]),
    ]);
  }

  @override
  Component build(BuildContext context) {
    final state = _bloc.state;
    final loadingStatus = state.status.status;

    final endChoices = _endSlotChoices;
    final endCur = endChoices.contains(_slotEndMin) ? _slotEndMin : endChoices.last;
    final timeSummary =
        '${adminBookingsHhmm(_slotStartMin)} → ${adminBookingsHhmm(endCur)} · '
        '${formatSlotRangeLabel(_slotStartMin)}–${formatSlotRangeLabel(endCur)}';

    final listSection = _bookingListBody(state, loadingStatus, state.status.message);

    return div(classes: 'bookings-page', [
      if (_flashOk != null) div(classes: 'bookings-flash bookings-flash-ok', [Component.text(_flashOk!)]),
      if (_flashError != null) div(classes: 'bookings-flash bookings-flash-err', [Component.text(_flashError!)]),

      div(classes: 'bookings-hero', [
        p(classes: 'bookings-lead', [
          Component.text(
            'Fixture blocks and daily list share the Dupra admin API. Pick a date, add a titled block across courts '
            '/ slots, then review or delete rows below.',
          ),
        ]),
      ]),

      div(classes: 'bookings-card', [
        h2(classes: 'bookings-section-title', [Component.text('Fixture block')]),
        div(classes: 'bookings-card-body', [
          div(classes: 'bookings-field', [
            label(classes: 'bookings-field-label', [Component.text('Title')]),
            input<String>(
              classes: 'bookings-text-input',
              type: InputType.text,
              value: _titleText,
              disabled: _busy,
              attributes: {'placeholder': 'e.g. Club night, ladder final', 'autocomplete': 'off'},
              onInput: (v) => setState(() => _titleText = v),
            ),
          ]),
          div(classes: 'bookings-field', [
            label(classes: 'bookings-field-label', [Component.text('Fixture date')]),
            input<DateTime?>(
              classes: 'bookings-date-input',
              type: InputType.date,
              value: adminBookingsDateInputValue(_selectedDate),
              disabled: _busy,
              onChange: _onPickDate,
            ),
          ]),
          p(classes: 'bookings-mini-heading', [Component.text('Time range')]),
          p(classes: 'bookings-time-summary', [Component.text(timeSummary)]),
          div(classes: 'bookings-slot-pair', [
            div(classes: 'bookings-slot-pair-slot', [
              _slotSelect(
                caption: 'From',
                items: _allSlotStarts,
                current: _slotStartMin,
                disabled: _busy,
                onPick: (v) => setState(() {
                  _slotStartMin = v;
                  if (_slotEndMin < _slotStartMin) {
                    _slotEndMin = _slotStartMin;
                  }
                }),
              ),
            ]),
            div(classes: 'bookings-slot-pair-slot', [
              _slotSelect(
                caption: 'To (inclusive)',
                items: endChoices,
                current: endCur,
                disabled: _busy,
                onPick: (v) => setState(() => _slotEndMin = v),
              ),
            ]),
          ]),
          p(classes: 'bookings-mini-heading', [Component.text('Courts')]),
          div(classes: 'bookings-courts', [
            for (var i = 0; i < 3; i++)
              label(
                classes: 'bookings-court-pill',
                [
                  input<bool>(
                    type: InputType.checkbox,
                    checked: _courtSelected[i],
                    disabled: _busy,
                    onChange: _busy ? null : (v) => setState(() => _courtSelected[i] = v),
                  ),
                  Component.text(' Court ${i + 1}'),
                ],
              ),
          ]),
          button(
            type: ButtonType.button,
            classes: 'bookings-submit',
            disabled: _busy,
            events: {'click': (_) => _createBlock()},
            [Component.text(_busy ? 'Working…' : 'Create block')],
          ),
        ]),
      ]),
      div(classes: 'bookings-list-shell', [
        div(classes: 'bookings-list-header', [
          h2(classes: 'bookings-list-heading', [Component.text('Bookings this day')]),
          button(
            type: ButtonType.button,
            classes: 'bookings-clear-day',
            disabled: _busy,
            attributes: {'title': 'Deletes every booking on the selected fixture date'},
            events: {'click': (_) => _clearDay()},
            [Component.text('Clear day')],
          ),
        ]),
        div(classes: 'bookings-list-card', [listSection]),
      ]),
      if (_busy) div(classes: 'bookings-busy-overlay', [Component.text('Please wait…')]),
    ]);
  }
}
