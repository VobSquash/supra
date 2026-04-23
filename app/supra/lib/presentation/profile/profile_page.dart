import 'package:app_bloc/app_bloc.dart';
import 'package:client_models/client_models.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:middleware/middleware.dart';

import '../../engine/theme/supra_colors.dart';
import 'profile_editor_page.dart';

/// Browse-first profile: hero header + summary; editing is a separate full screen; password in a sheet.
class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  BasicProfileDTO? _profile;
  bool _loading = true;
  String? _loadError;

  IUsersFacade get _users => appBlocSl<IUsersFacade>();
  AuthService get _auth => appBlocSl<AuthService>();

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _loadError = null;
    });
    try {
      final p = await _users.loadCurrentUserProfile();
      if (!mounted) return;
      setState(() {
        _profile = p;
        _loading = false;
      });
    } catch (e, st) {
      debugPrint('ProfilePage load: $e\n$st');
      if (!mounted) return;
      setState(() {
        _loadError = _userMessage(e);
        _loading = false;
      });
    }
  }

  String _userMessage(Object e) {
    if (e is DioException) {
      final fromErr = e.error?.toString().trim();
      if (fromErr != null && fromErr.isNotEmpty) return fromErr;
      final data = e.response?.data;
      if (data != null && data.toString().trim().isNotEmpty) {
        return data.toString();
      }
      final m = e.message?.trim();
      if (m != null && m.isNotEmpty) return m;
    }
    final s = e.toString().trim();
    if (s.isNotEmpty && s != 'Exception') return s;
    return 'Something went wrong.';
  }

  Future<void> _openEditor() async {
    final p = _profile;
    if (p == null) return;
    final saved = await Navigator.of(context).push<bool>(
      MaterialPageRoute(
        builder: (context) => ProfileEditorPage(profile: p),
      ),
    );
    if (!mounted) return;
    if (saved == true) await _load();
  }

  Future<void> _openPasswordSheet() {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      showDragHandle: true,
      builder: (ctx) {
        return Padding(
          padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(ctx).bottom),
          child: _PasswordSheet(auth: _auth),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    if (_loading) {
      return Scaffold(
        body: Center(
          child: CircularProgressIndicator(color: SupraColors.secondary),
        ),
      );
    }

    if (_loadError != null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Profile')),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.error_outline, size: 48, color: scheme.error),
                const SizedBox(height: 16),
                Text(_loadError!, textAlign: TextAlign.center),
                const SizedBox(height: 20),
                FilledButton(onPressed: _load, child: const Text('Try again')),
              ],
            ),
          ),
        ),
      );
    }

    if (_profile == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Profile')),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Text(
              'No member profile is linked to this account yet.',
              style: textTheme.bodyLarge?.copyWith(color: SupraColors.textSecondary),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      );
    }

    final p = _profile!;
    final display = p.displayName.trim().isEmpty ? 'Member' : p.displayName.trim();
    final email = (p.email?.trim().isEmpty ?? true) ? null : p.email!.trim();
    final membership = p.extendedProfile?.membershipType?.friendlyName;
    final initial = _initial(display);

    return Scaffold(
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverToBoxAdapter(
            child: _ProfileHeroHeader(
              displayName: display,
              email: email,
              membershipLabel: membership,
              nameInitial: initial,
              onEditPressed: _openEditor,
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 4, 20, 36),
            sliver: SliverList.list(
              children: [
                Text(
                  'At a glance',
                  style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 6),
                Text(
                  'Email is managed by the club.\nEdit your name, phone numbers, birthday, privacy & SSA.',
                  style: textTheme.bodySmall?.copyWith(color: scheme.onSurfaceVariant, height: 1.35),
                ),
                const SizedBox(height: 18),
                _SummaryGrid(profile: p),
                const SizedBox(height: 12),
                _PrivacySnapshotCard(profile: p),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    style: FilledButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    onPressed: _openEditor,
                    child: const Text('Edit profile'),
                  ),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    onPressed: _openPasswordSheet,
                    icon: const Icon(Icons.lock_outline_rounded, size: 20),
                    label: const Text('Change password'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _initial(String name) {
    final t = name.trim();
    if (t.isEmpty) return '?';
    return t.substring(0, 1).toUpperCase();
  }
}

// --- Hero + summary (visual layer only) ---

class _ProfileHeroHeader extends StatelessWidget {
  const _ProfileHeroHeader({
    required this.displayName,
    required this.email,
    required this.membershipLabel,
    required this.nameInitial,
    required this.onEditPressed,
  });

  final String displayName;
  final String? email;
  final String? membershipLabel;
  final String nameInitial;
  final VoidCallback onEditPressed;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final topInset = MediaQuery.paddingOf(context).top;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SizedBox(
          height: 200 + topInset,
          child: Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.bottomCenter,
            children: [
              Positioned.fill(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: RadialGradient(
                      center: const Alignment(-0.35, -0.8),
                      radius: 1.45,
                      colors: [
                        SupraColors.secondary.withValues(alpha: 0.42),
                        SupraColors.tertiary.withValues(alpha: 0.78),
                        SupraColors.scaffoldSecondary,
                      ],
                      stops: const [0.0, 0.42, 1.0],
                    ),
                  ),
                ),
              ),
              Positioned(
                top: topInset + 8,
                left: 8,
                child: IconButton.filledTonal(
                  onPressed: () => Navigator.maybePop(context),
                  icon: const Icon(Icons.arrow_back_rounded),
                ),
              ),
              Positioned(
                bottom: -44,
                child: Stack(
                  clipBehavior: Clip.none,
                  alignment: Alignment.bottomRight,
                  children: [
                    Container(
                      width: 112,
                      height: 112,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: scheme.surface,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.35),
                            blurRadius: 20,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        nameInitial,
                        style: textTheme.displaySmall?.copyWith(fontWeight: FontWeight.w700),
                      ),
                    ),
                    Positioned(
                      right: 2,
                      bottom: 2,
                      child: Tooltip(
                        message: 'Edit profile',
                        child: Material(
                          elevation: 2,
                          color: SupraColors.secondary,
                          shape: const CircleBorder(),
                          child: InkWell(
                            customBorder: const CircleBorder(),
                            onTap: onEditPressed,
                            child: const Padding(
                              padding: EdgeInsets.all(10),
                              child: Icon(Icons.edit_rounded, size: 20, color: Color(0xFF0a0a0a)),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 56),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                displayName,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w700, height: 1.2),
              ),
              if (email != null) ...[
                const SizedBox(height: 6),
                Wrap(
                  alignment: WrapAlignment.center,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  spacing: 8,
                  children: [
                    SelectableText(
                      email!,
                      textAlign: TextAlign.center,
                      style: textTheme.bodyMedium?.copyWith(color: scheme.onSurfaceVariant),
                    ),
                    Chip(
                      labelPadding: const EdgeInsets.symmetric(horizontal: 6),
                      padding: EdgeInsets.zero,
                      visualDensity: VisualDensity.compact,
                      side: BorderSide(color: scheme.outline.withValues(alpha: 0.25)),
                      label: Text(
                        'Managed',
                        style: textTheme.labelSmall?.copyWith(color: scheme.onSurfaceVariant),
                      ),
                    ),
                  ],
                ),
              ],
              if (membershipLabel != null && membershipLabel!.isNotEmpty) ...[
                const SizedBox(height: 14),
                Chip(
                  visualDensity: VisualDensity.compact,
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                  side: BorderSide(color: SupraColors.secondary.withValues(alpha: 0.45)),
                  label: Text(
                    membershipLabel!,
                    style: textTheme.labelLarge?.copyWith(
                      color: SupraColors.secondary,
                      letterSpacing: 0.3,
                    ),
                  ),
                ),
              ],
              const SizedBox(height: 12),
              Text(
                'Profile photo coming soon',
                style: textTheme.labelSmall?.copyWith(
                  color: scheme.onSurfaceVariant.withValues(alpha: 0.85),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _SummaryGrid extends StatelessWidget {
  const _SummaryGrid({required this.profile});

  final BasicProfileDTO profile;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    final dob = _coerceToDate(profile.dateOfBirth);
    final dobLabel = dob == null ? null : MaterialLocalizations.of(context).formatMediumDate(dob);

    final ssaRaw = _readSsa(profile);

    final tiles = <_TileData>[
      _TileData('Phone', profile.contactNumber, icon: Icons.phone_outlined),
      _TileData('Emergency', profile.emergencyContactNumber, icon: Icons.local_hospital_outlined),
      _TileData('Birthday', dobLabel ?? profile.dateOfBirth, icon: Icons.cake_outlined),
      _TileData('SSA', ssaRaw, icon: Icons.badge_outlined),
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        final w = constraints.maxWidth;
        final cross = w >= 480 ? 4 : 2;
        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: cross,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: cross == 4 ? 1.65 : 1.38,
          ),
          itemCount: tiles.length,
          itemBuilder: (context, i) {
            final t = tiles[i];

            final raw = (t.value ?? '').toString().trim();
            final value = raw.isEmpty ? '—' : raw;

            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: scheme.outline.withValues(alpha: 0.22)),
                color: scheme.surfaceContainerHighest.withValues(alpha: 0.4),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      Icon(t.icon, size: 16, color: scheme.onSurfaceVariant),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          t.label,
                          style: textTheme.labelSmall?.copyWith(
                            color: scheme.onSurfaceVariant,
                            letterSpacing: 0.4,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    value,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  static DateTime? _coerceToDate(Object? v) {
    if (v == null) return null;
    if (v is DateTime) return DateTime(v.year, v.month, v.day);
    final s = v.toString().trim();
    if (s.isEmpty) return null;

    final parts = s.split('-');
    if (parts.length == 3) {
      final y = int.tryParse(parts[0]);
      final m = int.tryParse(parts[1]);
      final d = int.tryParse(parts[2]);
      if (y != null && m != null && d != null) return DateTime(y, m, d);
    }
    try {
      final dt = DateTime.parse(s);
      return DateTime(dt.year, dt.month, dt.day);
    } catch (_) {
      return null;
    }
  }

  static String? _readSsa(BasicProfileDTO p) {
    final v = p.extendedProfile?.SSANumber;
    if (v != null && v.trim().isNotEmpty) return v.trim();
    return null;
  }
}

class _TileData {
  const _TileData(this.label, this.value, {required this.icon});

  final String label;
  final Object? value;
  final IconData icon;
}

class _PrivacySnapshotCard extends StatelessWidget {
  const _PrivacySnapshotCard({required this.profile});

  final BasicProfileDTO profile;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    final ext = profile.extendedProfile;
    final showEmail = ext?.canShowEmail ?? true;
    final showPhone = ext?.canShowContactNumber ?? true;
    final showDob = ext?.canShowDateOfBirth ?? false;

    Widget row(String label, bool value) {
      return Row(
        children: [
          Icon(
            value ? Icons.visibility_outlined : Icons.visibility_off_outlined,
            size: 18,
            color: value ? SupraColors.secondary : scheme.onSurfaceVariant,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(label, style: textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600)),
          ),
          Text(
            value ? 'Visible' : 'Hidden',
            style: textTheme.bodySmall?.copyWith(color: scheme.onSurfaceVariant),
          ),
        ],
      );
    }

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: scheme.outline.withValues(alpha: 0.22)),
        color: scheme.surfaceContainerHighest.withValues(alpha: 0.22),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Directory visibility',
            style: textTheme.labelLarge?.copyWith(
              color: scheme.onSurfaceVariant,
              letterSpacing: 0.3,
            ),
          ),
          const SizedBox(height: 12),
          row('Email', showEmail),
          const SizedBox(height: 10),
          row('Contact number', showPhone),
          const SizedBox(height: 10),
          row('Date of birth', showDob),
          const SizedBox(height: 8),
          Text(
            'Controls what other members can see.',
            style: textTheme.labelSmall?.copyWith(color: scheme.onSurfaceVariant),
          ),
        ],
      ),
    );
  }
}

class _PasswordSheet extends StatefulWidget {
  const _PasswordSheet({required this.auth});

  final AuthService auth;

  @override
  State<_PasswordSheet> createState() => _PasswordSheetState();
}

class _PasswordSheetState extends State<_PasswordSheet> {
  final _new = TextEditingController();
  final _confirm = TextEditingController();
  bool _busy = false;

  @override
  void dispose() {
    _new.dispose();
    _confirm.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final a = _new.text;
    final b = _confirm.text;
    if (a.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Use at least 6 characters.')),
      );
      return;
    }
    if (a != b) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Passwords do not match.')),
      );
      return;
    }
    setState(() => _busy = true);
    final nav = Navigator.of(context);
    final messenger = ScaffoldMessenger.of(context);
    try {
      final result = await widget.auth.updatePassword(newPassword: a);
      if (!mounted) return;
      if (result.success) {
        nav.pop();
        messenger.showSnackBar(
          SnackBar(
            content: const Text('Password updated.'),
            backgroundColor: SupraColors.success.withValues(alpha: 0.9),
          ),
        );
      } else {
        messenger.showSnackBar(
          SnackBar(
            content: Text(result.errorMessage ?? 'Could not update password.'),
            backgroundColor: Theme.of(context).colorScheme.errorContainer,
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;
      messenger.showSnackBar(
        SnackBar(
          content: Text(e.toString()),
          backgroundColor: Theme.of(context).colorScheme.errorContainer,
        ),
      );
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('Change password', style: textTheme.titleLarge),
            const SizedBox(height: 8),
            Text(
              'Choose a new password for your account.',
              style: textTheme.bodyMedium?.copyWith(color: scheme.onSurfaceVariant),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _new,
              obscureText: true,
              textInputAction: TextInputAction.next,
              autofillHints: const [AutofillHints.newPassword],
              decoration: const InputDecoration(
                labelText: 'New password',
                filled: true,
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _confirm,
              obscureText: true,
              textInputAction: TextInputAction.done,
              onSubmitted: (_) {
                if (!_busy) _submit();
              },
              autofillHints: const [AutofillHints.newPassword],
              decoration: const InputDecoration(
                labelText: 'Confirm password',
                filled: true,
              ),
            ),
            const SizedBox(height: 20),
            FilledButton(
              style: FilledButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              onPressed: _busy ? null : _submit,
              child: _busy
                  ? SizedBox(
                      height: 22,
                      width: 22,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: scheme.onPrimary,
                      ),
                    )
                  : const Text('Update password'),
            ),
          ],
        ),
      ),
    );
  }
}
