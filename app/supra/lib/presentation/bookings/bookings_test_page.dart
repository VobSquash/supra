import 'package:app_bloc/app_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../shared/date_format.dart';

class BookingsTestPage extends StatefulWidget {
  const BookingsTestPage({super.key, this.nested = false});

  /// When true, omits [Scaffold]/[AppBar] so a parent shell can host this page.
  final bool nested;

  @override
  State<BookingsTestPage> createState() => _BookingsTestPageState();
}

class _BookingsTestPageState extends State<BookingsTestPage> {
  @override
  void initState() {
    super.initState();
    final today = DateTime(
      DateTime.now().year,
      DateTime.now().month,
      DateTime.now().day,
    );
    context.read<BookingsBloc>().add(
      BookingsEvent.onLoadBookings(forDate: today),
    );
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
    final picked = await showDatePicker(
      context: context,
      initialDate: bloc.state.selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2035),
    );
    if (picked != null && mounted) {
      context.read<BookingsBloc>().add(
        BookingsEvent.onLoadBookings(forDate: picked),
      );
    }
  }

  List<Widget> get _dateActions => [
        IconButton(
          icon: const Icon(Icons.chevron_left),
          tooltip: 'Previous day',
          onPressed: () => _nudgeDay(-1),
        ),
        IconButton(
          icon: const Icon(Icons.calendar_today_outlined),
          tooltip: 'Pick date',
          onPressed: _pickDate,
        ),
        IconButton(
          icon: const Icon(Icons.chevron_right),
          tooltip: 'Next day',
          onPressed: () => _nudgeDay(1),
        ),
      ];

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
                message?.isNotEmpty == true
                    ? message!
                    : 'Failed to load bookings',
                textAlign: TextAlign.center,
              ),
            ),
          );
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
              child: Text(
                'Date: ${formatYmd(state.selectedDate)} · ${state.bookings.length} booking(s)',
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
            Expanded(
              child: state.bookings.isEmpty
                  ? const Center(child: Text('No bookings for this day.'))
                  : ListView.separated(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: state.bookings.length,
                      separatorBuilder: (context, index) =>
                          const Divider(height: 1),
                      itemBuilder: (context, i) {
                        final b = state.bookings[i];
                        final sub = StringBuffer('Court ${b.courtNo ?? '—'}');
                        if (b.bookingDate != null) {
                          sub.write(' · ${b.bookingDate}');
                        }
                        if (b.profile?.displayName != null) {
                          sub.write(' · ${b.profile!.displayName}');
                        }
                        return ListTile(
                          title: Text(b.displayName ?? '(no name)'),
                          subtitle: Text(sub.toString()),
                        );
                      },
                    ),
            ),
          ],
        );
      },
    );

    if (widget.nested) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Material(
            color: Theme.of(context).colorScheme.surface.withValues(alpha: 0.35),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Row(
                children: [
                  const Padding(
                    padding: EdgeInsets.only(left: 12),
                    child: Text('Bookings'),
                  ),
                  const Spacer(),
                  ..._dateActions,
                ],
              ),
            ),
          ),
          Expanded(child: body),
        ],
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Bookings'),
        actions: _dateActions,
      ),
      body: body,
    );
  }
}
