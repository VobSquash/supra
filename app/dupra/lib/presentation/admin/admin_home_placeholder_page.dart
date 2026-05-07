import 'package:dupra/presentation/shell/shell_tab_insets.dart';
import 'package:flutter/material.dart';

/// Admin shell — Home tab (placeholder).
class AdminHomePlaceholderPage extends StatelessWidget {
  const AdminHomePlaceholderPage({super.key});

  @override
  Widget build(BuildContext context) {
    final variant = Theme.of(context).colorScheme.onSurfaceVariant;
    return ListView(
      padding: dupraShellTabPadding(context),
      children: [
        Text(
          'Admin home',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 8),
        Text(
          'Placeholder — admin overview and tools entry. Use the bar below or exit admin mode from the app bar.',
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: variant),
        ),
      ],
    );
  }
}
