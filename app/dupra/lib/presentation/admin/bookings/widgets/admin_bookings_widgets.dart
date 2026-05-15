part of '../../admin_bookings_placeholder_page.dart';

class _SlotDropdown<T> extends StatelessWidget {
  const _SlotDropdown({
    required this.label,
    required this.value,
    required this.items,
    required this.itemLabel,
    required this.onChanged,
    this.enabled = true,
  });

  final String label;
  final T value;
  final List<T> items;
  final String Function(T) itemLabel;
  final ValueChanged<T?> onChanged;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return InputDecorator(
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: scheme.surfaceContainerHighest.withValues(alpha: 0.35),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: scheme.outline.withValues(alpha: 0.28)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: DupraColors.secondary.withValues(alpha: 0.85), width: 1.5),
        ),
        enabled: enabled,
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<T>(
          isExpanded: true,
          value: value,
          items: items
              .map(
                (m) => DropdownMenuItem<T>(
                  value: m,
                  child: Text(itemLabel(m), overflow: TextOverflow.ellipsis),
                ),
              )
              .toList(),
          onChanged: enabled ? onChanged : null,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: scheme.onSurface),
        ),
      ),
    );
  }
}

/// Grey when off, court colour when on (avoids M3 [FilterChip] colour inversion).
class _CourtToggleChip extends StatelessWidget {
  const _CourtToggleChip({
    required this.courtIndex,
    required this.selected,
    required this.onChanged,
    required this.enabled,
  });

  final int courtIndex;
  final bool selected;
  final ValueChanged<bool> onChanged;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final courtColor = DupraColors.courtBookedFill(courtIndex);
    final greyBg = scheme.surfaceContainerHighest.withValues(alpha: 0.72);
    final greyBorder = scheme.outline.withValues(alpha: 0.55);
    final avatarGrey = scheme.onSurfaceVariant.withValues(alpha: 0.42);

    return Semantics(
      selected: selected,
      button: true,
      label: 'Court $courtIndex, ${selected ? 'selected' : 'not selected'}',
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: enabled ? () => onChanged(!selected) : null,
          borderRadius: BorderRadius.circular(32),
          child: Ink(
            decoration: BoxDecoration(
              color: selected ? courtColor.withValues(alpha: 0.38) : greyBg,
              borderRadius: BorderRadius.circular(32),
              border: Border.all(color: selected ? courtColor : greyBorder, width: selected ? 2 : 1.25),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircleAvatar(
                    radius: 15,
                    backgroundColor: selected ? courtColor : avatarGrey,
                    child: Text(
                      '$courtIndex',
                      style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w700),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    'Court $courtIndex',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: selected ? scheme.onSurface : scheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _AdminBookingRow extends StatelessWidget {
  const _AdminBookingRow({required this.booking, required this.scheme, required this.onDelete, required this.enabled});

  final BookingDto booking;
  final ColorScheme scheme;
  final VoidCallback onDelete;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final court = booking.courtNo ?? 0;
    final courtColor = court >= 1 && court <= 3 ? DupraColors.courtBookedFill(court) : scheme.primary;

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Material(
        color: scheme.surfaceContainerHighest.withValues(alpha: 0.38),
        borderRadius: BorderRadius.circular(16),
        clipBehavior: Clip.antiAlias,
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(width: 5, color: courtColor),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(14, 12, 8, 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        booking.displayName ?? '—',
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Court $court · ${adminBookingsFormatWallUtc(booking.bookingDate)} · Group ${booking.groupBookingId ?? 0}',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(color: DupraColors.textSecondary),
                      ),
                    ],
                  ),
                ),
              ),
              IconButton(
                tooltip: 'Delete',
                onPressed: enabled ? onDelete : null,
                icon: Icon(Icons.delete_outline_rounded, color: scheme.error.withValues(alpha: enabled ? 1 : 0.35)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
