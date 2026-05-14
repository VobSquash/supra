part of '../profile_stub_page.dart';

/// Main column under the header: loading, account + privacy + password + logout.
class _ProfileScrollContent extends StatelessWidget {
  const _ProfileScrollContent({
    required this.profile,
    required this.formKey,
    required this.firstNameController,
    required this.lastNameController,
    required this.editing,
    required this.saving,
    required this.uploadingPhoto,
    required this.canShowEmail,
    required this.canShowPhone,
    required this.canShowDob,
    required this.membershipLabel,
    required this.firstNameRead,
    required this.lastNameRead,
    required this.emailRead,
    required this.onEdit,
    required this.onCancel,
    required this.onSave,
    required this.onCanShowEmail,
    required this.onCanShowPhone,
    required this.onCanShowDob,
    required this.onPasswordSheet,
    required this.onLogout,
    required this.bottomInset,
  });

  final BasicProfileDTO profile;
  final GlobalKey<FormState> formKey;
  final TextEditingController firstNameController;
  final TextEditingController lastNameController;
  final bool editing;
  final bool saving;
  final bool uploadingPhoto;
  final bool canShowEmail;
  final bool canShowPhone;
  final bool canShowDob;
  final String membershipLabel;
  final String firstNameRead;
  final String lastNameRead;
  final String emailRead;
  final VoidCallback onEdit;
  final VoidCallback onCancel;
  final VoidCallback onSave;
  final ValueChanged<bool> onCanShowEmail;
  final ValueChanged<bool> onCanShowPhone;
  final ValueChanged<bool> onCanShowDob;
  final VoidCallback onPasswordSheet;
  final VoidCallback onLogout;
  final double bottomInset;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    // Read-only labels use saved profile values (defaults match profile_stub_page _applyProfile).
    final savedShowEmail = profile.extendedProfile?.canShowEmail ?? true;
    final savedShowPhone = profile.extendedProfile?.canShowContactNumber ?? true;
    final savedShowDob = profile.extendedProfile?.canShowDateOfBirth ?? false;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,

