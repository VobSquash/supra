import 'package:app_bloc/app_bloc.dart';
import 'package:client_models/client_models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../engine/launch_service.dart';
import '../../engine/route.dart';
import 'add_member_profile_page.dart';

const _launch = LaunchService();

enum _MembershipFilter { all, league, social, masters }

class UsersTestPage extends StatefulWidget {
  const UsersTestPage({super.key});

  @override
  State<UsersTestPage> createState() => _UsersTestPageState();
}

class _UsersTestPageState extends State<UsersTestPage> {
  final _searchController = TextEditingController();
  final _scrollController = ScrollController();
  _MembershipFilter _segment = _MembershipFilter.all;

  @override
  void initState() {
    super.initState();
    context.read<UsersBloc>().add(const UsersEvent.onLoadActiveProfiles());
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollListToTop() {
    if (_scrollController.hasClients) {
      _scrollController.jumpTo(0);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Active profiles')),
      floatingActionButton: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, authState) {
          final canAdd = authState.maybeWhen(
            authenticated: (s) => ProfileTypeEnum.get(s.profileTypeId ?? -1).isAdminOrElevated,
            orElse: () => false,
          );
          if (!canAdd) {
            return const SizedBox.shrink();
          }
          return FloatingActionButton.extended(
            icon: const Icon(Icons.person_add_outlined),
            label: const Text('Add member'),
            onPressed: () async {
              final usersBloc = context.read<UsersBloc>();
              final added = await Navigator.of(context).push<bool>(
                MaterialPageRoute<bool>(
                  builder: (ctx) => BlocProvider<UsersBloc>.value(
                    value: usersBloc,
                    child: const AddMemberProfilePage(),
                  ),
                ),
              );
              if (!context.mounted) return;
              if (added == true) {
                usersBloc.add(const UsersEvent.onLoadActiveProfiles());
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(const SnackBar(content: Text('Profile created.')));
              }
            },
          );
        },
      ),
      body: BlocBuilder<UsersBloc, UsersState>(
        builder: (context, state) {
          final status = state.status.status;
          final message = state.status.message?.trim();

          // Full-screen error only when we have nothing to show (first load failed).
          if (status == BaseLoadingStatus.loadingFailed && state.profiles.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  message?.isNotEmpty == true
                      ? message!
                      : 'Failed to load profiles',
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }

          // Prefer data over status: once profiles are present, show the list even if the
          // loading flag is momentarily out of sync. Only treat "no rows" as final after
          // [loadingSuccess]; otherwise keep showing the spinner (covers [initial] + [loading]).
          if (state.profiles.isEmpty && status == BaseLoadingStatus.loadingSuccess) {
            return const Center(child: Text('No active profiles found.'));
          }

          if (state.profiles.isEmpty) {
            return const Center(child: CircularProgressIndicator.adaptive());
          }

          final query = _searchController.text.trim().toLowerCase();
          final filtered = state.profiles.where((p) {
            if (!_matchesMembershipFilter(p, _segment)) return false;
            if (query.isEmpty) return true;
            final name = p.displayName.toLowerCase();
            final first = (p.firstName ?? '').toLowerCase();
            final last = (p.lastName ?? '').toLowerCase();
            final email = (p.email ?? '').toLowerCase();
            final phone = (p.contactNumber ?? '').toLowerCase();
            final emergency = (p.emergencyContactNumber ?? '').toLowerCase();
            return name.contains(query) ||
                first.contains(query) ||
                last.contains(query) ||
                email.contains(query) ||
                phone.contains(query) ||
                emergency.contains(query);
          }).toList(growable: false);

          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (status == BaseLoadingStatus.loadingFailed && state.profiles.isNotEmpty)
                Material(
                  color: Theme.of(context).colorScheme.errorContainer,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(12, 10, 8, 10),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(Icons.warning_amber_rounded, color: Theme.of(context).colorScheme.error),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            message?.isNotEmpty == true
                                ? message!
                                : 'Could not refresh the list. Showing the last loaded profiles.',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            context.read<UsersBloc>().add(const UsersEvent.onLoadActiveProfiles());
                          },
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  ),
                ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                child: TextField(
                  controller: _searchController,
                  textInputAction: TextInputAction.search,
                  decoration: InputDecoration(
                    hintText: 'Search name, email, phone…',
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: query.isNotEmpty
                        ? IconButton(
                            tooltip: 'Clear',
                            icon: const Icon(Icons.clear),
                            onPressed: () {
                              _searchController.clear();
                              setState(_scrollListToTop);
                            },
                          )
                        : null,
                    border: const OutlineInputBorder(),
                    isDense: true,
                  ),
                  onChanged: (_) {
                    setState(_scrollListToTop);
                  },
                ),
              ),
              const SizedBox(height: 10),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Row(
                  children: [
                    for (final f in _MembershipFilter.values)
                      Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: ChoiceChip(
                          label: Text(_membershipFilterLabel(f)),
                          selected: _segment == f,
                          onSelected: (selected) {
                            if (!selected) return;
                            setState(() {
                              _segment = f;
                              _scrollListToTop();
                            });
                          },
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              Expanded(
                child: filtered.isEmpty
                    ? Center(
                        child: Padding(
                          padding: const EdgeInsets.all(24),
                          child: Text(
                            'No profiles match your search or filters.',
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onSurface
                                      .withValues(alpha: 0.7),
                                ),
                          ),
                        ),
                      )
                    : ListView.separated(
                        controller: _scrollController,
                        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                        itemCount: filtered.length,
                        separatorBuilder: (context, index) => const Divider(height: 20),
                        itemBuilder: (context, index) {
                          final p = filtered[index];
                          return _ActiveProfileTile(profile: p);
                        },
                      ),
              ),
            ],
          );
        },
      ),
    );
  }
}

