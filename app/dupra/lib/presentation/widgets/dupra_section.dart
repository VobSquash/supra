import 'package:dupra/engine/accessibility/dupra_build_context_accessibility.dart';
import 'package:dupra/presentation/home/data/home_overview_destination.dart';
import 'package:dupra/presentation/home/data/home_section_item.dart';
import 'package:dupra/presentation/widgets/dupra_icon_row.dart';
import 'package:flutter/material.dart';

typedef DupraSectionNavigate = void Function(BuildContext context, HomeOverviewDestination destination);

/// Section title (+ optional [titleAction]) + card body.
///
/// **List rows:** pass [items] and [onNavigate] when rows navigate via [HomeSectionItem.destination].
/// Rows with `destination == null` are display-only (no chevron, not tappable).
///
/// **Custom body:** pass [cardChild] for non-standard content (e.g. profile edit form).
/// When [cardChild] is non-null, [items] is ignored.
class DupraSection extends StatelessWidget {
  DupraSection({
    required this.title,
    super.key,
    this.items = const [],
    this.onNavigate,
    this.cardAccent,
    this.titleAction,
    this.cardChild,
  }) : assert(cardChild != null || items.isNotEmpty, 'Provide cardChild or at least one item');

  final String title;

  /// When non-null, built to the right of the title (e.g. Edit link, Save/Cancel).
  final Widget? titleAction;

  /// Shown inside the card when [items] is empty or unused. Takes precedence over [items].
  final Widget? cardChild;

  final List<HomeSectionItem> items;

  /// Required for navigable items; may be null when using only [cardChild] or display-only rows.
  final DupraSectionNavigate? onNavigate;

  final Color? cardAccent;

  static const double _cardRadius = 16;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    final titleStyle = textTheme.titleMedium?.copyWith(
      color: scheme.onSurface,
      fontWeight: FontWeight.w800,
      letterSpacing: 0.5,
    );

    final baseCard = scheme.surfaceContainerHighest.withValues(alpha: 0.55);
    final accent = cardAccent;
    final cardColor = accent == null ? baseCard : Color.alphaBlend(accent.withValues(alpha: 0.1), baseCard);
    final borderColor = accent == null
        ? scheme.onSurface.withValues(alpha: 0.1)
        : Color.alphaBlend(accent.withValues(alpha: 0.4), scheme.onSurface.withValues(alpha: 0.08));

    final body = cardChild != null
        ? cardChild!
        : Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              for (var i = 0; i < items.length; i++) ...[
                _DupraSectionItemTile(
                  item: items[i],
                  index: i,
                  itemCount: items.length,
                  cardRadius: _cardRadius,
                  onTap: () {
                    final destination = items[i].destination;
                    if (destination != null) {
                      onNavigate?.call(context, destination);
                    }
                  },
                ),
                if (i < items.length - 1) Divider(height: 1, color: scheme.onSurface.withValues(alpha: 0.1)),
              ],
            ],
          );

    final vPad = context.dupraScaled(12);
    final hPad = context.dupraScaled(16);
    return Padding(
      padding: EdgeInsets.symmetric(vertical: vPad),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(left: hPad, right: hPad, bottom: vPad),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(title, style: titleStyle, maxLines: 2, overflow: TextOverflow.ellipsis),
                ),
                if (titleAction != null) titleAction!,
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: hPad),
            child: Card(
              elevation: 0,
              margin: EdgeInsets.zero,
              clipBehavior: Clip.antiAlias,
              color: cardColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(_cardRadius),
                side: BorderSide(color: borderColor),
              ),
              child: body,
            ),
          ),
        ],
      ),
    );
  }
}

class _DupraSectionItemTile extends StatelessWidget {
  const _DupraSectionItemTile({
    required this.item,
    required this.index,
    required this.itemCount,
    required this.cardRadius,
    required this.onTap,
  });

  final HomeSectionItem item;
  final int index;
  final int itemCount;
  final double cardRadius;
  final VoidCallback onTap;

  static BorderRadius _splashRadius({required int index, required int count, required double r}) {
    if (count <= 1) {
      return BorderRadius.circular(r);
    }
    if (index == 0) {
      return BorderRadius.only(topLeft: Radius.circular(r), topRight: Radius.circular(r));
    }
    if (index == count - 1) {
      return BorderRadius.only(bottomLeft: Radius.circular(r), bottomRight: Radius.circular(r));
    }
    return BorderRadius.zero;
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final splashRadius = _splashRadius(index: index, count: itemCount, r: cardRadius);
    final navigable = item.destination != null;

    final chevronSize = context.dupraScaledIconSize(32);
    final row = DupraIconRow(
      icon: item.icon,
      iconAccentColor: item.accentColor,
      leadingEdgeAccent: item.leadingEdgeAccent,
      trailing: navigable
          ? Icon(Icons.chevron_right_rounded, color: scheme.onSurface.withValues(alpha: 0.6), size: chevronSize)
          : null,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            item.title,
            style: textTheme.bodyLarge?.copyWith(color: scheme.onSurface, fontWeight: FontWeight.w600),
          ),
          if (item.subtitle != null) ...[
            SizedBox(height: context.dupraScaled(4)),
            Text(
              item.subtitle!,
              style: textTheme.bodyMedium?.copyWith(color: scheme.onSurface.withValues(alpha: 0.7)),
            ),
          ],
        ],
      ),
    );

    return Material(
      color: Colors.transparent,
      child: InkWell(onTap: navigable ? onTap : null, borderRadius: splashRadius, child: row),
    );
  }
}
