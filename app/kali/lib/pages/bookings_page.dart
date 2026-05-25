import 'dart:async';

import 'package:app_bloc/app_bloc.dart';
import 'package:client_models/client_models.dart';
import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';
import 'package:web/web.dart' as web;

import '../bookings/bookings_member_error_messages.dart';
import '../bookings/member_booking_grid.dart';
import '../utils/admin_bookings_helpers.dart';
import '../utils/booking_slot_label.dart';

/// Member bookings — desktop schedule table (Dupra slot rules, larger layout).
class BookingsPage extends StatefulComponent {
  const BookingsPage({super.key});

  @override
  State<StatefulComponent> createState() => _BookingsPageState();
}

class _BookingsPageState extends State<BookingsPage> {
  late final BookingsBloc _bloc;
  StreamSubscription<BookingsState>? _sub;

  MemberBookingTimeBand _band = MemberBookingTimeBand.peak;

  bool _slotActionBusy = false;
  String? _flashOk;
  String? _flashError;

  @override
  void initState() {
    super.initState();
    _bloc = appBlocSl<BookingsBloc>();
    _sub = _bloc.stream.listen((_) {
      if (mounted) setState(() {});
    });
    Future<void>.microtask(() {
      if (mounted) {
        _bloc.add(BookingsEvent.onLoadBookings(forDate: adminBookingsCalendarTodayLocal()));
      }
    });
  }

  void _setFlashOk(String msg) => setState(() {
    _flashOk = msg;
    _flashError = null;
  });

  void _setFlashErr(String msg) => setState(() {
    _flashError = msg;
    _flashOk = null;
  });

  void _clearFlashes() => setState(() {
    _flashOk = null;
    _flashError = null;
  });

  /// Jaspr binds [InputType.date] to [`HTMLInputElement.valueAsDate`], i.e. [DateTime], not `String`.
  void _onBookingDaySelected(DateTime? picked) {
    if (_slotActionBusy || picked == null) return;
    final day = adminCalendarDayFromDatePickerValue(picked);
    _bloc.add(BookingsEvent.onLoadBookings(forDate: day));
  }

  Future<void> _onOpenCourtTap({
    required DateTime selectedDate,
    required int slotStartMinutes,
    required int courtNo,
  }) async {
    if (_slotActionBusy) return;

    final bookingDate = DateTime.utc(
      selectedDate.year,
      selectedDate.month,
      selectedDate.day,
      slotStartMinutes ~/ 60,
      slotStartMinutes % 60,
    );

    setState(() => _slotActionBusy = true);
    _clearFlashes();
    try {
      await _bloc.createBooking(
        booking: CreateBookingDto(courtNo: courtNo, bookingDate: bookingDate),
      );
      if (!mounted) return;
      _bloc.add(BookingsEvent.onLoadBookings(forDate: selectedDate));
      final dayHeading = formatCalendarDayHeading(adminBookingsCalendarDay(selectedDate));
      _setFlashOk('Booked court $courtNo on $dayHeading at ${formatSlotRangeLabel(slotStartMinutes)}.');
    } catch (e) {
      if (!mounted) return;
      _setFlashErr(MemberBookingsErrorMessages.createBooking(e));
    } finally {
      if (mounted) setState(() => _slotActionBusy = false);
    }
  }

  Future<void> _onDeleteMineBooking(BookingDto booking, DateTime selectedDate) async {
    final id = booking.objectId?.trim();
    if (id == null || id.isEmpty || _slotActionBusy) return;

    final dayUi = formatCalendarDayHeading(adminBookingsCalendarDay(selectedDate));
    final ok = web.window.confirm('Delete your booking on $dayUi?');
    if (!ok) return;

    setState(() => _slotActionBusy = true);
    _clearFlashes();
    try {
      await _bloc.deleteBooking(bookingId: id);
      if (!mounted) return;
      _bloc.add(BookingsEvent.onLoadBookings(forDate: selectedDate));
      _setFlashOk('Booking deleted ($dayUi).');
    } catch (e) {
      if (!mounted) return;
      _setFlashErr(MemberBookingsErrorMessages.deleteBooking(e));
    } finally {
      if (mounted) setState(() => _slotActionBusy = false);
    }
  }

  void _onBookedCellTap(BookingDto b, int slotStartMinutes, int courtNo) {
    final dn = b.displayName?.trim();
    final name = (dn != null && dn.isNotEmpty) ? dn : 'Booked';
    final slot = formatSlotRangeLabel(slotStartMinutes);
    web.window.alert('$name · Court $courtNo · $slot');
  }

