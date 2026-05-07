part of '../profile_stub_page.dart';

/// Circular avatar over the header image, tappable to change photo.
class _AvatarBlock extends StatelessWidget {
  const _AvatarBlock({
    required this.radius,
    required this.uploading,
    required this.profile,
    required this.snapshot,
    required this.onTap,
  });

  final double radius;
  final bool uploading;
  final BasicProfileDTO? profile;
  final SessionSnapshot? snapshot;
  final VoidCallback? onTap;

  String? _photo() {
    final fromProfile = profile?.profilePictureUrl?.trim();
    if (fromProfile != null && fromProfile.isNotEmpty) return fromProfile;
    final fromSession = snapshot?.avatarUrl?.trim();
    if (fromSession != null && fromSession.isNotEmpty) return fromSession;
    return null;
  }

  String _label() {
    final first = profile?.firstName?.trim() ?? '';
    final last = profile?.lastName?.trim() ?? '';
    final combined = '$first $last'.trim();
    if (combined.isNotEmpty) return combined;
    final n = snapshot?.displayName?.trim();
    if (n != null && n.isNotEmpty) return n;
    final e = snapshot?.email?.trim();
    if (e != null && e.isNotEmpty) return e.split('@').first;
    return 'Member';
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        customBorder: const CircleBorder(),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(color: Colors.black.withValues(alpha: 0.35), blurRadius: 20, offset: const Offset(0, 8)),
                  BoxShadow(color: scheme.primary.withValues(alpha: 0.15), spreadRadius: 3),
                ],
              ),
              child: DupraAvatar(radius: radius, displayName: _label(), imageUrl: _photo(), loading: uploading),
            ),
            Positioned(
              right: 2,
              bottom: 2,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: scheme.primaryContainer,
                  shape: BoxShape.circle,
                  border: Border.all(color: scheme.surface, width: 2),
                  boxShadow: [
                    BoxShadow(color: Colors.black.withValues(alpha: 0.2), blurRadius: 6, offset: const Offset(0, 2)),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(7),
                  child: Icon(Icons.camera_alt_rounded, size: 20, color: scheme.onPrimaryContainer),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Label + value column for read-only profile fields.
class _ReadOnlyLine extends StatelessWidget {
  const _ReadOnlyLine({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final scheme = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: textTheme.labelLarge?.copyWith(
            //color: scheme.onSurfaceVariant,
            fontWeight: FontWeight.w600,
            height: 1.25,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: textTheme.titleSmall?.copyWith(color: scheme.onSurfaceVariant, fontWeight: FontWeight.w500),
        ),
      ],
    );
  }
}

class _PrivacyReadRow extends StatelessWidget {
  const _PrivacyReadRow({required this.label, required this.enabled});

  final String label;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    return DupraIconRow(
      icon: enabled ? Icons.visibility_outlined : Icons.visibility_off_outlined,
      iconAccentColor: enabled ? DupraColors.success : scheme.onSurfaceVariant,
      leadingEdgeAccent: true,
      showIconBackground: false,
      contentPadding: const EdgeInsets.symmetric(horizontal: 10),
      trailing: Text(
        enabled ? 'Yes' : 'No',
        style: textTheme.labelLarge?.copyWith(
          color: enabled ? DupraColors.success : scheme.onSurfaceVariant,
          fontWeight: FontWeight.w700,
        ),
      ),
      child: Text(label, style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
    );
  }
}

class _PrivacyEditRow extends StatelessWidget {
  const _PrivacyEditRow({required this.title, required this.subtitle, required this.onChanged, required this.value});

  final String title;
  final String subtitle;
  final void Function(bool)? onChanged;
  final bool value;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    return SwitchListTile.adaptive(
      contentPadding: const EdgeInsets.symmetric(horizontal: 10),
      title: Text(title),
      subtitle: Text(subtitle, style: textTheme.bodySmall?.copyWith(color: scheme.onSurfaceVariant)),
      value: value,
      onChanged: onChanged,
    );
  }
}

/// Full-screen dimmer while a new profile photo uploads.
class _ProfilePhotoUploadOverlay extends StatelessWidget {
  const _ProfilePhotoUploadOverlay();

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    return Positioned.fill(
      child: ColoredBox(
        color: Colors.black38,
        child: Center(
          child: Card(
            elevation: 6,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    width: 36,
                    height: 36,
                    child: CircularProgressIndicator(strokeWidth: 2.8, color: scheme.primary),
                  ),
                  const SizedBox(height: 12),
                  Text('Uploading photo…', style: textTheme.titleSmall),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
