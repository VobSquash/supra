import 'package:app_bloc/app_bloc.dart';
import 'package:client_models/client_models.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../engine/theme/supra_colors.dart';
import 'booking_schedule.dart';
import 'bookings_date_sheet.dart';

String _hhmm(int minutesFromMidnight) {
  final h = minutesFromMidnight ~/ 60;
  final m = minutesFromMidnight % 60;
  return '${h.toString().padLeft(2, '0')}:${m.toString().padLeft(2, '0')}';
}

String _formatBookingWallUtc(DateTime? d) {
  if (d == null) return '—';
  final u = d.toUtc();
  return '${u.hour.toString().padLeft(2, '0')}:${u.minute.toString().padLeft(2, '0')}';
}

class _SlotDropdown<T> extends StatelessWidget {
  const _SlotDropdown({
    required this.label,
    required this.value,
    required this.items,
    required this.itemLabel,
    required this.onChanged,
    this.enabled = true,
  });

  final String label;
  final T value;
  final List<T> items;
  final String Function(T) itemLabel;
  final ValueChanged<T?> onChanged;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return InputDecorator(
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: scheme.surfaceContainerHighest.withValues(alpha: 0.35),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: scheme.outline.withValues(alpha: 0.28)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: SupraColors.secondary.withValues(alpha: 0.85), width: 1.5),
        ),
        enabled: enabled,
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<T>(
          isExpanded: true,
          value: value,
          items: items
              .map(
                (m) => DropdownMenuItem<T>(
                  value: m,
                  child: Text(itemLabel(m), overflow: TextOverflow.ellipsis),
                ),
              )
              .toList(),
          onChanged: enabled ? onChanged : null,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: scheme.onSurface),
        ),
      ),
    );
  }
}

/// Dev screen: multi-court / multi-slot admin (fixture) bookings via [BookingsBloc].
class AdminBookingsTestPage extends StatefulWidget {
  const AdminBookingsTestPage({super.key});

  @override
  State<AdminBookingsTestPage> createState() => _AdminBookingsTestPageState();
}

class _AdminBookingsTestPageState extends State<AdminBookingsTestPage> {
  final _titleController = TextEditingController(text: '');
  late DateTime _selectedDate;
  late int _slotStartMin;
  late int _slotEndMin;
  bool _court1 = false;
  bool _court2 = false;
  bool _court3 = false;
  bool _busy = false;

  List<int> get _slotStarts => CourtSchedule.allSlotStartsMinutes();

