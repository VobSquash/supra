part of '../bookings_page.dart';

class _BookingListRow extends StatelessWidget {
  const _BookingListRow({required this.booking});

  final SampleBooking booking;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final base = scheme.surfaceContainerHighest.withValues(alpha: 0.55);

    return Card(
      elevation: 0,
      margin: EdgeInsets.zero,
      color: base,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: scheme.onSurface.withValues(alpha: 0.1)),
      ),
      child: InkWell(
        onTap: () {},
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(14, 12, 12, 12),
          child: Row(
            children: [
              DecoratedBox(
                decoration: BoxDecoration(
                  color: DupraColors.secondary.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Padding(
                  padding: EdgeInsets.all(10),
                  child: Icon(Icons.calendar_today_rounded, color: DupraColors.secondary, size: 24),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      booking.courtLabel,
                      style: textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: scheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${_formatBookingDay(booking.start)} · ${_formatBookingRange(booking.start, booking.end)}',
                      style: textTheme.bodyMedium?.copyWith(color: scheme.onSurfaceVariant),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      booking.organizer,
                      style: textTheme.bodySmall?.copyWith(color: scheme.onSurface.withValues(alpha: 0.65)),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              _BookingStatusChip(label: booking.statusLabel, kind: booking.statusKind),
            ],
          ),
        ),
      ),
    );
  }
}
