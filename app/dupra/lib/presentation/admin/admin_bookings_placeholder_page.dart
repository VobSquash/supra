import 'package:app_bloc/app_bloc.dart';
import 'package:client_models/client_models.dart';
import 'package:dupra/engine/theme/dupra_colors.dart';
import 'package:dupra/presentation/admin/bookings/data/admin_bookings_admin_messages.dart';
import 'package:dupra/presentation/admin/bookings/data/admin_bookings_time_strings.dart';
import 'package:dupra/presentation/bookings/data/booking_schedule.dart';
import 'package:dupra/presentation/bookings/widgets/bookings_date_sheet.dart';
import 'package:dupra/presentation/shell/shell_tab_insets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'bookings/widgets/admin_bookings_management_body.dart';
part 'bookings/widgets/admin_bookings_widgets.dart';

/// Admin shell — fixture blocks: multi-court / multi-slot bookings via [BookingsBloc].
///
/// Parity with Supra admin bookings; uses the same thin shell page + `part` widgets layout as other Dupra admin tabs.
class AdminBookingsPlaceholderPage extends StatelessWidget {
  const AdminBookingsPlaceholderPage({super.key});

  @override
  Widget build(BuildContext context) {
    final today = adminBookingsCalendarTodayLocal();
    return BlocProvider(
      create: (_) => appBlocSl<BookingsBloc>()..add(BookingsEvent.onLoadBookings(forDate: today)),
      child: const _AdminBookingsManagementBody(),
    );
  }
}
