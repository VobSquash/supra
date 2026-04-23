import 'package:flutter/material.dart';

import '../models/fridge_item.dart';
import 'saved_item_card.dart';

class SavedItemsDialog extends StatelessWidget {
  const SavedItemsDialog({
    super.key,
    required this.categorizedItems,
    required this.timestamp,
    required this.username,
  });

  final Map<String, List<FridgeItem>> categorizedItems;
  final String timestamp;
  final String username;

  @override
  Widget build(BuildContext context) {
    var totalItemCount = 0;
    var totalCost = 0;
    final categoryWidgets = <Widget>[];

    for (final entry in categorizedItems.entries) {
      final categoryName = entry.key;
      final items = entry.value;
      final itemWidgets = <Widget>[];

      for (final item in items) {
        if (item.count > 0) {
          totalItemCount += item.count;
          totalCost += item.price * item.count;
          itemWidgets.add(SavedItemCard(item: item));
        }
      }

      if (itemWidgets.isNotEmpty) {
        categoryWidgets.add(
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 16, bottom: 8),
                child: Text(
                  categoryName.toUpperCase(),
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        letterSpacing: 0.6,
                        fontWeight: FontWeight.w800,
                      ),
                ),
              ),
              ...itemWidgets,
            ],
          ),
        );
      }
    }

    final savedTime = DateTime.tryParse(timestamp) ?? DateTime.now();
    final formattedDate = '${savedTime.day}/${savedTime.month}/${savedTime.year}';
    final formattedTime =
        '${savedTime.hour.toString().padLeft(2, '0')}:${savedTime.minute.toString().padLeft(2, '0')}';

    return AlertDialog(
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Saved items', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 6),
          Text(
            'Last saved: $formattedDate at $formattedTime',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          if (username.isNotEmpty)
            Text('For: $username', style: Theme.of(context).textTheme.bodyMedium),
        ],
      ),
      content: SizedBox(
        width: double.maxFinite,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxHeight: 400),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ...categoryWidgets,
                const Divider(height: 32),
                _TotalSection(totalItemCount: totalItemCount, totalCost: totalCost),
              ],
            ),
          ),
        ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Close')),
      ],
    );
  }
}

class _TotalSection extends StatelessWidget {
  const _TotalSection({required this.totalItemCount, required this.totalCost});

  final int totalItemCount;
  final int totalCost;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: scheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: scheme.outlineVariant),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Total items', style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: scheme.onSurfaceVariant)),
                Text('$totalItemCount', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Total cost', style: Theme.of(context).textTheme.titleSmall),
                Text(
                  'R$totalCost',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: scheme.primary,
                      ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
