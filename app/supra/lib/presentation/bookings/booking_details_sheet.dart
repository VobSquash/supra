import 'package:client_models/client_models.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../engine/theme/supra_colors.dart';

/// Presents [booking] in a modal bottom sheet — header, booking facts, optional contact.
Future<void> showBookingDetailsSheet(BuildContext context, BookingDto booking) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    builder: (ctx) {
      return SafeArea(
        child: Padding(
          padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(ctx).bottom),
          child: SingleChildScrollView(
            child: _BookingDetailsContent(booking: booking),
          ),
        ),
      );
    },
  );
}

class _BookingDetailsContent extends StatelessWidget {
  const _BookingDetailsContent({required this.booking});

  final BookingDto booking;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    // Match grid: DB timestamps use UTC wall clock for slot labels (see booking_schedule).
    final u = booking.bookingDate?.toUtc();
    final display = booking.displayName?.trim();
    final profile = booking.profile;
    final ext = profile?.extendedProfile;
    final showEmail = (ext?.canShowEmail ?? false) && (profile?.email?.trim().isNotEmpty ?? false);
    final showPhone =
        (ext?.canShowContactNumber ?? false) && (profile?.contactNumber?.trim().isNotEmpty ?? false);
    final hasContact = showEmail || showPhone;

    final titleLine = (display != null && display.isNotEmpty) ? display : 'Booking';

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'Booking information',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => Navigator.of(context).pop(),
                color: scheme.onSurface,
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            titleLine,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: scheme.onSurface,
                ),
          ),
          const SizedBox(height: 24),
          Text(
            'Booking details',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: scheme.onSurface,
                ),
          ),
          const SizedBox(height: 12),
          _InfoRow(
            icon: Icons.sports_tennis,
            label: 'Court',
            value: booking.courtNo != null ? 'Court ${booking.courtNo}' : '—',
          ),
          const SizedBox(height: 8),
          _InfoRow(
            icon: Icons.calendar_today_outlined,
            label: 'Date',
            value: u != null ? DateTime(u.year, u.month, u.day).formateDateForUi() : '—',
          ),
          const SizedBox(height: 8),
          _InfoRow(
            icon: Icons.schedule,
            label: 'Time',
            value: u != null
                ? DateTime(u.year, u.month, u.day, u.hour, u.minute).formateTimeFromDate()
                : '—',
          ),
          if (booking.isMine) ...[
            const SizedBox(height: 12),
            Align(
              alignment: Alignment.centerLeft,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: SupraColors.secondary.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  'Your booking',
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        color: SupraColors.secondary,
                        fontWeight: FontWeight.w700,
                      ),
                ),
              ),
            ),
          ],
          if (hasContact && profile != null) ...[
            const Divider(height: 32),
            Text(
              'Contact',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: scheme.onSurface,
                  ),
            ),
            const SizedBox(height: 12),
            if (showEmail)
              _InfoRow(
                icon: Icons.email_outlined,
                label: 'Email',
                value: profile.email!.trim(),
                onTap: () => _launchEmail(profile.email),
              ),
            if (showEmail && showPhone) const SizedBox(height: 8),
            if (showPhone)
              _InfoRow(
                icon: Icons.phone_outlined,
                label: 'Contact number',
                value: profile.contactNumber!.trim(),
                onTap: () => _launchTel(profile.contactNumber),
              ),
          ],
        ],
      ),
    );
  }
}

Future<void> _launchEmail(String? raw) async {
  final e = raw?.trim();
  if (e == null || e.isEmpty) return;
  final uri = Uri.parse('mailto:$e');
  if (await canLaunchUrl(uri)) await launchUrl(uri);
}

Future<void> _launchTel(String? raw) async {
  final t = raw?.trim();
  if (t == null || t.isEmpty) return;
  final uri = Uri.parse('tel:${t.replaceAll(RegExp(r'\s+'), '')}');
  if (await canLaunchUrl(uri)) await launchUrl(uri);
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
    this.onTap,
  });

  final IconData icon;
  final String label;
  final String value;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final muted = scheme.onSurface.withValues(alpha: 0.65);

    return Material(
      color: scheme.onSurface.withValues(alpha: 0.05),
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: scheme.onSurface.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Icon(icon, size: 22, color: scheme.onSurface.withValues(alpha: 0.75)),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: scheme.onSurface,
                          ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      value,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: muted),
                    ),
                  ],
                ),
              ),
              if (onTap != null) Icon(Icons.chevron_right, size: 20, color: muted),
            ],
          ),
        ),
      ),
    );
  }
}
