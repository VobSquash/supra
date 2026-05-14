import 'package:dupra/engine/theme/dupra_colors.dart';
import 'package:dupra/presentation/widgets/dupra_icon_row.dart';
import 'package:flutter/material.dart';

/// Same chrome as member-profile contact rows (`DupraIconRow` + chevron); wire [onPressed] to `showDupraContactActionSheet`.
class DupraActionIconRow extends StatelessWidget {
  const DupraActionIconRow({
    required this.scheme,
    required this.textTheme,
    required this.icon,
    required this.iconAccentColor,
    required this.label,
    required this.value,
    required this.onPressed,
    this.wrapWithCard = false,
    super.key,
  });

  final ColorScheme scheme;
  final TextTheme textTheme;
  final IconData icon;
  final Color iconAccentColor;
  final String label;
  final String value;
  final VoidCallback onPressed;
  final bool wrapWithCard;

  @override
  Widget build(BuildContext context) {
    final row = DupraIconRow(
      onTap: onPressed,
      contentPadding: const EdgeInsets.only(left: 15, right: 5, top: 12, bottom: 12),
      icon: icon,
      iconAccentColor: iconAccentColor,
      leadingEdgeAccent: true,
      trailing: IconButton(
        onPressed: onPressed,
        icon: Icon(Icons.chevron_right_rounded, color: scheme.onSurfaceVariant),
      ),
      child: _DupraContactLabelValue(
        label: label,
        value: value,
        textTheme: textTheme,
        scheme: scheme,
        emphasizeValue: true,
      ),
    );
    return wrapWithCard
        ? Card(
            elevation: 0,
            margin: EdgeInsets.zero,
            clipBehavior: Clip.antiAlias,
            color: DupraColors.primary,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side: BorderSide(color: scheme.onSurface.withValues(alpha: 0.1)),
            ),
            child: row,
          )
        : row;
  }
}

/// Matches profile `_MemberProfileLabelValue` typography.
class _DupraContactLabelValue extends StatelessWidget {
  const _DupraContactLabelValue({
    required this.label,
    required this.value,
    required this.textTheme,
    required this.scheme,
    this.emphasizeValue = false,
  });

  final String label;
  final String value;
  final TextTheme textTheme;
  final ColorScheme scheme;
  final bool emphasizeValue;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w600, height: 1.25)),
        const SizedBox(height: 4),
        Text(
          value,
          style: emphasizeValue
              ? textTheme.titleSmall?.copyWith(color: scheme.primary, fontWeight: FontWeight.w600)
              : textTheme.titleSmall?.copyWith(color: scheme.onSurfaceVariant, fontWeight: FontWeight.w500),
        ),
      ],
    );
  }
}
