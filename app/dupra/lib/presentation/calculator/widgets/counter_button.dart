import 'package:flutter/material.dart';

class CounterButton extends StatelessWidget {
  const CounterButton({required this.isAddIcon, required this.onPressed, super.key});

  final bool isAddIcon;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final bg = isAddIcon ? scheme.primaryContainer : scheme.errorContainer;
    final fg = isAddIcon ? scheme.onPrimaryContainer : scheme.onErrorContainer;

    return Material(
      color: bg,
      borderRadius: BorderRadius.circular(999),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(999),
        child: Padding(
          padding: const EdgeInsets.all(7),
          child: Icon(isAddIcon ? Icons.add_rounded : Icons.remove_rounded, size: 20, color: fg),
        ),
      ),
    );
  }
}
