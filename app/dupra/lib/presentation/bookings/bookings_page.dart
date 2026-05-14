import 'package:app_bloc/app_bloc.dart';
import 'package:dupra/presentation/bookings/bookings_tab_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Member bookings tab — wraps [BookingsTabView] with [BookingsBloc] (same API contract as Supra `BookingsTestPage`).
class BookingsPage extends StatelessWidget {
  const BookingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final today = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
    return BlocProvider(
      create: (_) => appBlocSl<BookingsBloc>()..add(BookingsEvent.onLoadBookings(forDate: today)),
      child: const BookingsTabView(),
    );
  }
}
