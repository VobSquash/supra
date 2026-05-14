import 'package:dupra/engine/accessibility/dupra_build_context_accessibility.dart';
import 'package:dupra/presentation/widgets/dupra_avatar.dart';
import 'package:flutter/material.dart';

/// Leading icon in a tinted rounded square (home / section pattern) + expanded [child] + optional [trailing].
class DupraIconRow extends StatelessWidget {
  const DupraIconRow({
    required this.icon,
    required this.iconAccentColor,
    required this.child,
    this.trailing,
    this.leadingEdgeAccent = false,
    this.iconSize = 32,
    this.gapAfterIcon = 16,
    this.showIconBackground = true,
    this.contentPadding,
    this.onTap,
    this.useAvatarIcon,
    this.crossAxisAlignment = CrossAxisAlignment.start,
    super.key,
  });

  final IconData icon;
  final Color iconAccentColor;
  final Widget child;
  final Widget? trailing;
  final bool leadingEdgeAccent;
  final bool showIconBackground;
  final VoidCallback? onTap;

  /// Vertical alignment of the leading icon, text, and trailing within the row.
  final CrossAxisAlignment crossAxisAlignment;

  /// Inner icon diameter-ish (home tiles use 32).
  final double iconSize;

  final double gapAfterIcon;

  /// When set, overrides default padding from [leadingEdgeAccent].
  final EdgeInsets? contentPadding;
  final (String displayName, String? imageUrl, double radius)? useAvatarIcon;

  static const double _accentBarWidth = 5;

  static EdgeInsets _scalePadding(BuildContext context, EdgeInsets p) => EdgeInsets.fromLTRB(
        context.dupraScaled(p.left),
        context.dupraScaled(p.top),
        context.dupraScaled(p.right),
        context.dupraScaled(p.bottom),
      );

  @override
  Widget build(BuildContext context) {
    final pad = contentPadding != null
        ? _scalePadding(context, contentPadding!)
        : (leadingEdgeAccent
            ? EdgeInsets.fromLTRB(
                context.dupraScaled(13),
                context.dupraScaled(12),
                context.dupraScaled(20),
                context.dupraScaled(12),
              )
            : context.dupraScaledEdgeInsetsSymmetric(horizontal: 20, vertical: 12));
    final iconPad = context.dupraScaled(10);
    final gap = context.dupraScaled(gapAfterIcon);
    final resolvedIconSize = context.dupraScaledIconSize(iconSize);
    final avatarTriple = useAvatarIcon;
    final inner = Padding(
      padding: pad,
      child: Row(
        crossAxisAlignment: crossAxisAlignment,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.all(iconPad),
            decoration: showIconBackground
                ? BoxDecoration(color: iconAccentColor.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(12))
                : null,
            child: avatarTriple != null
                ? DupraAvatar(
                    displayName: avatarTriple.$1,
                    imageUrl: avatarTriple.$2,
                    radius: context.dupraScaledIconSize(avatarTriple.$3),
                  )
                : Icon(icon, size: resolvedIconSize, color: iconAccentColor),
          ),
          SizedBox(width: gap),
          Expanded(child: child),
          if (trailing != null) trailing!,
        ],
      ),
    );

    if (!leadingEdgeAccent) return inner;

    return GestureDetector(
      onTap: onTap,
      child: DecoratedBox(
        decoration: BoxDecoration(
          border: Border(
            left: BorderSide(width: _accentBarWidth, color: iconAccentColor),
          ),
        ),
        child: inner,
      ),
    );
  }
}