  @override
  void initState() {
    super.initState();
    final today = DateTime.now();
    _selectedDate = DateTime(today.year, today.month, today.day);
    _slotStartMin = 14 * 60 + 15;
    _slotEndMin = 14 * 60 + 15;
    context.read<BookingsBloc>().add(BookingsEvent.onLoadBookings(forDate: _selectedDate));
  }

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final picked = await showBookingsDatePickerSheet(context, selectedDate: _selectedDate);
    if (picked != null && mounted) {
      setState(() => _selectedDate = DateTime(picked.year, picked.month, picked.day));
      context.read<BookingsBloc>().add(BookingsEvent.onLoadBookings(forDate: _selectedDate));
    }
  }

  Future<void> _reloadList() async {
    context.read<BookingsBloc>().add(BookingsEvent.onLoadBookings(forDate: _selectedDate));
  }

  Future<void> _createBlock() async {
    if (_busy) return;
    if (_slotEndMin < _slotStartMin) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('End time must be on or after start time.')));
      return;
    }
    if (!_court1 && !_court2 && !_court3) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Select at least one court.')));
      return;
    }
    final title = _titleController.text.trim();
    if (title.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Enter a booking title.')));
      return;
    }

    setState(() => _busy = true);
    try {
      await context.read<BookingsBloc>().createAdminBookings(
        dto: CreateAdminBookingDto(
          bookingTitle: title,
          selectedDate: _selectedDate,
          timeslotStart: _hhmm(_slotStartMin),
          timeslotEnd: _hhmm(_slotEndMin),
          court1: _court1,
          court2: _court2,
          court3: _court3,
        ),
      );
      if (!mounted) return;
      await _reloadList();
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Admin block created for ${_selectedDate.formateDateForUi()}.')),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(_adminErrorMessage(e))));
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _deleteAdmin(BookingDto b) async {
    final id = b.objectId?.trim();
    if (id == null || id.isEmpty) return;
    final bd = b.bookingDate;
    final ok = await showDialog<bool>(
      context: context,
      builder: (c) => AlertDialog(
        title: const Text('Delete booking?'),
        content: Text(
          bd != null
              ? 'Deletes this admin booking for ${bd.formateDateForUi()}.'
              : 'Deletes this row as admin.',
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(c, false), child: const Text('Cancel')),
          FilledButton(onPressed: () => Navigator.pop(c, true), child: const Text('Delete')),
        ],
      ),
    );
    if (!mounted || ok != true) return;
    setState(() => _busy = true);
    try {
      await context.read<BookingsBloc>().deleteBookingAsAdmin(bookingId: id);
      if (!mounted) return;
      await _reloadList();
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            bd != null ? 'Booking deleted (${bd.formateDateForUi()}).' : 'Deleted.',
          ),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(_adminErrorMessage(e))));
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _deleteAllForDay() async {
    final dayUi = _selectedDate.formateDateForUi();
    final ok = await showDialog<bool>(
      context: context,
      builder: (c) => AlertDialog(
        title: Text('Delete all bookings for $dayUi?'),
        content: Text('Removes every booking on $dayUi. This cannot be undone.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(c, false), child: const Text('Cancel')),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: Theme.of(c).colorScheme.error),
            onPressed: () => Navigator.pop(c, true),
            child: const Text('Delete all'),
          ),
        ],
      ),
    );
    if (!mounted || ok != true) return;
    setState(() => _busy = true);
    try {
      await context.read<BookingsBloc>().deleteAllBookingsForDateAsAdmin(forDate: _selectedDate);
      if (!mounted) return;
      await _reloadList();
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('All bookings removed for $dayUi.')),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(_adminErrorMessage(e))));
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  String _adminErrorMessage(Object error) {
    if (error is DioException) {
      final t = error.error?.toString().trim();
      if (t != null && t.isNotEmpty) return t;
      final m = error.message?.trim();
      if (m != null && m.isNotEmpty) return m;
    }
    final s = error.toString().trim();
    if (s.isNotEmpty && s != 'Exception') return s;
    return 'Request failed.';
  }

  Widget _sectionTitle(BuildContext context, String text, {IconData? icon}) {
    final tt = Theme.of(
      context,
    ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700, letterSpacing: 0.2, color: SupraColors.secondary);
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          if (icon != null) ...[Icon(icon, size: 18, color: SupraColors.secondary), const SizedBox(width: 8)],
          Text(text, style: tt),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final endSlotChoices = _slotStarts.where((m) => m >= _slotStartMin).toList();
    final timeSummary =
        '${_hhmm(_slotStartMin)} → ${_hhmm(_slotEndMin)} · ${formatSlotRangeLabel(_slotStartMin)}–${formatSlotRangeLabel(_slotEndMin)}';

    return Scaffold(
      appBar: AppBar(title: const Text('Admin fixtures')),
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 28),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: SupraColors.secondary.withValues(alpha: 0.14),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Icon(Icons.event_note_rounded, color: SupraColors.secondary, size: 28),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Fixture block',
                                style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                'Reserve courts across several slots in one action. Bookings use your profile.',
                                style: Theme.of(
                                  context,
                                ).textTheme.bodyMedium?.copyWith(color: SupraColors.textSecondary, height: 1.4),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Material(
                      color: scheme.surfaceContainerHighest.withValues(alpha: 0.42),
                      borderRadius: BorderRadius.circular(20),
                      clipBehavior: Clip.antiAlias,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(18, 18, 18, 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            _sectionTitle(context, 'Details', icon: Icons.edit_calendar_outlined),
                            TextField(
                              controller: _titleController,
                              enabled: !_busy,
                              textCapitalization: TextCapitalization.sentences,
                              style: Theme.of(context).textTheme.titleMedium,
                              decoration: InputDecoration(
                                labelText: 'Title',
                                hintText: 'e.g. Club night, ladder final',
                                filled: true,
                                fillColor: scheme.surface.withValues(alpha: 0.55),
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(14),
                                  borderSide: BorderSide(color: scheme.outline.withValues(alpha: 0.22)),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(14),
                                  borderSide: BorderSide(
                                    color: SupraColors.secondary.withValues(alpha: 0.85),
                                    width: 1.5,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 14),
                            IgnorePointer(
                              ignoring: _busy,
                              child: Opacity(
                                opacity: _busy ? 0.55 : 1,
                                child: BookingsDateSelectorTile(
                                  label: 'Fixture date',
                                  selectedDate: _selectedDate,
                                  onTap: _pickDate,
                                ),
                              ),
                            ),
                            const SizedBox(height: 18),
                            _sectionTitle(context, 'Time range', icon: Icons.schedule_rounded),
                            Text(
                              timeSummary,
                              style: Theme.of(context).textTheme.labelMedium?.copyWith(color: scheme.onSurfaceVariant),
                            ),
                            const SizedBox(height: 10),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: _SlotDropdown<int>(
                                    label: 'From',
                                    value: _slotStartMin,
                                    items: _slotStarts,
                                    enabled: !_busy,
                                    itemLabel: (m) => formatSlotRangeLabel(m),
                                    onChanged: (v) {
                                      if (v == null) return;
                                      setState(() {
                                        _slotStartMin = v;
                                        if (_slotEndMin < _slotStartMin) {
                                          _slotEndMin = _slotStartMin;
                                        }
                                      });
                                    },
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: _SlotDropdown<int>(
                                    label: 'To (inclusive)',
                                    value: endSlotChoices.isEmpty
                                        ? _slotStartMin
                                        : (endSlotChoices.contains(_slotEndMin) ? _slotEndMin : endSlotChoices.last),
                                    items: endSlotChoices.isEmpty ? [_slotStartMin] : endSlotChoices,
                                    enabled: !_busy,
                                    itemLabel: (m) => formatSlotRangeLabel(m),
                                    onChanged: (v) {
                                      if (v == null) return;
                                      setState(() => _slotEndMin = v);
                                    },
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 18),
                            _sectionTitle(context, 'Courts', icon: Icons.sports_tennis_rounded),
                            Wrap(
                              spacing: 12,
                              runSpacing: 12,
                              children: [
                                for (var i = 1; i <= 3; i++)
                                  _CourtToggleChip(
                                    courtIndex: i,
                                    selected: switch (i) {
                                      1 => _court1,
                                      2 => _court2,
                                      _ => _court3,
                                    },
                                    enabled: !_busy,
                                    onChanged: (value) {
                                      setState(() {
                                        switch (i) {
                                          case 1:
                                            _court1 = value;
                                          case 2:
                                            _court2 = value;
                                          default:
                                            _court3 = value;
                                        }
                                      });
                                    },
                                  ),
                              ],
                            ),
                            const SizedBox(height: 20),
                            FilledButton.icon(
                              style: FilledButton.styleFrom(
                                minimumSize: const Size.fromHeight(52),
                                padding: const EdgeInsets.symmetric(horizontal: 20),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                              ),
                              onPressed: _busy ? null : _createBlock,
                              icon: const Icon(Icons.add_rounded),
                              label: const Text('Create block'),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 22),
                    Row(
                      children: [
                        Icon(Icons.list_alt_rounded, size: 22, color: SupraColors.secondary),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Bookings this day',
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
                          ),
                        ),
                        TextButton.icon(
                          onPressed: _busy ? null : _deleteAllForDay,
                          icon: Icon(Icons.delete_sweep_outlined, size: 18, color: scheme.error),
                          label: Text(
                            'Clear day',
                            style: TextStyle(color: scheme.error, fontWeight: FontWeight.w600),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                  ]),
                ),
              ),
              SliverToBoxAdapter(
                child: BlocBuilder<BookingsBloc, BookingsState>(
                  builder: (context, state) {
                    final status = state.status.status;
                    final message = state.status.message?.trim();

                    if (status == BaseLoadingStatus.loading) {
                      return const Padding(
                        padding: EdgeInsets.symmetric(vertical: 32),
                        child: Center(child: CircularProgressIndicator.adaptive()),
                      );
                    }

                    if (status == BaseLoadingStatus.loadingFailed) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
                        child: Material(
                          color: scheme.errorContainer.withValues(alpha: 0.35),
                          borderRadius: BorderRadius.circular(14),
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Row(
                              children: [
                                Icon(Icons.error_outline_rounded, color: scheme.error),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    message?.isNotEmpty == true ? message! : 'Failed to load bookings',
                                    style: Theme.of(
                                      context,
                                    ).textTheme.bodyMedium?.copyWith(color: scheme.onErrorContainer),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }

                    final rows = state.bookings;
                    if (rows.isEmpty) {
                      return Padding(
                        padding: const EdgeInsets.fromLTRB(16, 8, 16, 40),
                        child: Material(
                          color: scheme.surfaceContainerHighest.withValues(alpha: 0.35),
                          borderRadius: BorderRadius.circular(16),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 20),
                            child: Column(
                              children: [
                                Icon(
                                  Icons.event_busy_outlined,
                                  size: 40,
                                  color: scheme.onSurfaceVariant.withValues(alpha: 0.6),
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  'No bookings on this date',
                                  style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  'Create a block above or pick another day.',
                                  textAlign: TextAlign.center,
                                  style: Theme.of(
                                    context,
                                  ).textTheme.bodyMedium?.copyWith(color: SupraColors.textSecondary),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }

                    return Padding(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 40),
                      child: Column(
                        children: [
                          for (final b in rows)
                            _AdminBookingRow(
                              booking: b,
                              scheme: scheme,
                              onDelete: () => _deleteAdmin(b),
                              enabled: !_busy,
                            ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
          if (_busy)
            Positioned.fill(
              child: ColoredBox(
                color: Colors.black.withValues(alpha: 0.12),
                child: const Center(child: CircularProgressIndicator.adaptive()),
              ),
            ),
        ],
      ),
    );
  }
}

/// Court pickers: **grey** when off, **court colour** when on (avoids M3 [FilterChip] colour inversion).
class _CourtToggleChip extends StatelessWidget {
  const _CourtToggleChip({
    required this.courtIndex,
    required this.selected,
    required this.onChanged,
    required this.enabled,
  });

  final int courtIndex;
  final bool selected;
  final ValueChanged<bool> onChanged;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final courtColor = SupraColors.courtBookedFill(courtIndex);
    final greyBg = scheme.surfaceContainerHighest.withValues(alpha: 0.72);
    final greyBorder = scheme.outline.withValues(alpha: 0.55);
    final avatarGrey = scheme.onSurfaceVariant.withValues(alpha: 0.42);

    return Semantics(
      selected: selected,
      button: true,
      label: 'Court $courtIndex, ${selected ? 'selected' : 'not selected'}',
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: enabled ? () => onChanged(!selected) : null,
          borderRadius: BorderRadius.circular(32),
          child: Ink(
            decoration: BoxDecoration(
              color: selected ? courtColor.withValues(alpha: 0.38) : greyBg,
              borderRadius: BorderRadius.circular(32),
              border: Border.all(color: selected ? courtColor : greyBorder, width: selected ? 2 : 1.25),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircleAvatar(
                    radius: 15,
                    backgroundColor: selected ? courtColor : avatarGrey,
                    child: Text(
                      '$courtIndex',
                      style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w700),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    'Court $courtIndex',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: selected ? scheme.onSurface : scheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _AdminBookingRow extends StatelessWidget {
  const _AdminBookingRow({required this.booking, required this.scheme, required this.onDelete, required this.enabled});

  final BookingDto booking;
  final ColorScheme scheme;
  final VoidCallback onDelete;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final court = booking.courtNo ?? 0;
    final courtColor = court >= 1 && court <= 3 ? SupraColors.courtBookedFill(court) : scheme.primary;

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Material(
        color: scheme.surfaceContainerHighest.withValues(alpha: 0.38),
        borderRadius: BorderRadius.circular(16),
        clipBehavior: Clip.antiAlias,
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(width: 5, color: courtColor),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(14, 12, 8, 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        booking.displayName ?? '—',
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Court $court · ${_formatBookingWallUtc(booking.bookingDate)} · Group ${booking.groupBookingId ?? 0}',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(color: SupraColors.textSecondary),
                      ),
                    ],
                  ),
                ),
              ),
              IconButton(
                tooltip: 'Delete',
                onPressed: enabled ? onDelete : null,
                icon: Icon(Icons.delete_outline_rounded, color: scheme.error.withValues(alpha: enabled ? 1 : 0.35)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
