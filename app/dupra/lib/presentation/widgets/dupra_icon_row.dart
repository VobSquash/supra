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
    super.key,
  });

  final IconData icon;
  final Color iconAccentColor;
  final Widget child;
  final Widget? trailing;
  final bool leadingEdgeAccent;
  final bool showIconBackground;
  final VoidCallback? onTap;

  /// Inner icon diameter-ish (home tiles use 32).
  final double iconSize;

  final double gapAfterIcon;

  /// When set, overrides default padding from [leadingEdgeAccent].
  final EdgeInsets? contentPadding;
  final (String displayName, String? imageUrl, double radius)? useAvatarIcon;

  static const double _accentBarWidth = 5;

  EdgeInsets get _effectivePadding =>
      contentPadding ??
      (leadingEdgeAccent
          ? const EdgeInsets.fromLTRB(13, 12, 20, 12)
          : const EdgeInsets.symmetric(horizontal: 20, vertical: 12));

  @override
  Widget build(BuildContext context) {
    final inner = Padding(
      padding: _effectivePadding,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: showIconBackground
                ? BoxDecoration(color: iconAccentColor.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(12))
                : null,
            child: useAvatarIcon != null
                ? DupraAvatar(displayName: useAvatarIcon!.$1, imageUrl: useAvatarIcon!.$2, radius: useAvatarIcon!.$3)
                : Icon(icon, size: iconSize, color: iconAccentColor),
          ),
          SizedBox(width: gapAfterIcon),
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
