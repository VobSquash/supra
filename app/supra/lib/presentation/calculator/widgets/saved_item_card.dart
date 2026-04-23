import 'package:flutter/material.dart';

import '../models/fridge_item.dart';

class SavedItemCard extends StatelessWidget {
  const SavedItemCard({super.key, required this.item});

  final FridgeItem item;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Card(
      elevation: 0,
      margin: const EdgeInsets.symmetric(vertical: 4),
      color: scheme.surfaceContainerHighest,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(color: scheme.outlineVariant),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            Expanded(
              child: Text(
                item.name,
                style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w500),
              ),
            ),
            DecoratedBox(
              decoration: BoxDecoration(
                color: scheme.secondaryContainer,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                child: Text(
                  '${item.count}×',
                  style: TextStyle(fontWeight: FontWeight.bold, color: scheme.onSecondaryContainer),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Text(
              'R${item.price * item.count}',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: scheme.onSurfaceVariant,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
