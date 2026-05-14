part of '../bookings_tab_view.dart';

/// Same height for open and booked cells so each row lines up cleanly (compact grid only).
const double _kCourtCellHeight = 118;

class _SlotRowCompact extends StatelessWidget {
  const _SlotRowCompact({
    required this.slotStartMinutes,
    required this.lookup,
    required this.selectedDate,
    required this.onOpenTap,
    required this.onDeleteMineBooking,
  });

  final int slotStartMinutes;
  final Map<(int, int), BookingDto> lookup;
  final DateTime selectedDate;
  final Future<void> Function({required DateTime selectedDate, required int slotStartMinutes, required int courtNo})
  onOpenTap;
  final Future<void> Function(BookingDto booking, DateTime selectedDate) onDeleteMineBooking;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final timeLabel = formatSlotRangeLabel(slotStartMinutes);

    return DecoratedBox(
      decoration: BoxDecoration(
        color: scheme.surfaceContainerHighest.withValues(alpha: 0.45),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: scheme.outlineVariant.withValues(alpha: 0.5)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 86,
              height: _kCourtCellHeight,
              child: Padding(
                padding: const EdgeInsets.only(left: 4),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    timeLabel,
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      fontFeatures: const [FontFeature.tabularFigures()],
                      fontWeight: FontWeight.w700,
                      height: 1.15,
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  for (var court = 1; court <= CourtSchedule.courtCount; court++)
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(left: court == 1 ? 0 : 6),
                        child: Builder(
                          builder: (context) {
                            final b = lookup[(slotStartMinutes, court)];
                            return _CourtCell(
                              courtNo: court,
                              booking: b,
                              compact: true,
                              showCourtLabel: true,
                              onBookedTap: b != null ? () => showBookingDetailsSheet(context, b) : null,
                              onDeleteMine: b != null && b.isMine && (b.objectId?.trim().isNotEmpty ?? false)
                                  ? () => onDeleteMineBooking(b, selectedDate)
                                  : null,
                              onOpenTap: b == null
                                  ? () => onOpenTap(
                                      selectedDate: selectedDate,
                                      slotStartMinutes: slotStartMinutes,
                                      courtNo: court,
                                    )
                                  : null,
                            );
                          },
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Accessibility: stacked layout — time row, then one full-width row per court (Supra `BookingsTestPage`).
class _SlotRowStacked extends StatelessWidget {
  const _SlotRowStacked({
    required this.slotStartMinutes,
    required this.lookup,
    required this.selectedDate,
    required this.onOpenTap,
    required this.onDeleteMineBooking,
  });

  final int slotStartMinutes;
  final Map<(int, int), BookingDto> lookup;
  final DateTime selectedDate;
  final Future<void> Function({required DateTime selectedDate, required int slotStartMinutes, required int courtNo})
  onOpenTap;
  final Future<void> Function(BookingDto booking, DateTime selectedDate) onDeleteMineBooking;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final timeLabel = formatSlotRangeLabel(slotStartMinutes);

    return DecoratedBox(
      decoration: BoxDecoration(
        color: scheme.surfaceContainerHighest.withValues(alpha: 0.45),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: scheme.outlineVariant.withValues(alpha: 0.5)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              timeLabel,
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontFeatures: const [FontFeature.tabularFigures()],
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 10),
            for (var court = 1; court <= CourtSchedule.courtCount; court++) ...[
              if (court > 1) const SizedBox(height: 8),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 88,
                    child: Text(
                      '$court',
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        color: scheme.onSurfaceVariant,
                        fontWeight: FontWeight.w600,
                        fontFeatures: const [FontFeature.tabularFigures()],
                      ),
                    ),
                  ),
                  Expanded(
                    child: Builder(
                      builder: (context) {
                        final b = lookup[(slotStartMinutes, court)];
                        return _CourtCell(
                          courtNo: court,
                          booking: b,
                          compact: false,
                          showCourtLabel: false,
                          onBookedTap: b != null ? () => showBookingDetailsSheet(context, b) : null,
                          onDeleteMine: b != null && b.isMine && (b.objectId?.trim().isNotEmpty ?? false)
                              ? () => onDeleteMineBooking(b, selectedDate)
                              : null,
                          onOpenTap: b == null
                              ? () => onOpenTap(
                                  selectedDate: selectedDate,
                                  slotStartMinutes: slotStartMinutes,
                                  courtNo: court,
                                )
                              : null,
                        );
                      },
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _CourtCell extends StatelessWidget {
  const _CourtCell({
    required this.courtNo,
    required this.booking,
    required this.compact,
    required this.showCourtLabel,
    this.onBookedTap,
    this.onOpenTap,
    this.onDeleteMine,
  });

  final int courtNo;
  final BookingDto? booking;
  final bool compact;
  final bool showCourtLabel;
  final VoidCallback? onBookedTap;
  final VoidCallback? onOpenTap;
  final VoidCallback? onDeleteMine;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final booked = booking != null;

    if (!booked) {
      final openContent = Row(
        children: [
          Icon(Icons.circle_outlined, size: compact ? 14 : 18, color: DupraColors.success.withValues(alpha: 0.9)),
          const SizedBox(width: 4),
          Text(
            'Open',
            style: Theme.of(
              context,
            ).textTheme.titleSmall?.copyWith(color: DupraColors.success, fontWeight: FontWeight.w600),
          ),
        ],
      );

      if (!compact) {
        final openCard = Material(
          color: scheme.surface.withValues(alpha: 0.65),
          borderRadius: BorderRadius.circular(10),
          child: Padding(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10), child: openContent),
        );
        if (onOpenTap == null) return openCard;
        return InkWell(borderRadius: BorderRadius.circular(10), onTap: onOpenTap, child: openCard);
      }

      final openCard = SizedBox(
        height: _kCourtCellHeight,
        width: double.infinity,
        child: Material(
          color: scheme.surface.withValues(alpha: 0.65),
          borderRadius: BorderRadius.circular(10),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (showCourtLabel)
                  Text(
                    'Court $courtNo',
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(color: scheme.onSurfaceVariant),
                  ),
                if (showCourtLabel) const SizedBox(height: 4),
                openContent,
                const Spacer(),
              ],
            ),
          ),
        ),
      );
      if (onOpenTap == null) return openCard;
      return InkWell(borderRadius: BorderRadius.circular(10), onTap: onOpenTap, child: openCard);
    }

    final b = booking!;
    final dn = b.displayName?.trim();
    final name = (dn != null && dn.isNotEmpty) ? dn : 'Booked';

    final mine = b.isMine;
    final courtFill = DupraColors.courtBookedFill(courtNo);
    final border = mine
        ? Border.all(color: Colors.white.withValues(alpha: 0.5), width: 2)
        : Border.all(color: Colors.black.withValues(alpha: 0.12));

    final pic = (b.profilePictureUrl?.trim().isNotEmpty ?? false) ? b.profilePictureUrl : b.profile?.profilePictureUrl;

    final gid = b.groupBookingId;
    final showAvatar = gid == null || gid <= 0;

    final radius = BorderRadius.circular(12);
    final inner = Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
      child: compact
          ? _BookedCompactBody(
              courtNo: courtNo,
              showCourtLabel: showCourtLabel,
              name: name,
              mine: mine,
              imageUrl: pic,
              showAvatar: showAvatar,
            )
          : _BookedStackedBody(name: name, mine: mine, imageUrl: pic, showAvatar: showAvatar),
    );

    final card = Container(
      decoration: BoxDecoration(borderRadius: radius, border: border),
      child: compact ? SizedBox(height: _kCourtCellHeight, width: double.infinity, child: inner) : inner,
    );

    final bookedBody = onBookedTap != null
        ? InkWell(
            borderRadius: radius,
            onTap: onBookedTap,
            splashColor: Colors.white.withValues(alpha: 0.25),
            highlightColor: Colors.white.withValues(alpha: 0.12),
            child: card,
          )
        : card;

    return Material(
      color: courtFill,
      surfaceTintColor: Colors.transparent,
      shadowColor: Colors.transparent,
      borderRadius: radius,
      child: onDeleteMine == null
          ? bookedBody
          : Stack(
              children: [
                bookedBody,
                Positioned(
                  top: 6,
                  right: 6,
                  child: _MineBookingDeleteButton(compact: compact, onPressed: onDeleteMine!),
                ),
              ],
            ),
    );
  }
}

class _MineBookingDeleteButton extends StatelessWidget {
  const _MineBookingDeleteButton({required this.compact, required this.onPressed});

  final bool compact;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final diameter = compact ? 40.0 : 44.0;
    final iconSize = compact ? 20.0 : 22.0;
    return Semantics(
      button: true,
      label: 'Remove booking',
      child: Tooltip(
        message: 'Remove booking',
        child: Material(
          color: Colors.transparent,
          elevation: 2,
          shadowColor: Colors.black.withValues(alpha: 0.45),
          shape: const CircleBorder(),
          child: InkWell(
            customBorder: const CircleBorder(),
            onTap: onPressed,
            splashColor: Colors.white.withValues(alpha: 0.25),
            highlightColor: Colors.white.withValues(alpha: 0.12),
            child: Ink(
              width: diameter,
              height: diameter,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.black.withValues(alpha: 0.52),
                border: Border.all(color: Colors.white.withValues(alpha: 0.42), width: 1.5),
              ),
              child: Center(
                child: Icon(Icons.delete_outline_rounded, size: iconSize, color: Colors.white),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _BookedCompactBody extends StatelessWidget {
  const _BookedCompactBody({
    required this.courtNo,
    required this.showCourtLabel,
    required this.name,
    required this.mine,
    required this.showAvatar,
    this.imageUrl,
  });

  final int courtNo;
  final bool showCourtLabel;
  final String name;
  final bool mine;
  final bool showAvatar;
  final String? imageUrl;

  static const Color _onCourt = Color(0xFFFFFFFF);
  static final Color _onCourtMuted = Colors.white.withValues(alpha: 0.88);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (showCourtLabel)
          Row(
            children: [
              Flexible(
                child: Text(
                  'Court $courtNo',
                  style: Theme.of(
                    context,
                  ).textTheme.labelSmall?.copyWith(color: _onCourtMuted, fontWeight: FontWeight.w600),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        if (showCourtLabel) const SizedBox(height: 4),
        Row(
          children: [
            if (showAvatar) ...[
              DupraAvatar(displayName: name, imageUrl: imageUrl, radius: 14),
              const SizedBox(width: 8),
            ],
            Expanded(
              child: Text(
                name,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(
                  context,
                ).textTheme.titleSmall?.copyWith(color: _onCourt, fontWeight: FontWeight.w600, height: 1.15),
              ),
            ),
          ],
        ),
        const Spacer(),
      ],
    );
  }
}

class _BookedStackedBody extends StatelessWidget {
  const _BookedStackedBody({required this.name, required this.mine, required this.showAvatar, this.imageUrl});

  final String name;
  final bool mine;
  final bool showAvatar;
  final String? imageUrl;

  static const Color _onCourt = Color(0xFFFFFFFF);

  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(
      context,
    ).textTheme.titleSmall?.copyWith(color: _onCourt, fontWeight: FontWeight.w600, height: 1.15);

    if (!showAvatar) {
      return Text(name, style: textStyle);
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DupraAvatar(displayName: name, imageUrl: imageUrl, radius: 18),
        const SizedBox(width: 10),
        Expanded(child: Text(name, style: textStyle)),
        if (mine) ...[const SizedBox(width: 8, height: 34)],
      ],
    );
  }
}
