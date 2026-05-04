import 'package:app_bloc/app_bloc.dart';
import 'package:client_models/client_models.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../engine/theme/supra_colors.dart';
import '../widgets/profile_avatar.dart';
import 'booking_details_sheet.dart';
import 'booking_schedule.dart';
import 'bookings_accessibility.dart';
import 'bookings_date_sheet.dart';

/// Temporary dev toggle: overrides [useCompactBookingsTimeslotGrid] (text-scale rule).
enum _BookingsLayoutDevMode {
  /// OS text scale decides grid vs stacked (normal behaviour).
  auto,

  /// Force 3-column grid.
  compactGrid,

  /// Force stacked / accessibility layout (one row per court).
  stackedAccessibility,
}

extension _BookingsLayoutDevModeX on _BookingsLayoutDevMode {
  _BookingsLayoutDevMode get next => switch (this) {
    _BookingsLayoutDevMode.auto => _BookingsLayoutDevMode.compactGrid,
    _BookingsLayoutDevMode.compactGrid => _BookingsLayoutDevMode.stackedAccessibility,
    _BookingsLayoutDevMode.stackedAccessibility => _BookingsLayoutDevMode.auto,
  };

  String get label => switch (this) {
    _BookingsLayoutDevMode.auto => 'Auto',
    _BookingsLayoutDevMode.compactGrid => 'Grid',
    _BookingsLayoutDevMode.stackedAccessibility => 'Accessibility',
  };

  IconData get icon => switch (this) {
    _BookingsLayoutDevMode.auto => Icons.auto_awesome_mosaic_outlined,
    _BookingsLayoutDevMode.compactGrid => Icons.view_column_outlined,
    _BookingsLayoutDevMode.stackedAccessibility => Icons.accessibility_new,
  };
}

/// Keeps segment titles on one line; scales down slightly if horizontal space is tight.
Widget _bookingBandSegmentLabel(String text) {
  return FittedBox(
    fit: BoxFit.scaleDown,
    alignment: Alignment.center,
    child: Text(text, maxLines: 1, softWrap: false, textAlign: TextAlign.center),
  );
}

class BookingsTestPage extends StatefulWidget {
  const BookingsTestPage({super.key, this.nested = false});

  /// When true, omits [Scaffold]/[AppBar] so a parent shell can host this page.
  final bool nested;

  @override
  State<BookingsTestPage> createState() => _BookingsTestPageState();
}

class _BookingsTestPageState extends State<BookingsTestPage> {
  BookingTimeBand _band = BookingTimeBand.peak;
  bool _creatingBooking = false;

  /// Dev-only: cycle with FAB (auto → grid → accessibility).
  _BookingsLayoutDevMode _layoutDevMode = _BookingsLayoutDevMode.auto;

  @override
  void initState() {
    super.initState();
    final today = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
    context.read<BookingsBloc>().add(BookingsEvent.onLoadBookings(forDate: today));
  }

  void _nudgeDay(int deltaDays) {
    final b = context.read<BookingsBloc>();
    final d = b.state.selectedDate;
    final start = DateTime(d.year, d.month, d.day);
    final next = start.add(Duration(days: deltaDays));
    b.add(BookingsEvent.onLoadBookings(forDate: next));
  }

  Future<void> _pickDate() async {
    final bloc = context.read<BookingsBloc>();
    final picked = await showBookingsDatePickerSheet(context, selectedDate: bloc.state.selectedDate);
    if (picked != null && mounted) {
      context.read<BookingsBloc>().add(BookingsEvent.onLoadBookings(forDate: picked));
    }
  }

  List<Widget> get _dateActions => [
    IconButton(icon: const Icon(Icons.chevron_left), tooltip: 'Previous day', onPressed: () => _nudgeDay(-1)),
    IconButton(icon: const Icon(Icons.calendar_today_outlined), tooltip: 'Pick date', onPressed: _pickDate),
    IconButton(icon: const Icon(Icons.chevron_right), tooltip: 'Next day', onPressed: () => _nudgeDay(1)),
  ];

