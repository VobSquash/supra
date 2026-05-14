import 'package:dupra/engine/accessibility/dupra_build_context_accessibility.dart';
import 'package:flutter/material.dart';

/// Card with a coloured header strip (same visual language as ladder team blocks).
class DupraAccentSectionCard extends StatelessWidget {
  const DupraAccentSectionCard({
    required this.accentColor,
    required this.headerTitle,
    required this.body,
    super.key,
    this.headerIcon = Icons.event_note_outlined,
    this.headerTrailing,
  });

  final Color accentColor;
  final String headerTitle;
  final IconData headerIcon;
  final Widget? headerTrailing;
  final Widget body;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Card(
      elevation: 0,
      color: scheme.surfaceContainerHigh,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: scheme.outline.withValues(alpha: 0.22)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          DecoratedBox(
            decoration: BoxDecoration(
              border: Border(left: BorderSide(color: accentColor, width: 4)),
              color: accentColor.withValues(alpha: 0.75),
            ),
            child: Padding(
              padding: context.dupraScaledEdgeInsetsSymmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  Icon(headerIcon, color: scheme.onSurface.withValues(alpha: 0.65), size: context.dupraScaledIconSize(22)),
                  SizedBox(width: context.dupraScaled(10)),
                  Expanded(
                    child: Text(
                      headerTitle,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: scheme.onSurface.withValues(alpha: 0.65),
                      ),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  if (headerTrailing != null) Flexible(child: headerTrailing!),
                ],
              ),
            ),
          ),
          body,
        ],
      ),
    );
  }
}
