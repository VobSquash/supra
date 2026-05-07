import 'package:dupra/presentation/shell/shell_tab_insets.dart';
import 'package:flutter/material.dart';

/// Admin shell — Bookings tab.
class AdminBookingsPlaceholderPage extends StatelessWidget {
  const AdminBookingsPlaceholderPage({super.key});

  @override
  Widget build(BuildContext context) {
    final variant = Theme.of(context).colorScheme.onSurfaceVariant;
    return ListView(
      padding: dupraShellTabPadding(context),
      children: [
        Text(
          'Admin bookings',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 8),
        Text(
          'Placeholder — manage bookings, courts, and sessions (admin).',
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: variant),
        ),
      ],
    );
  }
}