String _membershipFilterLabel(_MembershipFilter f) {
  switch (f) {
    case _MembershipFilter.all:
      return 'All';
    case _MembershipFilter.league:
      return 'League';
    case _MembershipFilter.social:
      return 'Social';
    case _MembershipFilter.masters:
      return 'Masters';
  }
}

bool _matchesMembershipFilter(BasicProfileDTO p, _MembershipFilter f) {
  if (f == _MembershipFilter.all) return true;
  final t = p.extendedProfile?.membershipType;
  if (t == null || t == MembershipTypeEnum.unknown) {
    return false;
  }
  switch (f) {
    case _MembershipFilter.all:
      return true;
    case _MembershipFilter.league:
      return t == MembershipTypeEnum.leagueMen ||
          t == MembershipTypeEnum.ladiesLeague ||
          t == MembershipTypeEnum.leagueStudent ||
          t == MembershipTypeEnum.leagueScholar ||
          t == MembershipTypeEnum.leagueAndMasters;
    case _MembershipFilter.social:
      return t == MembershipTypeEnum.social ||
          t == MembershipTypeEnum.socialStudent ||
          t == MembershipTypeEnum.socialScholar;
    case _MembershipFilter.masters:
      return t == MembershipTypeEnum.mastersOnly || t == MembershipTypeEnum.leagueAndMasters;
  }
}

/// User-facing membership line(s): League / Social / Masters; combined type shows both.
List<String> _membershipDisplayLabels(BasicProfileDTO p) {
  final t = p.extendedProfile?.membershipType;
  if (t == null || t == MembershipTypeEnum.unknown) {
    return const ['Unknown'];
  }
  switch (t) {
    case MembershipTypeEnum.leagueMen:
    case MembershipTypeEnum.ladiesLeague:
    case MembershipTypeEnum.leagueStudent:
    case MembershipTypeEnum.leagueScholar:
      return const ['League'];
    case MembershipTypeEnum.social:
    case MembershipTypeEnum.socialStudent:
    case MembershipTypeEnum.socialScholar:
      return const ['Social'];
    case MembershipTypeEnum.mastersOnly:
      return const ['Masters'];
    case MembershipTypeEnum.leagueAndMasters:
      return const ['League', 'Masters'];
    case MembershipTypeEnum.unknown:
      return const ['Unknown'];
  }
}

