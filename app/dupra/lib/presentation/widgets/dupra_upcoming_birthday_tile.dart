import 'package:dupra/engine/theme/dupra_colors.dart';
import 'package:dupra/presentation/widgets/dupra_avatar.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// Compact row highlighting a soon-to-occur birthday (admin reminders, member summaries).
class DupraUpcomingBirthdayTile extends StatelessWidget {
  const DupraUpcomingBirthdayTile({
    required this.displayName,
    required this.celebrationDay,
    required this.today,
    super.key,
    this.imageUrl,
    this.onTap,
  });

  final String displayName;
  final String? imageUrl;
  final DateTime celebrationDay;
  final DateTime today;
  final VoidCallback? onTap;

  bool get _isToday => DateUtils.isSameDay(celebrationDay, today);

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    final dateLabel = MaterialLocalizations.of(context).formatMediumDate(celebrationDay);
    final weekday = DateFormat('EEE').format(celebrationDay);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Ink(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            gradient: LinearGradient(
              colors: [
                DupraColors.scaffoldSecondary.withValues(alpha: 0.92),
                scheme.surface.withValues(alpha: 0.45),
              ],
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            child: Row(
              children: [
                DupraAvatar(displayName: displayName, imageUrl: imageUrl, radius: 22),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        displayName.trim().isEmpty ? 'Member' : displayName.trim(),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '$weekday · $dateLabel',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: textTheme.bodySmall?.copyWith(color: scheme.onSurfaceVariant),
                      ),
                    ],
                  ),
                ),
                if (_isToday)
                  Padding(
                    padding: const EdgeInsets.only(right: 6),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: DupraColors.secondary.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Text(
                        'Today',
                        style: textTheme.labelSmall?.copyWith(
                          color: DupraColors.secondary,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.2,
                        ),
                      ),
                    ),
                  ),
                Icon(
                  Icons.celebration_outlined,
                  color: scheme.primary.withValues(alpha: 0.9),
                  size: 22,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
