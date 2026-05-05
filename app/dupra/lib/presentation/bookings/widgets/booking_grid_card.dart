part of '../bookings_page.dart';

class _BookingGridCard extends StatelessWidget {
  const _BookingGridCard({required this.booking});

  final SampleBooking booking;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final base = scheme.surfaceContainerHighest.withValues(alpha: 0.55);

    return Card(
      elevation: 0,
      clipBehavior: Clip.antiAlias,
      color: base,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: scheme.onSurface.withValues(alpha: 0.1)),
      ),
      child: InkWell(
        onTap: () {},
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.sports_tennis_rounded, size: 18, color: DupraColors.secondary),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      booking.courtLabel,
                      style: textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: scheme.onSurface,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Text(
                _formatBookingDay(booking.start),
                style: textTheme.labelMedium?.copyWith(color: scheme.onSurfaceVariant),
              ),
              const SizedBox(height: 4),
              Text(
                _formatBookingRange(booking.start, booking.end),
                style: textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: scheme.onSurface,
                ),
              ),
              const Spacer(),
              Text(
                booking.organizer,
                style: textTheme.bodySmall?.copyWith(color: scheme.onSurfaceVariant),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 8),
              _BookingStatusChip(label: booking.statusLabel, kind: booking.statusKind),
            ],
          ),
        ),
      ),
    );
  }
}