  Component _courtCell({
    required DateTime selectedDate,
    required int slotStartMinutes,
    required int courtNo,
    required BookingDto? booking,
    required BaseLoadingStatus loadStatus,
  }) {
    return _CourtCellInner(
      slotStartMinutes: slotStartMinutes,
      courtNo: courtNo,
      booking: booking,
      loadStatus: loadStatus,
      disabled: _slotActionBusy,
      onBookedTap: booking != null ? () => _onBookedCellTap(booking, slotStartMinutes, courtNo) : null,
      onDeleteMine: booking != null && booking.isMine && (booking.objectId?.trim().isNotEmpty ?? false)
          ? () => _onDeleteMineBooking(booking, selectedDate)
          : null,
      onOpenTap: booking == null
          ? () => _onOpenCourtTap(selectedDate: selectedDate, slotStartMinutes: slotStartMinutes, courtNo: courtNo)
          : null,
    );
  }

  Component _bandsRow() {
    return div(classes: 'member-band-row', [
      for (final b in MemberBookingTimeBand.values) ...[
        button(
          type: ButtonType.button,
          classes: _band == b ? 'member-band-btn member-band-btn-active' : 'member-band-btn',
          disabled: _slotActionBusy,
          events: {'click': (_) => setState(() => _band = b)},
          [Component.text('${b.label} (${b.rangeLabel})')],
        ),
      ],
    ]);
  }

  Component _scheduleTable({
    required DateTime selectedDate,
    required Map<(int, int), BookingDto> lookup,
    required List<int> slots,
    required BaseLoadingStatus loadStatus,
  }) {
    return div(classes: 'member-table-shell', [
      table(classes: 'member-schedule-table', [
        thead(classes: 'member-thead', [
          tr(classes: 'member-schedule-head-row', [
            th(
              classes: 'member-th member-th-slot',
              attributes: {'scope': 'col'},
              [Component.text('Time')],
            ),
            th(classes: 'member-th member-th-court member-th-court-1', [
              span(classes: 'member-th-court-inner', [Component.text('Court 1')]),
            ]),
            th(classes: 'member-th member-th-court member-th-court-2', [
              span(classes: 'member-th-court-inner', [Component.text('Court 2')]),
            ]),
            th(classes: 'member-th member-th-court member-th-court-3', [
              span(classes: 'member-th-court-inner', [Component.text('Court 3')]),
            ]),
          ]),
        ]),
        tbody(classes: 'member-tbody', [
          for (final slot in slots)
            tr(classes: 'member-schedule-slot-row', [
              td(classes: 'member-td member-td-time', [
                span(classes: 'member-slot-range-label', [Component.text(formatSlotRangeLabel(slot))]),
              ]),
              for (var court = 1; court <= 3; court++)
                td(classes: 'member-td member-td-court', [
                  div(classes: 'member-td-inner', [
                    _courtCell(
                      selectedDate: selectedDate,
                      slotStartMinutes: slot,
                      courtNo: court,
                      booking: lookup[(slot, court)],
                      loadStatus: loadStatus,
                    ),
                  ]),
                ]),
            ]),
        ]),
      ]),
    ]);
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
    final errMsg = state.status.message?.trim();

    late final Component bodyChild;
    if (loadingStatus == BaseLoadingStatus.initial || loadingStatus == BaseLoadingStatus.loading) {
      bodyChild = div(classes: 'member-body-center', [
        p(classes: 'member-loading-text', [Component.text('Loading bookings…')]),
      ]);
    } else if (loadingStatus == BaseLoadingStatus.loadingFailed) {
      bodyChild = div(classes: 'member-body-center', [
        p(classes: 'member-error-text', [
          Component.text((errMsg != null && errMsg.isNotEmpty) ? errMsg : 'Failed to load bookings'),
        ]),
      ]);
    } else {
      final lookup = memberBookingBySlotAndCourt(bookings: state.bookings, selectedDay: state.selectedDate);
      final slots = memberSlotStartsForBand(_band);

      bodyChild = slots.isEmpty
          ? div(classes: 'member-body-center', [
              p(classes: 'member-empty-band', [Component.text('No slots for this band.')]),
            ])
          : _scheduleTable(
              selectedDate: state.selectedDate,
              lookup: lookup,
              slots: slots,
              loadStatus: loadingStatus,
            );
    }

    final dayHeading = formatCalendarDayHeading(adminBookingsCalendarDay(state.selectedDate));

    return div(classes: 'bookings-page member-bookings-page', [
      if (_flashOk != null)
        div(classes: 'bookings-flash bookings-flash-ok member-flash-adjust', [Component.text(_flashOk!)]),
      if (_flashError != null)
        div(classes: 'bookings-flash bookings-flash-err member-flash-adjust', [Component.text(_flashError!)]),
      div(classes: 'member-toolbar-panel', [
        div(classes: 'member-page-heading', [
          h1(classes: 'member-page-title', [Component.text(dayHeading)]),
          p(classes: 'member-page-lead', [
            Component.text(
              'Tap a free slot to book. Your bookings show a remove control. Fixtures are under Admin bookings.',
            ),
          ]),
        ]),
        div(classes: 'member-toolbar-inner', [
          div(classes: 'member-toolbar-date', [
            label(classes: 'member-field-label', [Component.text('Date')]),
            input<DateTime?>(
              classes: 'member-date-input bookings-date-input',
              type: InputType.date,
              value: adminBookingsDateInputValue(state.selectedDate),
              disabled: _slotActionBusy,
              onChange: _onBookingDaySelected,
            ),
          ]),
          _bandsRow(),
        ]),
      ]),
      bodyChild,
      if (_slotActionBusy && loadingStatus == BaseLoadingStatus.loadingSuccess)
        div(classes: 'bookings-busy-overlay member-busy-soft', [Component.text('Updating…')]),
    ]);
  }
}

