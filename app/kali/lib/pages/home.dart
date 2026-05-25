import 'package:app_bloc/app_bloc.dart';
import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';
import 'package:middleware/middleware.dart';

import '../components/admin_placeholder_panel.dart';
import '../components/booking_admin_heatmap_panel.dart';
import '../navigation/kali_admin_eligibility.dart';

class Home extends StatelessComponent {
  const Home({super.key});

  @override
  Component build(BuildContext context) {
    final auth = middlewareSl<AuthBloc>().state;
    final adminHome = kaliAuthIsAdminOrElevated(auth);

    return div(classes: 'admin-dashboard', [
      p(classes: 'admin-dashboard-lead', [
        Component.text(
          adminHome
              ? 'Welcome to Kali admin. Today’s court grid matches the Dupra admin heatmap; bookings load from the same API.'
              : 'Welcome to Kali. Open Bookings for the member schedule. Admin fixtures and day blocks require an elevated administrator profile.',
        ),
      ]),
      if (adminHome) const BookingAdminHeatmapPanel(),
      AdminPlaceholderPanel(
        subtitle: 'More soon',
        body: adminHome
            ? 'Additional home metrics and shortcuts can land here. Sidebar routes are ready for deeper admin tasks.'
            : 'Additional shortcuts can appear here once your account has admin access.',
      ),
    ]);
  }
}
