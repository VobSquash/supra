import 'package:dupra/engine/theme/dupra_colors.dart';
import 'package:flutter/material.dart';

/// Text action styled as an underlined link (secondary text, theme primary underline).
class DupraLinkButton extends StatelessWidget {
  const DupraLinkButton({required this.label, required this.onPressed, super.key});

  final String label;
  final VoidCallback? onPressed;

  static const double _underlineGap = 2;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final textStyle = Theme.of(context).textTheme.labelLarge?.copyWith(
      fontWeight: FontWeight.w600,
      color: DupraColors.secondary,
    );
    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        minimumSize: Size.zero,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
      child: IntrinsicWidth(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(label, style: textStyle),
            const SizedBox(height: _underlineGap),
            ColoredBox(
              color: scheme.primary,
              child: const SizedBox(height: 1),
            ),
          ],
        ),
      ),
    );
  }
}