/// Single court slot cell (desktop table cell).
class _CourtCellInner extends StatelessComponent {
  const _CourtCellInner({
    required this.slotStartMinutes,
    required this.courtNo,
    required this.booking,
    required this.loadStatus,
    required this.disabled,
    this.onOpenTap,
    this.onBookedTap,
    this.onDeleteMine,
  });

  final int slotStartMinutes;
  final int courtNo;
  final BookingDto? booking;
  final BaseLoadingStatus loadStatus;
  final bool disabled;
  final void Function()? onOpenTap;
  final void Function()? onBookedTap;
  final void Function()? onDeleteMine;

  String _firstLetter(String s) {
    final it = s.runes.iterator;
    if (!it.moveNext()) return '?';
    return String.fromCharCode(it.current).toUpperCase();
  }

  String _displayInitials(String raw) {
    final parts = raw.trim().split(RegExp(r'\s+')).where((e) => e.isNotEmpty).toList();
    if (parts.isEmpty) return '?';
    if (parts.length == 1) {
      final s = parts.first;
      if (s.isEmpty) return '?';
      final runes = s.runes.take(2).toList();
      if (runes.isEmpty) return '?';
      if (runes.length == 1) return String.fromCharCode(runes.single).toUpperCase();
      return runes.map(String.fromCharCode).join().toUpperCase();
    }
    final a = _firstLetter(parts.first);
    final b = _firstLetter(parts.last);
    return '$a$b';
  }

  Component _avatar(String name, String? picUrl) {
    final initials = _displayInitials(name);
    if (picUrl != null && picUrl.trim().isNotEmpty) {
      final safe = picUrl.trim();
      return img(classes: 'member-cell-avatar-img', src: safe, alt: '');
    }
    return span(classes: 'member-cell-avatar', [Component.text(initials)]);
  }

  @override
  Component build(BuildContext context) {
    final b = booking;
    final canInteract = !disabled && loadStatus == BaseLoadingStatus.loadingSuccess;

    if (b == null) {
      return button(
        classes: 'member-court-inner member-slot-open-btn',
        type: ButtonType.button,
        disabled: disabled || !canInteract,
        attributes: {'title': 'Book court $courtNo for ${formatSlotRangeLabel(slotStartMinutes)}'},
        events: !canInteract ? null : {'click': (_) => onOpenTap?.call()},
        [
          span(classes: 'member-cell-open-glyph', []),
          span(classes: 'member-cell-open-strong', [Component.text('Available')]),
          span(classes: 'member-cell-open-hint', [Component.text('Click to book')]),
        ],
      );
    }

    final dn = b.displayName?.trim();
    final name = (dn != null && dn.isNotEmpty) ? dn : 'Booked';
    final mine = b.isMine;
    final gid = b.groupBookingId;
    final showAvatar = gid == null || gid <= 0;
    final pic = (b.profilePictureUrl?.trim().isNotEmpty ?? false) ? b.profilePictureUrl : b.profile?.profilePictureUrl;

    final courtClass = mine
        ? 'member-court-inner member-slot-booked member-book-court-$courtNo member-booked-mine'
        : 'member-court-inner member-slot-booked member-book-court-$courtNo';

    final inner = div(classes: 'member-booked-inner', [
      if (mine) span(classes: 'member-mine-pill', [Component.text('You')]),
      div(classes: 'member-booked-body', [
        if (showAvatar) _avatar(name, pic),
        span(classes: 'member-booked-name', [Component.text(name)]),
      ]),
    ]);

    final tapLayer = button(
      type: ButtonType.button,
      classes: courtClass,
      disabled: disabled,
      attributes: {'title': '$name · Court $courtNo'},
      events: !canInteract ? null : {'click': (_) => onBookedTap?.call()},
      [inner],
    );

    if (onDeleteMine != null) {
      return div(classes: 'member-booked-cell-wrap', [
        tapLayer,
        button(
          type: ButtonType.button,
          classes: 'member-mine-delete',
          disabled: disabled,
          attributes: {'aria-label': 'Remove booking'},
          events: disabled ? null : {'click': (_) => onDeleteMine!()},
          [Component.text('×')],
        ),
      ]);
    }

    return tapLayer;
  }
}