class _ActiveProfileTile extends StatelessWidget {
  const _ActiveProfileTile({required this.profile});

  final BasicProfileDTO profile;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final ext = profile.extendedProfile;

    final showEmail =
        (ext?.canShowEmail ?? false) && (profile.email?.trim().isNotEmpty ?? false);
    final showPhone = (ext?.canShowContactNumber ?? false) &&
        (profile.contactNumber?.trim().isNotEmpty ?? false);

    final name =
        profile.displayName.trim().isEmpty ? '(no name)' : profile.displayName.trim();
    final emergency = profile.emergencyContactNumber?.trim();
    final emergencyLine =
        emergency != null && emergency.isNotEmpty ? emergency : 'Not provided';

    final labels = _membershipDisplayLabels(profile);

    final emergencyDigits = emergency != null && emergency.isNotEmpty;

    return Material(
      color: scheme.surfaceContainerHighest.withValues(alpha: 0.35),
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            InkWell(
              borderRadius: BorderRadius.circular(8),
              onTap: () {
                Navigator.of(context).pushNamed(
                  RouteNames.profileDetails,
                  arguments: profile,
                );
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 2),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            name,
                            style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
                          ),
                        ),
                        if (profile.isActive == true)
                          Text(
                            'Active',
                            style: textTheme.labelMedium?.copyWith(
                              color: scheme.primary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 6,
                      runSpacing: 6,
                      children: [
                        for (final label in labels)
                          Chip(
                            visualDensity: VisualDensity.compact,
                            padding: EdgeInsets.zero,
                            labelPadding: const EdgeInsets.symmetric(horizontal: 8),
                            label: Text(
                              label,
                              style: textTheme.labelMedium?.copyWith(fontWeight: FontWeight.w600),
                            ),
                            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 10),
            if (showEmail)
              _ContactLine(
                icon: Icons.mail_outline,
                text: profile.email!.trim(),
                onTap: () => _launch.launchEmail(profile.email!.trim()),
              ),
            if (showPhone) ...[
              if (showEmail) const SizedBox(height: 6),
              _ContactLine(
                icon: Icons.phone_outlined,
                text: profile.contactNumber!.trim(),
                onTap: () => _launch.launchDialer(profile.contactNumber!.trim()),
              ),
            ],
            const SizedBox(height: 8),
            _ContactLine(
              icon: Icons.emergency_outlined,
              iconColor: scheme.error,
              text: 'Emergency: $emergencyLine',
              emphasize: true,
              onTap: emergencyDigits ? () => _launch.launchDialer(emergency) : null,
            ),
          ],
        ),
      ),
    );
  }
}

class _ContactLine extends StatelessWidget {
  const _ContactLine({
    required this.icon,
    required this.text,
    this.iconColor,
    this.emphasize = false,
    this.onTap,
  });

  final IconData icon;
  final String text;
  final Color? iconColor;
  final bool emphasize;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final muted = scheme.onSurface.withValues(alpha: 0.65);
    final effectiveIconColor = iconColor ?? muted;
    final textStyle = Theme.of(context).textTheme.bodyMedium?.copyWith(
          color: onTap != null ? scheme.primary : scheme.onSurface,
          fontWeight: emphasize ? FontWeight.w600 : null,
          decoration: onTap != null ? TextDecoration.underline : null,
          decorationColor: scheme.primary,
        );

    final row = Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 18, color: effectiveIconColor),
        const SizedBox(width: 8),
        Expanded(
          child: Text(text, style: textStyle),
        ),
        if (onTap != null)
          Icon(Icons.open_in_new, size: 16, color: scheme.primary.withValues(alpha: 0.7)),
      ],
    );

    if (onTap == null) {
      return row;
    }

    return Material(
      color: scheme.primary.withValues(alpha: 0.06),
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
          child: row,
        ),
      ),
    );
  }
}