      children: [
        DupraSection(
          title: 'Account',
          titleAction: editing
              ? Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextButton(onPressed: saving ? null : onCancel, child: const Text('Cancel')),
                    const SizedBox(width: 4),
                    FilledButton(
                      onPressed: (saving || uploadingPhoto) ? null : onSave,
                      style: FilledButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: saving
                          ? SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(strokeWidth: 2, color: scheme.onPrimary),
                            )
                          : const Text('Save'),
                    ),
                  ],
                )
              : DupraLinkButton(label: 'Edit', onPressed: onEdit),
          cardChild: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                DupraIconRow(
                  icon: Icons.person_outline_rounded,
                  iconAccentColor: scheme.primary,
                  leadingEdgeAccent: true,
                  child: editing
                      ? TextFormField(
                          controller: firstNameController,
                          textCapitalization: TextCapitalization.words,
                          decoration: const InputDecoration(
                            labelText: 'First name',
                            border: OutlineInputBorder(),
                            isDense: true,
                          ),
                          validator: (v) {
                            if ((v ?? '').trim().isEmpty) return 'Enter your first name';
                            return null;
                          },
                        )
                      : _ReadOnlyLine(label: 'First name', value: firstNameRead),
                ),
                Divider(height: 1, color: scheme.onSurface.withValues(alpha: 0.1)),
                DupraIconRow(
                  icon: Icons.badge_outlined,
                  iconAccentColor: scheme.primary,
                  leadingEdgeAccent: true,
                  child: editing
                      ? TextFormField(
                          controller: lastNameController,
                          textCapitalization: TextCapitalization.words,
                          decoration: const InputDecoration(
                            labelText: 'Last name',
                            border: OutlineInputBorder(),
                            isDense: true,
                          ),
                          validator: (v) {
                            if ((v ?? '').trim().isEmpty) return 'Enter your last name';
                            return null;
                          },
                        )
                      : _ReadOnlyLine(label: 'Last name', value: lastNameRead),
                ),
                Divider(height: 1, color: scheme.onSurface.withValues(alpha: 0.1)),
                DupraIconRow(
                  icon: Icons.mail_outline_rounded,
                  iconAccentColor: scheme.primary,
                  leadingEdgeAccent: true,
                  child: _ReadOnlyLine(label: 'Email', value: emailRead),
                ),
                Divider(height: 1, color: scheme.onSurface.withValues(alpha: 0.1)),
                DupraIconRow(
                  icon: Icons.card_membership_rounded,
                  iconAccentColor: scheme.primary,
                  leadingEdgeAccent: true,
                  child: _ReadOnlyLine(label: 'Membership', value: membershipLabel),
                ),
              ],
            ),
          ),
        ),
        DupraSection(
          title: 'Privacy',
          cardChild: Column(
            children: [
              if (editing) ...[
                _PrivacyEditRow(
                  title: 'Show email in directory',
                  subtitle: 'Let other members see your email',
                  onChanged: onCanShowEmail,
                  value: canShowEmail,
                ),
                Divider(height: 1, color: scheme.onSurface.withValues(alpha: 0.1)),
                _PrivacyEditRow(
                  title: 'Show phone in directory',
                  subtitle: 'When enabled, your contact number is visible to other members',
                  onChanged: onCanShowPhone,
                  value: canShowPhone,
                ),
                Divider(height: 1, color: scheme.onSurface.withValues(alpha: 0.1)),
                _PrivacyEditRow(
                  title: 'Show date of birth in directory',
                  subtitle: 'When enabled, your birthday is visible to other members',
                  onChanged: onCanShowDob,
                  value: canShowDob,
                ),
              ] else ...[
                _PrivacyReadRow(label: 'Display email', enabled: savedShowEmail),
                Divider(height: 1, color: scheme.onSurface.withValues(alpha: 0.1)),
                _PrivacyReadRow(label: 'Display phone', enabled: savedShowPhone),
                Divider(height: 1, color: scheme.onSurface.withValues(alpha: 0.1)),
                _PrivacyReadRow(label: 'Display date of birth', enabled: savedShowDob),
              ],
            ],
          ),
        ),
        DupraSection(
          title: 'Security',
          cardChild: Column(
            children: [
              DupraIconRow(
                onTap: onPasswordSheet,
                contentPadding: const EdgeInsets.only(left: 15, right: 5, top: 12, bottom: 12),
                icon: Icons.lock_outline_rounded,
                iconAccentColor: DupraColors.warning,
                leadingEdgeAccent: true,
                trailing: IconButton(
                  onPressed: onPasswordSheet,
                  icon: Icon(Icons.chevron_right_rounded, color: scheme.onSurfaceVariant),
                ),
                child: Text('Password', style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
              ),
            ],
          ),
        ),
        SizedBox(height: 28 + bottomInset),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: OutlinedButton.icon(
            onPressed: onLogout,
            icon: const Icon(Icons.logout_rounded),
            label: const Text('Log out'),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 15),
              surfaceTintColor: DupraColors.secondary,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            ),
          ),
        ),
        SizedBox(height: 16 + bottomInset),
      ],
    );
  }
}

/// Loading / retry block shown before the profile row is available.
class _ProfileLoadingBody extends StatelessWidget {
  const _ProfileLoadingBody({required this.onRetry});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.only(top: 32, bottom: 48),
      child: Column(
        children: [
          SizedBox(width: 36, height: 36, child: CircularProgressIndicator(strokeWidth: 2.5, color: scheme.primary)),
          const SizedBox(height: 16),
          Text(
            'Loading your profile…',
            textAlign: TextAlign.center,
            style: textTheme.bodyLarge?.copyWith(color: scheme.onSurfaceVariant),
          ),
          const SizedBox(height: 12),
          TextButton(onPressed: onRetry, child: const Text('Retry')),
        ],
      ),
    );
  }
}
