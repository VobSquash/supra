part of '../bookings_page.dart';

class _BookingStatusChip extends StatelessWidget {
  const _BookingStatusChip({required this.label, required this.kind});

  final String label;
  final BookingStatusKind kind;

  Color _fg(ColorScheme scheme) {
    switch (kind) {
      case BookingStatusKind.confirmed:
        return DupraColors.success;
      case BookingStatusKind.pending:
        return DupraColors.warning;
      case BookingStatusKind.cancelled:
        return scheme.onSurfaceVariant;
    }
  }

  Color _bg(ColorScheme scheme) => _fg(scheme).withValues(alpha: 0.14);

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final fg = _fg(scheme);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: _bg(scheme),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
          color: fg,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
