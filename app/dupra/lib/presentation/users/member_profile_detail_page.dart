import 'package:client_models/client_models.dart';
import 'package:dupra/presentation/widgets/dupra_avatar.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

/// Read-only profile for a member; pass as GoRouter `extra` as BasicProfileDTO.
class MemberProfileDetailPage extends StatelessWidget {
  const MemberProfileDetailPage({required this.profile, super.key});

  final BasicProfileDTO profile;

  String get _resolvedDisplayName {
    final n = profile.displayName.trim();
    return n.isEmpty ? 'Member' : n;
  }

  Future<void> _openUri(Uri uri) async {
    final ok = await canLaunchUrl(uri);
    if (!ok) return;
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  String? _formattedDob() {
    final raw = profile.dateOfBirth?.trim();
    if (raw == null || raw.isEmpty) return null;
    try {
      final d = DateTime.parse(raw).toLocal();
      final y = d.year.toString().padLeft(4, '0');
      final m = d.month.toString().padLeft(2, '0');
      final day = d.day.toString().padLeft(2, '0');
      return '$y-$m-$day';
    } catch (_) {
      return raw;
    }
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final ext = profile.extendedProfile;

    final showEmail =
        (ext?.canShowEmail ?? false) && (profile.email?.trim().isNotEmpty ?? false);
    final showPhone = (ext?.canShowContactNumber ?? false) &&
        (profile.contactNumber?.trim().isNotEmpty ?? false);
    final showDob = (ext?.canShowDateOfBirth ?? false) && _formattedDob() != null;

    final membership = ext?.membershipType;
    final membershipLabel = membership == null || membership == MembershipTypeEnum.unknown
        ? 'Unknown'
        : membership.friendlyName;

    final role = ProfileTypeEnum.get(profile.profileType ?? '');
    final roleLabel = _readableProfileRole(role);

    final emergency = profile.emergencyContactNumber?.trim();
    final extEmergency = ext?.emergencyContactNumber?.trim();
    final emergencyLine = emergency != null && emergency.isNotEmpty
        ? emergency
        : (extEmergency != null && extEmergency.isNotEmpty)
            ? extEmergency
            : null;

    return Scaffold(
      appBar: AppBar(title: Text(_resolvedDisplayName)),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DupraAvatar(
                displayName: _resolvedDisplayName,
                imageUrl: profile.profilePictureUrl,
                radius: 44,
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _resolvedDisplayName,
                      style: textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        if (profile.isActive ?? false)
                          Chip(
                            label: const Text('Active'),
                            visualDensity: VisualDensity.compact,
                            backgroundColor: scheme.primary.withValues(alpha: 0.15),
                          ),
                        if (ext?.isCoach ?? false)
                          const Chip(
                            label: Text('Coach'),
                            visualDensity: VisualDensity.compact,
                          ),
                        Chip(
                          label: Text(membershipLabel),
                          visualDensity: VisualDensity.compact,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 28),
          const _SectionTitle(text: 'Account'),
          _DetailTile(
            label: 'Role',
            value: roleLabel,
          ),
          if (profile.vobGuid?.trim().isNotEmpty ?? false)
            _DetailTile(
              label: 'Member ID',
              value: profile.vobGuid!.trim(),
            ),
          const SizedBox(height: 20),
          const _SectionTitle(text: 'Contact'),
          if (showEmail)
            _LinkTile(
              label: 'Email',
              value: profile.email!.trim(),
              icon: Icons.mail_outline,
              onOpen: () => _openUri(Uri.parse('mailto:${profile.email!.trim()}')),
            ),
          if (showPhone)
            _LinkTile(
              label: 'Phone',
              value: profile.contactNumber!.trim(),
              icon: Icons.phone_outlined,
              onOpen: () => _openUri(Uri.parse('tel:${profile.contactNumber!.trim()}')),
            ),
          if (showDob)
            _DetailTile(
              label: 'Date of birth',
              value: _formattedDob()!,
            ),
          if (!showEmail && !showPhone && !showDob)
            Padding(
              padding: const EdgeInsets.only(top: 4, bottom: 8),
              child: Text(
                "Contact details are hidden based on this member's privacy settings.",
                style: textTheme.bodyMedium?.copyWith(
                  color: scheme.onSurface.withValues(alpha: 0.72),
                ),
              ),
            ),
          const SizedBox(height: 20),
          const _SectionTitle(text: 'Emergency'),
          _DetailTile(
            label: 'Contact number',
            value: emergencyLine ?? 'Not provided',
            emphasizeValue: emergencyLine != null,
            onTap: emergencyLine != null
                ? () => _openUri(Uri.parse('tel:$emergencyLine'))
                : null,
          ),
        ],
      ),
    );
  }
}

String _readableProfileRole(ProfileTypeEnum role) {
  if (role == ProfileTypeEnum.unknown) {
    return 'Member';
  }
  final parts = role.identifierType.split('_');
  return parts
      .map((w) => w.isEmpty ? w : '${w[0].toUpperCase()}${w.substring(1).toLowerCase()}')
      .join(' ');
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Text(
        text,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w800,
              letterSpacing: 0.4,
            ),
      ),
    );
  }
}

class _DetailTile extends StatelessWidget {
  const _DetailTile({
    required this.label,
    required this.value,
    this.emphasizeValue = false,
    this.onTap,
  });

  final String label;
  final String value;
  final bool emphasizeValue;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final valueStyle = textTheme.bodyLarge?.copyWith(
      fontWeight: emphasizeValue ? FontWeight.w600 : null,
      color: onTap != null ? scheme.primary : scheme.onSurface,
      decoration: onTap != null ? TextDecoration.underline : null,
    );

    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: textTheme.labelLarge?.copyWith(
              color: scheme.onSurface.withValues(alpha: 0.65),
            ),
          ),
          const SizedBox(height: 4),
          GestureDetector(
            onTap: onTap,
            child: Text(value, style: valueStyle),
          ),
        ],
      ),
    );
  }
}

class _LinkTile extends StatelessWidget {
  const _LinkTile({
    required this.label,
    required this.value,
    required this.icon,
    required this.onOpen,
  });

  final String label;
  final String value;
  final IconData icon;
  final VoidCallback onOpen;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Material(
        color: scheme.surfaceContainerHighest.withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: onOpen,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            child: Row(
              children: [
                Icon(icon, size: 22, color: scheme.primary),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        label,
                        style: Theme.of(context).textTheme.labelMedium?.copyWith(
                              color: scheme.onSurface.withValues(alpha: 0.65),
                            ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        value,
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              color: scheme.primary,
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                    ],
                  ),
                ),
                Icon(Icons.open_in_new, size: 18, color: scheme.primary.withValues(alpha: 0.7)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