  Future<void> _onOpenCourtTap({
    required DateTime selectedDate,
    required int slotStartMinutes,
    required int courtNo,
  }) async {
    if (_creatingBooking) return;

    final bookingDate = DateTime.utc(
      selectedDate.year,
      selectedDate.month,
      selectedDate.day,
      slotStartMinutes ~/ 60,
      slotStartMinutes % 60,
    );

    setState(() => _creatingBooking = true);
    try {
      await context.read<BookingsBloc>().createBooking(
        booking: CreateBookingDto(courtNo: courtNo, bookingDate: bookingDate),
      );
      if (!mounted) return;
      context.read<BookingsBloc>().add(BookingsEvent.onLoadBookings(forDate: selectedDate));
      final dayUi = DateTime(selectedDate.year, selectedDate.month, selectedDate.day).formateDateForUi();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Booked court $courtNo on $dayUi at ${formatSlotRangeLabel(slotStartMinutes)}.'),
        ),
      );
    } catch (error) {
      if (!mounted) return;
      final msg = _bookingCreateErrorMessage(error);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
    } finally {
      if (mounted) {
        setState(() => _creatingBooking = false);
      }
    }
  }

  bool _useCompactGridForLayout(BuildContext context) {
    switch (_layoutDevMode) {
      case _BookingsLayoutDevMode.auto:
        return useCompactBookingsTimeslotGrid(context);
      case _BookingsLayoutDevMode.compactGrid:
        return true;
      case _BookingsLayoutDevMode.stackedAccessibility:
        return false;
    }
  }

  void _cycleLayoutDevMode() {
    setState(() => _layoutDevMode = _layoutDevMode.next);
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Bookings layout: ${_layoutDevMode.label}'), duration: const Duration(seconds: 2)),
    );
  }

  Widget _layoutDevFab() {
    return FloatingActionButton.small(
      heroTag: 'bookings_layout_dev_fab',
      tooltip: 'Layout: ${_layoutDevMode.label} (tap to cycle: Auto → Grid → Accessibility)',
      onPressed: _cycleLayoutDevMode,
      child: Icon(_layoutDevMode.icon),
    );
  }

  Future<void> _onDeleteMineBooking(BookingDto booking, DateTime selectedDate) async {
    final id = booking.objectId?.trim();
    if (id == null || id.isEmpty) return;

    final dayUi = DateTime(selectedDate.year, selectedDate.month, selectedDate.day).formateDateForUi();
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete booking?'),
        content: Text('This removes only this booking on $dayUi. You cannot undo this action.'),
        actions: [
          TextButton(onPressed: () => Navigator.of(context).pop(false), child: const Text('Cancel')),
          FilledButton(onPressed: () => Navigator.of(context).pop(true), child: const Text('Delete')),
        ],
      ),
    );

    if (!mounted || shouldDelete != true) return;

    setState(() => _creatingBooking = true);
    try {
      await context.read<BookingsBloc>().deleteBooking(bookingId: id);
      if (!mounted) return;
      context.read<BookingsBloc>().add(BookingsEvent.onLoadBookings(forDate: selectedDate));
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Booking deleted ($dayUi).')));
    } catch (error) {
      if (!mounted) return;
      final msg = _bookingDeleteErrorMessage(error);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
    } finally {
      if (mounted) {
        setState(() => _creatingBooking = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final body = BlocBuilder<BookingsBloc, BookingsState>(
      builder: (context, state) {
        final status = state.status.status;
        final message = state.status.message?.trim();

        if (status == BaseLoadingStatus.loading) {
          return const Center(child: CircularProgressIndicator.adaptive());
        }

        if (status == BaseLoadingStatus.loadingFailed) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                message?.isNotEmpty == true ? message! : 'Failed to load bookings',
                textAlign: TextAlign.center,
              ),
            ),
          );
        }

        final lookup = bookingBySlotAndCourt(bookings: state.bookings, selectedDay: state.selectedDate);
        final slots = CourtSchedule.slotStartsForBand(_band);
        final useCompactGrid = _useCompactGridForLayout(context);

        return Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
                  child: BookingsDateSelectorTile(selectedDate: state.selectedDate, onTap: _pickDate),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: SegmentedButton<BookingTimeBand>(
                    showSelectedIcon: false,
                    segments: [
                      ButtonSegment<BookingTimeBand>(
                        value: BookingTimeBand.peak,
                        label: _bookingBandSegmentLabel('Peak'),
                        tooltip: 'Peak · ${BookingTimeBand.peak.rangeLabel}',
                      ),
                      ButtonSegment<BookingTimeBand>(
                        value: BookingTimeBand.afternoon,
                        label: _bookingBandSegmentLabel('Afternoon'),
                        tooltip: 'Afternoon · ${BookingTimeBand.afternoon.rangeLabel}',
                      ),
                      ButtonSegment<BookingTimeBand>(
                        value: BookingTimeBand.morning,
                        label: _bookingBandSegmentLabel('Morning'),
                        tooltip: 'Morning · ${BookingTimeBand.morning.rangeLabel}',
                      ),
                    ],
                    selected: {_band},
                    onSelectionChanged: (next) {
                      setState(() => _band = next.first);
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
                  child: Row(
                    children: [
                      Text(
                        _band.rangeLabel,
                        style: Theme.of(
                          context,
                        ).textTheme.labelMedium?.copyWith(color: SupraColors.secondary, fontWeight: FontWeight.w600),
                      ),
                      const Spacer(),
                      Text(
                        [
                          if (useCompactGrid) 'Courts 1–${CourtSchedule.courtCount}',
                          if (_layoutDevMode != _BookingsLayoutDevMode.auto) ' · ${_layoutDevMode.label}',
                        ].join(),
                        style: Theme.of(
                          context,
                        ).textTheme.labelSmall?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: slots.isEmpty
                      ? const Center(child: Text('No slots in this band.'))
                      : ListView.builder(
                          padding: const EdgeInsets.fromLTRB(12, 0, 12, 24),
                          itemCount: slots.length,
                          itemBuilder: (context, index) {
                            final startMin = slots[index];
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 10),
                              child: useCompactGrid
                                  ? _SlotRowCompact(
                                      slotStartMinutes: startMin,
                                      lookup: lookup,
                                      selectedDate: state.selectedDate,
                                      onOpenTap: _onOpenCourtTap,
                                      onDeleteMineBooking: _onDeleteMineBooking,
                                    )
                                  : _SlotRowStacked(
                                      slotStartMinutes: startMin,
                                      lookup: lookup,
                                      selectedDate: state.selectedDate,
                                      onOpenTap: _onOpenCourtTap,
                                      onDeleteMineBooking: _onDeleteMineBooking,
                                    ),
                            );
                          },
                        ),
                ),
              ],
            ),
            if (_creatingBooking)
              Positioned.fill(
                child: ColoredBox(
                  color: Colors.black.withValues(alpha: 0.1),
                  child: const Center(child: CircularProgressIndicator.adaptive()),
                ),
              ),
          ],
        );
      },
    );

    if (widget.nested) {
      return Stack(
        clipBehavior: Clip.none,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [Expanded(child: body)],
          ),
          Positioned(right: 16, bottom: 16, child: _layoutDevFab()),
        ],
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Bookings'), actions: _dateActions),
      body: body,
      floatingActionButton: _layoutDevFab(),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}

