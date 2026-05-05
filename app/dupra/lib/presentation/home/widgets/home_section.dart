part of '../home_overview_tab.dart';

class HomeSection extends StatelessWidget {
  const HomeSection({
    required this.title,
    required this.items,
    required this.onItemTap,
    this.cardAccent,
    super.key,
  });

  final String title;
  final List<HomeSectionItem> items;
  final void Function(int index) onItemTap;
  final Color? cardAccent;

  static const double _cardRadius = 16;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    final titleStyle = textTheme.bodyLarge?.copyWith(
      color: scheme.onSurface,
      fontSize: 16,
      fontWeight: FontWeight.w800,
      letterSpacing: 0.5,
    );

    final baseCard = scheme.surfaceContainerHighest.withValues(alpha: 0.55);
    final accent = cardAccent;
    final cardColor = accent == null ? baseCard : Color.alphaBlend(accent.withValues(alpha: 0.1), baseCard);
    final borderColor = accent == null
        ? scheme.onSurface.withValues(alpha: 0.1)
        : Color.alphaBlend(accent.withValues(alpha: 0.4), scheme.onSurface.withValues(alpha: 0.08));

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 16, right: 16, bottom: 12),
            child: Text(title, style: titleStyle, maxLines: 2, overflow: TextOverflow.ellipsis),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Card(
              elevation: 0,
              margin: EdgeInsets.zero,
              clipBehavior: Clip.antiAlias,
              color: cardColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(_cardRadius),
                side: BorderSide(color: borderColor),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  for (var i = 0; i < items.length; i++) ...[
                    _HomeSectionItemTile(
                      item: items[i],
                      index: i,
                      itemCount: items.length,
                      cardRadius: _cardRadius,
                      onTap: () => onItemTap(i),
                    ),
                    if (i < items.length - 1)
                      Divider(height: 1, color: scheme.onSurface.withValues(alpha: 0.1)),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _HomeSectionItemTile extends StatelessWidget {
  const _HomeSectionItemTile({
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

  static const double _kAccentWidth = 5;

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

    final contentPadding = item.leadingEdgeAccent
        ? const EdgeInsets.fromLTRB(13, 12, 20, 12)
        : const EdgeInsets.symmetric(horizontal: 20, vertical: 12);

    final inner = Padding(
      padding: contentPadding,
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: item.accentColor.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(item.icon, size: 32, color: item.accentColor),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.title,
                  style: textTheme.titleMedium?.copyWith(
                    color: scheme.onSurface,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                if (item.subtitle != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    item.subtitle!,
                    style: textTheme.bodyMedium?.copyWith(
                      color: scheme.onSurface.withValues(alpha: 0.7),
                      fontSize: 14,
                    ),
                  ),
                ],
              ],
            ),
          ),
          Icon(Icons.chevron_right_rounded, color: scheme.onSurface.withValues(alpha: 0.6), size: 32),
        ],
      ),
    );

    final Widget tile = item.leadingEdgeAccent
        ? DecoratedBox(
            decoration: BoxDecoration(
              border: Border(left: BorderSide(width: _kAccentWidth, color: item.accentColor)),
            ),
            child: inner,
          )
        : inner;

    return Material(
      color: Colors.transparent,
      child: InkWell(onTap: onTap, borderRadius: splashRadius, child: tile),
    );
  }
}
