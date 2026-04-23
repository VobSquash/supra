import 'package:flutter/material.dart';

class CounterButton extends StatelessWidget {
  const CounterButton({
    super.key,
    required this.isAddIcon,
    required this.onPressed,
  });

  final bool isAddIcon;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final bg = isAddIcon ? scheme.primaryContainer : scheme.errorContainer;
    final fg = isAddIcon ? scheme.onPrimaryContainer : scheme.onErrorContainer;

    return Material(
      color: bg,
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
          child: Text(
            isAddIcon ? '+' : '-',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w800,
                  color: fg,
                ),
          ),
        ),
      ),
    );
  }
}
