import 'package:client_models/client_models.dart';
import 'package:dupra/engine/accessibility/dupra_build_context_accessibility.dart';
import 'package:dupra/engine/launch_service.dart';
import 'package:dupra/engine/theme/dupra_colors.dart';
import 'package:dupra/presentation/widgets/dupra_avatar.dart';
import 'package:flutter/material.dart';

const _launch = LaunchService();

/// Presents [booking] in a modal bottom sheet — header, booking facts, optional contact.
/// Ported from Supra `booking_details_sheet.dart`.
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
      padding: context.dupraScaledEdgeInsetsSymmetric(horizontal: 16).copyWith(bottom: context.dupraScaled(24)),
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
                icon: Icon(Icons.close, size: context.dupraScaledIconSize(24)),
                onPressed: () => Navigator.of(context).pop(),
                color: scheme.onSurface,
              ),
            ],
          ),
          SizedBox(height: context.dupraScaled(8)),
          Center(
            child: DupraAvatar(
              displayName: titleLine,
              imageUrl: booking.profilePictureUrl ?? profile?.profilePictureUrl,
              radius: context.dupraScaledIconSize(36),
            ),
          ),
          SizedBox(height: context.dupraScaled(12)),
          Text(
            titleLine,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: scheme.onSurface,
                ),
          ),
          SizedBox(height: context.dupraScaled(24)),
          Text(
            'Booking details',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: scheme.onSurface,
                ),
          ),
          SizedBox(height: context.dupraScaled(12)),
          _InfoRow(
            icon: Icons.sports_tennis,
            label: 'Court',
            value: booking.courtNo != null ? 'Court ${booking.courtNo}' : '—',
          ),
          SizedBox(height: context.dupraScaled(8)),
          _InfoRow(
            icon: Icons.calendar_today_outlined,
            label: 'Date',
            value: u != null ? DateTime(u.year, u.month, u.day).formateDateForUi() : '—',
          ),
          SizedBox(height: context.dupraScaled(8)),
          _InfoRow(
            icon: Icons.schedule,
            label: 'Time',
            value: u != null
                ? DateTime(u.year, u.month, u.day, u.hour, u.minute).formateTimeFromDate()
                : '—',
          ),
          if (booking.isMine) ...[
            SizedBox(height: context.dupraScaled(12)),
            Align(
              alignment: Alignment.centerLeft,
              child: Container(
                padding: context.dupraScaledEdgeInsetsSymmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: DupraColors.secondary.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  'Your booking',
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        color: DupraColors.secondary,
                        fontWeight: FontWeight.w700,
                      ),
                ),
              ),
            ),
          ],
          if (hasContact && profile != null) ...[
            Divider(height: context.dupraScaled(32)),
            Text(
              'Contact',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: scheme.onSurface,
                  ),
            ),
            SizedBox(height: context.dupraScaled(12)),
            if (showEmail)
              _InfoRow(
                icon: Icons.email_outlined,
                label: 'Email',
                value: profile.email!.trim(),
                onTap: () => _launchEmail(profile.email),
              ),
            if (showEmail && showPhone) SizedBox(height: context.dupraScaled(8)),
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
  await _launch.launchEmail(e);
}

Future<void> _launchTel(String? raw) async {
  final t = raw?.trim();
  if (t == null || t.isEmpty) return;
  await _launch.launchDialer(t);
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
          padding: context.dupraScaledEdgeInsetsSymmetric(horizontal: 12, vertical: 8),
          child: Row(
            children: [
              Container(
                padding: EdgeInsets.all(context.dupraScaled(10)),
                decoration: BoxDecoration(
                  color: scheme.onSurface.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Icon(
                  icon,
                  size: context.dupraScaledIconSize(22),
                  color: scheme.onSurface.withValues(alpha: 0.75),
                ),
              ),
              SizedBox(width: context.dupraScaled(12)),
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
                    SizedBox(height: context.dupraScaled(2)),
                    Text(
                      value,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: muted),
                    ),
                  ],
                ),
              ),
              if (onTap != null)
                Icon(Icons.chevron_right, size: context.dupraScaledIconSize(20), color: muted),
            ],
          ),
        ),
      ),
    );
  }
}