String _bookingDeleteErrorMessage(Object error) {
  if (error is DioException) {
    final text = error.error?.toString().trim();
    if (text != null && text.isNotEmpty) return text;
    final message = error.message?.trim();
    if (message != null && message.isNotEmpty) return message;
  }
  final raw = error.toString().trim();
  if (raw.isNotEmpty && raw != 'Exception') return raw;
  return 'Unable to delete this booking.';
}

String _bookingCreateErrorMessage(Object error) {
  if (error is DioException) {
    final text = error.error?.toString().trim();
    if (text != null &&
        (text.contains('bookings_slot_unique_idx') ||
            text.contains('already booked') ||
            text.contains('already exists'))) {
      return 'That slot is already booked.';
    }
    if (text != null && text.contains('already have a booking for this day')) {
      return 'You already have a booking for this day.';
    }
    if (text != null && text.isNotEmpty) return text;
    final message = error.message?.trim();
    if (message != null && message.isNotEmpty) return message;
  }
  final raw = error.toString().trim();
  if (raw.isNotEmpty && raw != 'Exception') return raw;
  return 'Unable to create booking for this slot.';
}

/// Same height for open and booked cells so each row lines up cleanly (compact grid only).
const double _kCourtCellHeight = 118;

class _SlotRowCompact extends StatelessWidget {
  const _SlotRowCompact({
    required this.slotStartMinutes,
    required this.lookup,
    required this.selectedDate,
    required this.onOpenTap,
    required this.onDeleteMineBooking,
  });

