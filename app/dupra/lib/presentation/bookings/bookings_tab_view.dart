import 'package:app_bloc/app_bloc.dart';
import 'package:client_models/client_models.dart';
import 'package:dio/dio.dart';
import 'package:dupra/engine/theme/dupra_colors.dart';
import 'package:dupra/presentation/bookings/data/booking_schedule.dart';
import 'package:dupra/presentation/bookings/data/bookings_layout_preference.dart';
import 'package:dupra/presentation/bookings/widgets/booking_details_sheet.dart';
import 'package:dupra/presentation/bookings/widgets/bookings_date_sheet.dart';
import 'package:dupra/presentation/shell/shell_tab_insets.dart';
import 'package:dupra/presentation/widgets/dupra_avatar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'widgets/bookings_slot_rows.dart';

/// Dupra member bookings tab — schedule bands, bookings grid vs accessible rows (persisted).
class BookingsTabView extends StatefulWidget {
  const BookingsTabView({super.key});

  @override
  State<BookingsTabView> createState() => _BookingsTabViewState();
}

class _BookingsTabViewState extends State<BookingsTabView> {
  BookingTimeBand _band = BookingTimeBand.peak;
  bool _creatingBooking = false;
  DupraBookingsSlotLayout _layout = DupraBookingsSlotLayout.accessible;

  @override
  void initState() {
    super.initState();
    DupraBookingsLayoutPreferenceStore.load().then((layout) {
      if (mounted) {
        setState(() => _layout = layout);
      }
    });
  }

  Widget _bookingBandSegmentLabel(String text) {
    return FittedBox(
      fit: BoxFit.scaleDown,
      child: Text(text, maxLines: 1, softWrap: false, textAlign: TextAlign.center),
    );
  }

  Future<void> _pickDate() async {
    final bloc = context.read<BookingsBloc>();
    final picked = await showBookingsDatePickerSheet(context, selectedDate: bloc.state.selectedDate);
    if (picked != null && mounted) {
      context.read<BookingsBloc>().add(BookingsEvent.onLoadBookings(forDate: picked));
    }
  }

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
        SnackBar(content: Text('Booked court $courtNo on $dayUi at ${formatSlotRangeLabel(slotStartMinutes)}.')),
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

  String _layoutMenuTooltip() => switch (_layout) {
    DupraBookingsSlotLayout.grid => 'Layout: Grid. Tap to change.',
    DupraBookingsSlotLayout.accessible => 'Layout: Accessible. Tap to change.',
  };

  IconData _layoutMenuButtonIcon() => switch (_layout) {
    DupraBookingsSlotLayout.grid => Icons.view_column_outlined,
    DupraBookingsSlotLayout.accessible => Icons.accessibility_new,
  };

  Future<void> _onPickLayout(DupraBookingsSlotLayout layout) async {
    await DupraBookingsLayoutPreferenceStore.save(layout);
    if (!mounted) return;
    setState(() => _layout = layout);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BookingsBloc, BookingsState>(
      builder: (context, state) {
        final status = state.status.status;
        final message = state.status.message?.trim();

        if (status == BaseLoadingStatus.initial || status == BaseLoadingStatus.loading) {
          return Padding(
            padding: dupraShellTabPadding(context),
            child: const Center(child: CircularProgressIndicator.adaptive()),
          );
        }

        if (status == BaseLoadingStatus.loadingFailed) {
          return Padding(
            padding: dupraShellTabPadding(context),
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  (message != null && message.isNotEmpty) ? message : 'Failed to load bookings',
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          );
        }

        final lookup = bookingBySlotAndCourt(bookings: state.bookings, selectedDay: state.selectedDate);
        final slots = CourtSchedule.slotStartsForBand(_band);
        final useCompactGrid = _layout.usesCompactGrid;

        return Stack(
          children: [
            Padding(
              padding: dupraShellTabPadding(context, top: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: BookingsDateSelectorTile(selectedDate: state.selectedDate, onTap: _pickDate),
                      ),
                      const SizedBox(width: 8),
                      Material(
                        color: Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.55),
                        borderRadius: BorderRadius.circular(12),
                        child: PopupMenuButton<DupraBookingsSlotLayout>(
                          tooltip: _layoutMenuTooltip(),
                          padding: EdgeInsets.zero,
                          icon: Icon(_layoutMenuButtonIcon(), color: DupraColors.secondary),
                          onSelected: _onPickLayout,
                          itemBuilder: (context) => [
                            PopupMenuItem(
                              value: DupraBookingsSlotLayout.accessible,
                              child: ListTile(
                                dense: true,
                                contentPadding: EdgeInsets.zero,
                                leading: Icon(
                                  Icons.accessibility_new,
                                  color: _layout == DupraBookingsSlotLayout.accessible ? DupraColors.secondary : null,
                                ),
                                title: const Text('Accessible'),
                                subtitle: const Text('One row per court'),
                              ),
                            ),
                            PopupMenuItem(
                              value: DupraBookingsSlotLayout.grid,
                              child: ListTile(
                                dense: true,
                                contentPadding: EdgeInsets.zero,
                                leading: Icon(
                                  Icons.view_column_outlined,
                                  color: _layout == DupraBookingsSlotLayout.grid ? DupraColors.secondary : null,
                                ),
                                title: const Text('Grid'),
                                subtitle: const Text('Three columns'),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  SegmentedButton<BookingTimeBand>(
                    showSelectedIcon: false,
                    style: SegmentedButton.styleFrom(
                      selectedBackgroundColor: DupraColors.secondary.withValues(alpha: 0.22),
                      selectedForegroundColor: DupraColors.secondary,
                    ),
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
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 8, 0, 4),
                    child: Row(
                      children: [
                        Text(
                          _band.rangeLabel,
                          style: Theme.of(
                            context,
                          ).textTheme.labelMedium?.copyWith(color: DupraColors.secondary, fontWeight: FontWeight.w600),
                        ),
                        const Spacer(),
                        Text(
                          '${useCompactGrid ? 'Grid' : 'Accessible'} · ${useCompactGrid ? 'Courts 1–${CourtSchedule.courtCount}' : 'Per-court rows'}',
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
                            padding: const EdgeInsets.only(bottom: 24),
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
