import 'package:dupra/presentation/shell/shell_tab_insets.dart';
import 'package:flutter/material.dart';

/// Admin shell — Ladder tab.
class AdminLaddersPlaceholderPage extends StatelessWidget {
  const AdminLaddersPlaceholderPage({super.key});

  @override
  Widget build(BuildContext context) {
    final variant = Theme.of(context).colorScheme.onSurfaceVariant;
    return ListView(
      padding: dupraShellTabPadding(context),
      children: [
        Text(
          'Admin ladder',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 8),
        Text(
          'Placeholder — ladder administration, promotions, and structure.',
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: variant),
        ),
      ],
    );
  }
}
