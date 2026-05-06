import 'package:dupra/engine/theme/dupra_colors.dart';
import 'package:dupra/presentation/calculator/models/fridge_item.dart';
import 'package:dupra/presentation/calculator/widgets/counter_button.dart';
import 'package:flutter/material.dart';

class FridgeItemTile extends StatelessWidget {
  const FridgeItemTile({required this.item, required this.onIncrement, required this.onDecrement, super.key});

  final FridgeItem item;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final isSelected = item.count > 0;
    // Deeper slab than default cards so rows stay legible on the glass scaffold.
    final baseCardColor = Color.lerp(DupraColors.scaffoldSecondary, DupraColors.scaffoldBackground, 0.38)!;
    final cardColor = isSelected
        ? Color.alphaBlend(scheme.primary.withValues(alpha: 0.14), baseCardColor)
        : baseCardColor;
    final borderColor = Color.alphaBlend(
      (isSelected ? scheme.primary : scheme.outlineVariant).withValues(alpha: isSelected ? 0.55 : 0.65),
      baseCardColor,
    );
    final lineTotal = item.price * item.count;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6),
      child: Card(
        clipBehavior: Clip.antiAlias,
        color: cardColor,
        elevation: isSelected ? 3 : 0,
        shadowColor: scheme.primary.withValues(alpha: 0.35),
        margin: const EdgeInsets.symmetric(vertical: 3),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
          side: BorderSide(color: borderColor, width: isSelected ? 1.5 : 1),
        ),
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (isSelected)
                DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [scheme.primary, Color.lerp(scheme.primary, DupraColors.calculator, 0.35)!],
                    ),
                  ),
                  child: const SizedBox(width: 3),
                ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(12, 10, 11, 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(
                              item.name,
                              style: textTheme.titleSmall?.copyWith(
                                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                                height: 1.15,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          DecoratedBox(
                            decoration: BoxDecoration(
                              color: scheme.primary.withValues(alpha: 0.16),
                              borderRadius: BorderRadius.circular(999),
                              border: Border.all(color: scheme.primary.withValues(alpha: 0.35)),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                              child: Text(
                                'R${item.price}',
                                style: textTheme.labelMedium?.copyWith(
                                  fontWeight: FontWeight.w700,
                                  color: scheme.primary,
                                  letterSpacing: 0.15,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      if (item.count > 0) ...[
                        const SizedBox(height: 4),
                        Text(
                          '${item.count} × R${item.price} = R$lineTotal',
                          style: textTheme.bodySmall?.copyWith(
                            color: scheme.onSurfaceVariant,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                      const SizedBox(height: 8),
                      Align(
                        alignment: Alignment.centerRight,
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            color: scheme.onSurface.withValues(alpha: 0.07),
                            borderRadius: BorderRadius.circular(999),
                            border: Border.all(color: scheme.outline.withValues(alpha: 0.22)),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 3, vertical: 3),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                CounterButton(isAddIcon: false, onPressed: onDecrement),
                                ConstrainedBox(
                                  constraints: const BoxConstraints(minWidth: 28),
                                  child: Text(
                                    '${item.count}',
                                    style: textTheme.titleSmall?.copyWith(
                                      fontWeight: FontWeight.w800,
                                      fontFeatures: const [FontFeature.tabularFigures()],
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                CounterButton(isAddIcon: true, onPressed: onIncrement),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
