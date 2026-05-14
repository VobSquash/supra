import 'package:client_models/client_models.dart';
import 'package:dupra/engine/theme/dupra_colors.dart';
import 'package:flutter/material.dart';

/// Full calendar in a bottom sheet with an explicit title and confirm (same flow as Supra `bookings_date_sheet.dart`).
Future<DateTime?> showBookingsDatePickerSheet(
  BuildContext context, {
  required DateTime selectedDate,
}) {
  final day = DateTime(selectedDate.year, selectedDate.month, selectedDate.day);
  return showModalBottomSheet<DateTime>(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    builder: (ctx) {
      return SafeArea(
        child: Padding(
          padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(ctx).bottom),
          child: _BookingsDatePickerSheetBody(initialDate: day),
        ),
      );
    },
  );
}

class _BookingsDatePickerSheetBody extends StatefulWidget {
  const _BookingsDatePickerSheetBody({required this.initialDate});

  final DateTime initialDate;

  @override
  State<_BookingsDatePickerSheetBody> createState() => _BookingsDatePickerSheetBodyState();
}

class _BookingsDatePickerSheetBodyState extends State<_BookingsDatePickerSheetBody> {
  late DateTime _selected;

  @override
  void initState() {
    super.initState();
    _selected = widget.initialDate;
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final first = DateTime(2020);
    final last = DateTime(2035);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 4, 20, 0),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Select a date',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600),
            ),
          ),
        ),
        Theme(
          data: Theme.of(context).copyWith(
            colorScheme: scheme.copyWith(primary: DupraColors.secondary),
          ),
          child: SizedBox(
            height: 360,
            child: CalendarDatePicker(
              initialDate: widget.initialDate,
              firstDate: first,
              lastDate: last,
              onDateChanged: (d) {
                setState(() => _selected = DateTime(d.year, d.month, d.day));
              },
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          child: Row(
            children: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Cancel'),
              ),
              const Spacer(),
              FilledButton(
                onPressed: () => Navigator.of(context).pop(_selected),
                child: const Text('Select'),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/// Prominent, tappable row so choosing a day is obvious (Supra `BookingsDateSelectorTile`, Dupra-themed).
class BookingsDateSelectorTile extends StatelessWidget {
  const BookingsDateSelectorTile({
    required this.selectedDate,
    required this.onTap,
    super.key,
    this.label = 'Bookings for',
  });

  final DateTime selectedDate;
  final VoidCallback onTap;

  /// Short line above the formatted date.
  final String label;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final dateLine = selectedDate.formateDateForUi();

    return Semantics(
      button: true,
      label: 'Booking date, $dateLine. Double tap to choose another date.',
      child: Material(
        color: scheme.surfaceContainerHighest.withValues(alpha: 0.55),
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                const Icon(Icons.calendar_month_rounded, color: DupraColors.secondary, size: 28),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        label,
                        style: Theme.of(context).textTheme.labelMedium?.copyWith(
                              color: scheme.onSurfaceVariant,
                            ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        dateLine,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                    ],
                  ),
                ),
                Icon(Icons.expand_more_rounded, color: scheme.onSurfaceVariant),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