  final int slotStartMinutes;
  final Map<(int, int), BookingDto> lookup;
  final DateTime selectedDate;
  final Future<void> Function({required DateTime selectedDate, required int slotStartMinutes, required int courtNo})
  onOpenTap;
  final Future<void> Function(BookingDto booking, DateTime selectedDate) onDeleteMineBooking;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final timeLabel = formatSlotRangeLabel(slotStartMinutes);

    return DecoratedBox(
      decoration: BoxDecoration(
        color: scheme.surfaceContainerHighest.withValues(alpha: 0.45),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: scheme.outlineVariant.withValues(alpha: 0.5)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 86,
              height: _kCourtCellHeight,
              child: Padding(
                padding: const EdgeInsets.only(left: 4),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    timeLabel,
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      fontFeatures: const [FontFeature.tabularFigures()],
                      fontWeight: FontWeight.w700,
                      height: 1.15,
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  for (var court = 1; court <= CourtSchedule.courtCount; court++)
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(left: court == 1 ? 0 : 6),
                        child: Builder(
                          builder: (context) {
                            final b = lookup[(slotStartMinutes, court)];
                            return _CourtCell(
                              courtNo: court,
                              booking: b,
                              compact: true,
                              showCourtLabel: true,
                              onBookedTap: b != null ? () => showBookingDetailsSheet(context, b) : null,
                              onDeleteMine: b != null && b.isMine && (b.objectId?.trim().isNotEmpty ?? false)
                                  ? () => onDeleteMineBooking(b, selectedDate)
                                  : null,
                              onOpenTap: b == null
                                  ? () => onOpenTap(
                                      selectedDate: selectedDate,
                                      slotStartMinutes: slotStartMinutes,
                                      courtNo: court,
                                    )
                                  : null,
                            );
                          },
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Accessibility: large text — one row for the time, then one full-width row per court.
class _SlotRowStacked extends StatelessWidget {
  const _SlotRowStacked({
    required this.slotStartMinutes,
    required this.lookup,
    required this.selectedDate,
    required this.onOpenTap,
    required this.onDeleteMineBooking,
  });

  final int slotStartMinutes;
  final Map<(int, int), BookingDto> lookup;
  final DateTime selectedDate;
  final Future<void> Function({required DateTime selectedDate, required int slotStartMinutes, required int courtNo})
  onOpenTap;
  final Future<void> Function(BookingDto booking, DateTime selectedDate) onDeleteMineBooking;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final timeLabel = formatSlotRangeLabel(slotStartMinutes);

    return DecoratedBox(
      decoration: BoxDecoration(
        color: scheme.surfaceContainerHighest.withValues(alpha: 0.45),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: scheme.outlineVariant.withValues(alpha: 0.5)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              timeLabel,
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontFeatures: const [FontFeature.tabularFigures()],
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 10),
            for (var court = 1; court <= CourtSchedule.courtCount; court++) ...[
              if (court > 1) const SizedBox(height: 8),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 88,
                    child: Text(
                      'Court $court',
                      style: Theme.of(
                        context,
                      ).textTheme.labelLarge?.copyWith(color: scheme.onSurfaceVariant, fontWeight: FontWeight.w600),
                    ),
                  ),
                  Expanded(
                    child: Builder(
                      builder: (context) {
                        final b = lookup[(slotStartMinutes, court)];
                        return _CourtCell(
                          courtNo: court,
                          booking: b,
                          compact: false,
                          showCourtLabel: false,
                          onBookedTap: b != null ? () => showBookingDetailsSheet(context, b) : null,
                          onDeleteMine: b != null && b.isMine && (b.objectId?.trim().isNotEmpty ?? false)
                              ? () => onDeleteMineBooking(b, selectedDate)
                              : null,
                          onOpenTap: b == null
                              ? () => onOpenTap(
                                  selectedDate: selectedDate,
                                  slotStartMinutes: slotStartMinutes,
                                  courtNo: court,
                                )
                              : null,
                        );
                      },
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _CourtCell extends StatelessWidget {
  const _CourtCell({
    required this.courtNo,
    required this.booking,
    required this.compact,
    required this.showCourtLabel,
    this.onBookedTap,
    this.onOpenTap,
    this.onDeleteMine,
  });

  final int courtNo;
  final BookingDto? booking;
  final bool compact;
  final bool showCourtLabel;
  final VoidCallback? onBookedTap;
  final VoidCallback? onOpenTap;
  final VoidCallback? onDeleteMine;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final booked = booking != null;

    if (!booked) {
      final openContent = Row(
        children: [
          Icon(Icons.circle_outlined, size: compact ? 14 : 18, color: SupraColors.success.withValues(alpha: 0.9)),
          const SizedBox(width: 4),
          Text(
            'Open',
            style: Theme.of(
              context,
            ).textTheme.titleSmall?.copyWith(color: SupraColors.success, fontWeight: FontWeight.w600),
          ),
        ],
      );

      if (!compact) {
        final openCard = Material(
          color: scheme.surface.withValues(alpha: 0.65),
          borderRadius: BorderRadius.circular(10),
          child: Padding(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10), child: openContent),
        );
        if (onOpenTap == null) return openCard;
        return InkWell(borderRadius: BorderRadius.circular(10), onTap: onOpenTap, child: openCard);
      }

      final openCard = SizedBox(
        height: _kCourtCellHeight,
        width: double.infinity,
        child: Material(
          color: scheme.surface.withValues(alpha: 0.65),
          borderRadius: BorderRadius.circular(10),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (showCourtLabel)
                  Text(
                    'Court $courtNo',
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(color: scheme.onSurfaceVariant),
                  ),
                if (showCourtLabel) const SizedBox(height: 4),
                openContent,
                const Spacer(),
              ],
            ),
          ),
        ),
      );
      if (onOpenTap == null) return openCard;
      return InkWell(borderRadius: BorderRadius.circular(10), onTap: onOpenTap, child: openCard);
    }

    final b = booking!;
    final dn = b.displayName?.trim();
    final name = (dn != null && dn.isNotEmpty) ? dn : 'Booked';

    final mine = b.isMine;
    final courtFill = SupraColors.courtBookedFill(courtNo);
    final border = mine
        ? Border.all(color: Colors.white.withValues(alpha: 0.5), width: 2)
        : Border.all(color: Colors.black.withValues(alpha: 0.12), width: 1);

    final pic = b.profilePictureUrl?.trim().isNotEmpty == true
        ? b.profilePictureUrl
        : b.profile?.profilePictureUrl;

    final radius = BorderRadius.circular(12);
    final inner = Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
      child: compact
          ? _BookedCompactBody(
              courtNo: courtNo,
              showCourtLabel: showCourtLabel,
              name: name,
              mine: mine,
              imageUrl: pic,
            )
          : _BookedStackedBody(name: name, mine: mine, imageUrl: pic),
    );

    final card = Container(
      decoration: BoxDecoration(borderRadius: radius, border: border),
      child: compact ? SizedBox(height: _kCourtCellHeight, width: double.infinity, child: inner) : inner,
    );

    final bookedBody = onBookedTap != null
        ? InkWell(
            borderRadius: radius,
            onTap: onBookedTap,
            splashColor: Colors.white.withValues(alpha: 0.25),
            highlightColor: Colors.white.withValues(alpha: 0.12),
            child: card,
          )
        : card;

    // M3 applies a surface tint on top of [Material.color]; disable it so court hues read clearly.
    return Material(
      color: courtFill,
      surfaceTintColor: Colors.transparent,
      shadowColor: Colors.transparent,
      elevation: 0,
      borderRadius: radius,
      clipBehavior: Clip.antiAlias,
      child: onDeleteMine == null
          ? bookedBody
          : Stack(
              clipBehavior: Clip.hardEdge,
              children: [
                bookedBody,
                Positioned(
                  top: 6,
                  right: 6,
                  child: _MineBookingDeleteButton(compact: compact, onPressed: onDeleteMine!),
                ),
              ],
            ),
    );
  }
}

/// High-contrast delete control on saturated court colours.
class _MineBookingDeleteButton extends StatelessWidget {
  const _MineBookingDeleteButton({required this.compact, required this.onPressed});

  final bool compact;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final diameter = compact ? 40.0 : 44.0;
    final iconSize = compact ? 20.0 : 22.0;
    return Semantics(
      button: true,
      label: 'Remove booking',
      child: Tooltip(
        message: 'Remove booking',
        child: Material(
          color: Colors.transparent,
          elevation: 2,
          shadowColor: Colors.black.withValues(alpha: 0.45),
          shape: const CircleBorder(),
          child: InkWell(
            customBorder: const CircleBorder(),
            onTap: onPressed,
            splashColor: Colors.white.withValues(alpha: 0.25),
            highlightColor: Colors.white.withValues(alpha: 0.12),
            child: Ink(
              width: diameter,
              height: diameter,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.black.withValues(alpha: 0.52),
                border: Border.all(color: Colors.white.withValues(alpha: 0.42), width: 1.5),
              ),
              child: Center(
                child: Icon(Icons.delete_outline_rounded, size: iconSize, color: Colors.white),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _BookedCompactBody extends StatelessWidget {
  const _BookedCompactBody({
    required this.courtNo,
    required this.showCourtLabel,
    required this.name,
    required this.mine,
    this.imageUrl,
  });

  final int courtNo;
  final bool showCourtLabel;
  final String name;
  final bool mine;
  final String? imageUrl;

  static const Color _onCourt = Color(0xFFFFFFFF);
  static final Color _onCourtMuted = Colors.white.withValues(alpha: 0.88);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (showCourtLabel)
          Row(
            children: [
              Flexible(
                child: Text(
                  'Court $courtNo',
                  style: Theme.of(
                    context,
                  ).textTheme.labelSmall?.copyWith(color: _onCourtMuted, fontWeight: FontWeight.w600),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        if (showCourtLabel) const SizedBox(height: 4),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ProfileAvatar(displayName: name, imageUrl: imageUrl, radius: 14),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                name,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(
                  context,
                ).textTheme.titleSmall?.copyWith(color: _onCourt, fontWeight: FontWeight.w600, height: 1.15),
              ),
            ),
          ],
        ),
        const Spacer(),
      ],
    );
  }
}

class _BookedStackedBody extends StatelessWidget {
  const _BookedStackedBody({required this.name, required this.mine, this.imageUrl});

  final String name;
  final bool mine;
  final String? imageUrl;

  static const Color _onCourt = Color(0xFFFFFFFF);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ProfileAvatar(displayName: name, imageUrl: imageUrl, radius: 18),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            name,
            style: Theme.of(
              context,
            ).textTheme.titleSmall?.copyWith(color: _onCourt, fontWeight: FontWeight.w600, height: 1.15),
          ),
        ),
        if (mine) ...[const SizedBox(width: 8, height: 34)],
      ],
    );
  }
}
