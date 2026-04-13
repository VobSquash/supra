import 'package:app_bloc/app_bloc.dart';
import 'package:client_models/client_models.dart';
import 'package:flutter/material.dart';
import 'package:middleware/middleware.dart';

import '../../engine/launch_service.dart';

const _launch = LaunchService();

bool _isSocialMembership(BasicProfileDTO profile) {
  final t = profile.extendedProfile?.membershipType;
  if (t == null) return false;
  return t == MembershipTypeEnum.social ||
      t == MembershipTypeEnum.socialStudent ||
      t == MembershipTypeEnum.socialScholar;
}

/// Member-facing profile: basic fields, membership, ladder placement, and gated contact with launchers.
class ProfileDetailsPage extends StatefulWidget {
  const ProfileDetailsPage({super.key, required this.profile});

  final BasicProfileDTO profile;

  @override
  State<ProfileDetailsPage> createState() => _ProfileDetailsPageState();
}

class _ProfileDetailsPageState extends State<ProfileDetailsPage> {
  /// Null when membership is social (social / socialStudent / socialScholar): no ladder load or UI.
  Future<List<MemberLadderMembershipWithProfileDTO>>? _ladderFuture;

  @override
  void initState() {
    super.initState();
    if (_isSocialMembership(widget.profile)) {
      _ladderFuture = null;
      return;
    }
    final guid = widget.profile.vobGuid?.trim();
    _ladderFuture = guid != null && guid.isNotEmpty
        ? appBlocSl<IUsersFacade>().loadMemberLadderMembership(guid)
        : Future<List<MemberLadderMembershipWithProfileDTO>>.value(const []);
  }

  @override
  Widget build(BuildContext context) {
    final profile = widget.profile;
    final ext = profile.extendedProfile;
    final title = profile.displayName.trim().isEmpty ? 'Profile' : profile.displayName.trim();

    final showEmail = (ext?.canShowEmail ?? false) && (profile.email?.trim().isNotEmpty ?? false);
    final showPhone =
        (ext?.canShowContactNumber ?? false) && (profile.contactNumber?.trim().isNotEmpty ?? false);
    final showDob =
        (ext?.canShowDateOfBirth ?? false) && (profile.dateOfBirth?.trim().isNotEmpty ?? false);

    final emergency = profile.emergencyContactNumber?.trim();
    final hasEmergency = emergency != null && emergency.isNotEmpty;

    final membershipLabel = ext?.membershipType?.friendlyName;

    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
        children: [
          const _SectionTitle(text: 'Basic information'),
          const SizedBox(height: 8),
          _StaticField(label: 'First name', value: _orDash(profile.firstName)),
          _StaticField(label: 'Last name', value: _orDash(profile.lastName)),
          if (showEmail) ...[
            const SizedBox(height: 4),
            _TappableField(
              icon: Icons.email_outlined,
              label: 'Email',
              value: profile.email!.trim(),
              onTap: () => _launch.launchEmail(profile.email!.trim()),
            ),
          ],
          if (showDob) _StaticField(label: 'Date of birth', value: profile.dateOfBirth!.trim()),
          if (showPhone) ...[
            const SizedBox(height: 4),
            _TappableField(
              icon: Icons.phone_outlined,
              label: 'Contact number',
              value: profile.contactNumber!.trim(),
              onTap: () => _launch.launchDialer(profile.contactNumber!.trim()),
            ),
          ],
          const SizedBox(height: 12),
          _TappableField(
            icon: Icons.emergency_outlined,
            iconColor: Theme.of(context).colorScheme.error,
            label: 'Emergency contact',
            value: hasEmergency ? emergency : 'Not provided',
            onTap: hasEmergency ? () => _launch.launchDialer(emergency) : null,
          ),
          const SizedBox(height: 24),
          const _SectionTitle(text: 'Membership'),
          const SizedBox(height: 8),
          _StaticField(
            label: 'Type',
            value: membershipLabel ?? (ext == null ? '—' : 'Unknown'),
          ),
          if (_ladderFuture != null) ...[
            const SizedBox(height: 24),
            const _SectionTitle(text: 'League ladder'),
            const SizedBox(height: 8),
            FutureBuilder<List<MemberLadderMembershipWithProfileDTO>>(
            future: _ladderFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Padding(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  child: Center(child: CircularProgressIndicator.adaptive()),
                );
              }
              if (snapshot.hasError) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Text(
                    'Could not load ladder information.',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context).colorScheme.error,
                        ),
                  ),
                );
              }
              final rows = snapshot.data ?? const [];
              if (rows.isEmpty) {
                return Text(
                  widget.profile.vobGuid == null || widget.profile.vobGuid!.trim().isEmpty
                      ? 'Ladder information unavailable (missing member id).'
                      : 'Not listed on a ladder.',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.75),
                      ),
                );
              }
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  for (var i = 0; i < rows.length; i++) ...[
                    if (i > 0) const SizedBox(height: 12),
                    _LadderMembershipCard(row: rows[i]),
                  ],
                ],
              );
            },
          ),
          ],
        ],
      ),
    );
  }
}

