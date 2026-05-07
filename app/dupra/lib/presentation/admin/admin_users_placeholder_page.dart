import 'package:dupra/presentation/shell/shell_tab_insets.dart';
import 'package:flutter/material.dart';

/// Admin shell — Users tab.
class AdminUsersPlaceholderPage extends StatelessWidget {
  const AdminUsersPlaceholderPage({super.key});

  @override
  Widget build(BuildContext context) {
    final variant = Theme.of(context).colorScheme.onSurfaceVariant;
    return ListView(
      padding: dupraShellTabPadding(context),
      children: [
        Text(
          'Admin users',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 8),
        Text(
          'Placeholder — directory, roles, and member management.',
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: variant),
        ),
      ],
    );
  }
}
