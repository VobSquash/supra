part of '../../admin_bookings_placeholder_page.dart';

class _AdminBookingsManagementBody extends StatefulWidget {
  const _AdminBookingsManagementBody();

  @override
  State<_AdminBookingsManagementBody> createState() => _AdminBookingsManagementBodyState();
}

class _AdminBookingsManagementBodyState extends State<_AdminBookingsManagementBody> {
  final _titleController = TextEditingController(text: '');
  late DateTime _selectedDate;
  late int _slotStartMin;
  late int _slotEndMin;

  /// Courts 1–3 → index 0–2.
  final List<bool> _courtSelected = [false, false, false];
  bool _busy = false;

  List<int> get _slotStarts => CourtSchedule.allSlotStartsMinutes();

  @override
  void initState() {
    super.initState();
    _selectedDate = adminBookingsCalendarTodayLocal();
    _slotStartMin = 14 * 60 + 15;
    _slotEndMin = 14 * 60 + 15;
  }

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final picked = await showBookingsDatePickerSheet(context, selectedDate: _selectedDate);
    if (picked != null && mounted) {
      setState(() => _selectedDate = adminBookingsCalendarDay(picked));
      context.read<BookingsBloc>().add(BookingsEvent.onLoadBookings(forDate: _selectedDate));
    }
  }

  void _reloadList() {
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
    if (!_courtSelected.any((c) => c)) {
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
          timeslotStart: adminBookingsHhmm(_slotStartMin),
          timeslotEnd: adminBookingsHhmm(_slotEndMin),
          court1: _courtSelected[0],
          court2: _courtSelected[1],
          court3: _courtSelected[2],
        ),
      );
      if (!mounted) return;
      _reloadList();
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Admin block created for ${_selectedDate.formateDateForUi()}.')));
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(adminBookingsAdminErrorMessage(e))));
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
          bd != null ? 'Deletes this admin booking for ${bd.formateDateForUi()}.' : 'Deletes this row as admin.',
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
      _reloadList();
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(bd != null ? 'Booking deleted (${bd.formateDateForUi()}).' : 'Deleted.')));
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(adminBookingsAdminErrorMessage(e))));
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
      _reloadList();
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('All bookings removed for $dayUi.')));
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(adminBookingsAdminErrorMessage(e))));
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Widget _sectionTitle(BuildContext context, String text, {IconData? icon}) {
    final tt = Theme.of(
      context,
    ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700, letterSpacing: 0.2, color: DupraColors.secondary);
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          if (icon != null) ...[Icon(icon, size: 18, color: DupraColors.secondary), const SizedBox(width: 8)],
          Text(text, style: tt),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final edge = dupraShellTabPadding(context, top: 8);
    final endSlotChoices = _slotStarts.where((m) => m >= _slotStartMin).toList();
    final timeSummary =
        '${adminBookingsHhmm(_slotStartMin)} → ${adminBookingsHhmm(_slotEndMin)} · ${formatSlotRangeLabel(_slotStartMin)}–${formatSlotRangeLabel(_slotEndMin)}';

    return Stack(
      children: [
        CustomScrollView(
          slivers: [
            SliverPadding(
              padding: EdgeInsets.fromLTRB(edge.left, edge.top, edge.right, 16),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: DupraColors.secondary.withValues(alpha: 0.14),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: const Icon(Icons.event_note_rounded, color: DupraColors.secondary, size: 28),
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
                              ).textTheme.bodyMedium?.copyWith(color: DupraColors.textSecondary, height: 1.4),
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
                                  color: DupraColors.secondary.withValues(alpha: 0.85),
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
                                  itemLabel: formatSlotRangeLabel,
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
                                  itemLabel: formatSlotRangeLabel,
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
                                  selected: _courtSelected[i - 1],
                                  enabled: !_busy,
                                  onChanged: (value) => setState(() => _courtSelected[i - 1] = value),
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
                      const Icon(Icons.list_alt_rounded, size: 22, color: DupraColors.secondary),
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
            SliverPadding(
              padding: EdgeInsets.fromLTRB(edge.left, 0, edge.right, edge.bottom),
              sliver: SliverToBoxAdapter(
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
                        padding: const EdgeInsets.only(bottom: 8),
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
                                    (message?.isNotEmpty ?? false) ? message! : 'Failed to load bookings',
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
                        padding: const EdgeInsets.only(bottom: 8),
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
                                  ).textTheme.bodyMedium?.copyWith(color: DupraColors.textSecondary),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8),
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
    );
  }
}