/// English ordinal for positive integers (e.g. 1 → "1st", 22 → "22nd").
String _ordinalEnglish(int n) {
  if (n <= 0) return '$n';
  final mod100 = n % 100;
  if (mod100 >= 11 && mod100 <= 13) return '${n}th';
  switch (n % 10) {
    case 1:
      return '${n}st';
    case 2:
      return '${n}nd';
    case 3:
      return '${n}rd';
    default:
      return '${n}th';
  }
}

String _leagueTeamLabel(int? teamNumber) {
  if (teamNumber == null || teamNumber <= 0) return 'Unassigned league';
  return '${_ordinalEnglish(teamNumber)} League';
}

class _LadderMembershipCard extends StatelessWidget {
  const _LadderMembershipCard({required this.row});

  final MemberLadderMembershipWithProfileDTO row;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final ladderName = row.ladderType?.friendlyName ?? 'Ladder';
    final teamLine = _leagueTeamLabel(row.leagueTeamNumber);
    final overall = row.ladderRank;
    final within = row.rankWithinTeam;

    return Material(
      color: scheme.surfaceContainerHighest.withValues(alpha: 0.4),
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.view_list_outlined, size: 20, color: scheme.primary),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    ladderName,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            _StaticField(label: 'League team', value: teamLine),
            _StaticField(
              label: 'Overall ladder rank',
              value: overall != null ? '#$overall' : '—',
            ),
            _StaticField(
              label: 'Rank within team',
              value: within != null ? '#$within' : '—',
            ),
          ],
        ),
      ),
    );
  }
}

String _orDash(String? v) {
  final t = v?.trim() ?? '';
  return t.isEmpty ? '—' : t;
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
    );
  }
}

class _StaticField extends StatelessWidget {
  const _StaticField({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final muted = scheme.onSurface.withValues(alpha: 0.72);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 148,
            child: Text(
              label,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: muted,
                  ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ),
        ],
      ),
    );
  }
}

class _TappableField extends StatelessWidget {
  const _TappableField({
    required this.icon,
    required this.label,
    required this.value,
    this.iconColor,
    this.onTap,
  });

  final IconData icon;
  final String label;
  final String value;
  final Color? iconColor;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final muted = scheme.onSurface.withValues(alpha: 0.65);
    final effectiveIcon = iconColor ?? scheme.onSurface.withValues(alpha: 0.75);

    if (onTap == null) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, size: 22, color: effectiveIcon),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 2),
                  Text(value, style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: muted)),
                ],
              ),
            ),
          ],
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Material(
        color: scheme.primary.withValues(alpha: 0.07),
        borderRadius: BorderRadius.circular(10),
        child: InkWell(
          borderRadius: BorderRadius.circular(10),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(icon, size: 22, color: effectiveIcon),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        label,
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        value,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: scheme.primary,
                              decoration: TextDecoration.underline,
                              decorationColor: scheme.primary,
                            ),
                      ),
                    ],
                  ),
                ),
                Icon(Icons.chevron_right, size: 22, color: scheme.primary.withValues(alpha: 0.65)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
