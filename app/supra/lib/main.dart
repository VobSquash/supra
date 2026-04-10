import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:app_bloc/app_bloc.dart';
import 'package:client_models/client_models.dart';

import 'bootstrap.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await bootstrap();
  runApp(const SupraTestApp());
}

class SupraTestApp extends StatelessWidget {
  const SupraTestApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Supra Test Harness',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const SupraHomePage(),
    );
  }
}

class SupraHomePage extends StatelessWidget {
  const SupraHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Supra test pages'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            FilledButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    builder: (_) => BlocProvider(
                      create: (_) => appBlocSl<UsersBloc>(),
                      child: const UsersTestPage(),
                    ),
                  ),
                );
              },
              child: const Text('Users: load active profiles'),
            ),
            const SizedBox(height: 12),
            FilledButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    builder: (_) => BlocProvider(
                      create: (_) => appBlocSl<LocationsBloc>(),
                      child: const LocationsTestPage(),
                    ),
                  ),
                );
              },
              child: const Text('Locations: load list'),
            ),
            const SizedBox(height: 12),
            FilledButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    builder: (_) => BlocProvider(
                      create: (_) => appBlocSl<SettingsBloc>(),
                      child: const SettingsTestPage(),
                    ),
                  ),
                );
              },
              child: const Text('Settings: load aggregate'),
            ),
            const SizedBox(height: 12),
            FilledButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    builder: (_) => BlocProvider(
                      create: (_) => appBlocSl<LaddersBloc>(),
                      child: const LaddersTestPage(),
                    ),
                  ),
                );
              },
              child: const Text('Ladders: load lists'),
            ),
            const SizedBox(height: 12),
            FilledButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    builder: (_) => BlocProvider(
                      create: (_) => appBlocSl<LeagueFixturesBloc>(),
                      child: const LeagueFixturesTestPage(),
                    ),
                  ),
                );
              },
              child: const Text('League fixtures: load list'),
            ),
            const SizedBox(height: 12),
            FilledButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    builder: (_) => BlocProvider(
                      create: (_) => appBlocSl<BookingsBloc>(),
                      child: const BookingsTestPage(),
                    ),
                  ),
                );
              },
              child: const Text('Bookings: by day'),
            ),
          ],
        ),
      ),
    );
  }
}

String _formatYmd(DateTime d) =>
    '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

class BookingsTestPage extends StatefulWidget {
  const BookingsTestPage({super.key});

  @override
  State<BookingsTestPage> createState() => _BookingsTestPageState();
}

class _BookingsTestPageState extends State<BookingsTestPage> {
  @override
  void initState() {
    super.initState();
    final today = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
    context.read<BookingsBloc>().add(BookingsEvent.onLoadBookings(forDate: today));
  }

  void _nudgeDay(int deltaDays) {
    final b = context.read<BookingsBloc>();
    final d = b.state.selectedDate;
    final start = DateTime(d.year, d.month, d.day);
    final next = start.add(Duration(days: deltaDays));
    b.add(BookingsEvent.onLoadBookings(forDate: next));
  }

  Future<void> _pickDate() async {
    final bloc = context.read<BookingsBloc>();
    final picked = await showDatePicker(
      context: context,
      initialDate: bloc.state.selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2035),
    );
    if (picked != null && mounted) {
      context.read<BookingsBloc>().add(BookingsEvent.onLoadBookings(forDate: picked));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bookings'),
        actions: [
          IconButton(
            icon: const Icon(Icons.chevron_left),
            tooltip: 'Previous day',
            onPressed: () => _nudgeDay(-1),
          ),
          IconButton(
            icon: const Icon(Icons.calendar_today_outlined),
            tooltip: 'Pick date',
            onPressed: _pickDate,
          ),
          IconButton(
            icon: const Icon(Icons.chevron_right),
            tooltip: 'Next day',
            onPressed: () => _nudgeDay(1),
          ),
        ],
      ),
      body: BlocBuilder<BookingsBloc, BookingsState>(
        builder: (context, state) {
          final status = state.status.status;
          final message = state.status.message?.trim();

          if (status == BaseLoadingStatus.loading) {
            return const Center(child: CircularProgressIndicator.adaptive());
          }

          if (status == BaseLoadingStatus.loadingFailed) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  message?.isNotEmpty == true ? message! : 'Failed to load bookings',
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  'Date: ${_formatYmd(state.selectedDate)} · ${state.bookings.length} booking(s)',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
              Expanded(
                child: state.bookings.isEmpty
                    ? const Center(child: Text('No bookings for this day.'))
                    : ListView.separated(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: state.bookings.length,
                        separatorBuilder: (context, index) => const Divider(height: 1),
                        itemBuilder: (context, i) {
                          final b = state.bookings[i];
                          final sub = StringBuffer(
                            'Court ${b.courtNo ?? '—'}',
                          );
                          if (b.bookingDate != null) {
                            sub.write(' · ${b.bookingDate}');
                          }
                          if (b.profile?.displayName != null) {
                            sub.write(' · ${b.profile!.displayName}');
                          }
                          return ListTile(
                            title: Text(b.displayName ?? '(no name)'),
                            subtitle: Text(sub.toString()),
                          );
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

class LeagueFixturesTestPage extends StatefulWidget {
  const LeagueFixturesTestPage({super.key});

  @override
  State<LeagueFixturesTestPage> createState() => _LeagueFixturesTestPageState();
}

class _LeagueFixturesTestPageState extends State<LeagueFixturesTestPage> {
  @override
  void initState() {
    super.initState();
    context.read<LeagueFixturesBloc>().add(const LeagueFixturesEvent.onLoadLeagueFixtures());
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LeagueFixturesBloc, LeagueFixturesState>(
      builder: (context, state) {
        final status = state.status.status;
        final message = state.status.message?.trim();

        if (status == BaseLoadingStatus.loading) {
          return Scaffold(
            appBar: AppBar(title: const Text('League fixtures')),
            body: const Center(child: CircularProgressIndicator.adaptive()),
          );
        }

        if (status == BaseLoadingStatus.loadingFailed) {
          return Scaffold(
            appBar: AppBar(title: const Text('League fixtures')),
            body: Center(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  message?.isNotEmpty == true ? message! : 'Failed to load league fixtures',
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          );
        }

        if (state.fixtures.isEmpty) {
          return Scaffold(
            appBar: AppBar(title: const Text('League fixtures')),
            body: const Center(child: Text('No fixtures found.')),
          );
        }

        return DefaultTabController(
          length: LadderTypeEnum.values.length,
          child: Scaffold(
            appBar: AppBar(
              title: const Text('League fixtures'),
              bottom: TabBar(
                tabs: [
                  for (final lt in LadderTypeEnum.values) Tab(text: lt.friendlyName),
                ],
              ),
            ),
            body: TabBarView(
              children: [
                for (final lt in LadderTypeEnum.values)
                  _LeagueFixturesGroupedTab(
                    ladderType: lt,
                    fixtures: state.fixtures.where((f) => f.ladderType == lt).toList(),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}

/// One ladder tab: [ExpansionTile] per [leagueTeam], fixtures sorted by date.
class _LeagueFixturesGroupedTab extends StatelessWidget {
  const _LeagueFixturesGroupedTab({
    required this.ladderType,
    required this.fixtures,
  });

  final LadderTypeEnum ladderType;
  final List<LeagueFixtureDto> fixtures;

  @override
  Widget build(BuildContext context) {
    if (fixtures.isEmpty) {
      return const Center(child: Text('No fixtures for this ladder.'));
    }

    final byTeam = <int, List<LeagueFixtureDto>>{};
    for (final f in fixtures) {
      byTeam.putIfAbsent(f.leagueTeam, () => []).add(f);
    }
    for (final list in byTeam.values) {
      list.sort((a, b) => a.fixtureDate.compareTo(b.fixtureDate));
    }
    final teams = byTeam.keys.toList()..sort();

    return ListView.builder(
      padding: const EdgeInsets.only(bottom: 16),
      itemCount: teams.length,
      itemBuilder: (context, index) {
        final team = teams[index];
        final rows = byTeam[team]!;
        return ExpansionTile(
          key: PageStorageKey<String>('${ladderType.identifierType}-$team'),
          title: Text('Team $team (${rows.length} ${rows.length == 1 ? 'fixture' : 'fixtures'})'),
          initiallyExpanded: false,
          children: [
            for (final f in rows) _LeagueFixtureListTile(f),
          ],
        );
      },
    );
  }
}

class _LeagueFixtureListTile extends StatelessWidget {
  const _LeagueFixtureListTile(this.f);

  final LeagueFixtureDto f;

  @override
  Widget build(BuildContext context) {
    final dateStr =
        '${f.fixtureDate.year}-${f.fixtureDate.month.toString().padLeft(2, '0')}-${f.fixtureDate.day.toString().padLeft(2, '0')}';
    final title = '${f.homeTeam} vs ${f.awayTeam}';
    final captain = f.clubCaptain?.captainName;
    final subtitle = [
      dateStr,
      f.venue,
      f.status,
      if (captain != null && captain.trim().isNotEmpty) 'Captain: $captain',
    ].join(' · ');
    return ListTile(
      dense: true,
      title: Text(title),
      subtitle: Text(subtitle),
      isThreeLine: captain != null && captain.trim().isNotEmpty,
    );
  }
}

class LaddersTestPage extends StatefulWidget {
  const LaddersTestPage({super.key});

  @override
  State<LaddersTestPage> createState() => _LaddersTestPageState();
}

class _LaddersTestPageState extends State<LaddersTestPage> {
  @override
  void initState() {
    super.initState();
    context.read<LaddersBloc>().add(const LaddersEvent.onLoadLadders());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ladders'),
      ),
      body: BlocBuilder<LaddersBloc, LaddersState>(
        builder: (context, state) {
          final status = state.status.status;
          final message = state.status.message?.trim();

          if (status == BaseLoadingStatus.loading) {
            return const Center(child: CircularProgressIndicator.adaptive());
          }

          if (status == BaseLoadingStatus.loadingFailed) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  message?.isNotEmpty == true ? message! : 'Failed to load ladders',
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }

          final l = state.ladders;
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              _RowItem(label: 'showLadderBreakdown', value: l.showLadderBreakdown.toString()),
              const SizedBox(height: 16),
              Text('Men (${l.men?.length ?? 0})', style: Theme.of(context).textTheme.titleMedium),
              ..._ladderItems(l.men),
              const SizedBox(height: 16),
              Text('Ladies (${l.ladies?.length ?? 0})', style: Theme.of(context).textTheme.titleMedium),
              ..._ladderItems(l.ladies),
              const SizedBox(height: 16),
              Text('Masters (${l.masters?.length ?? 0})', style: Theme.of(context).textTheme.titleMedium),
              ..._ladderItems(l.masters),
            ],
          );
        },
      ),
    );
  }

  List<Widget> _ladderItems(List<LadderItemDTO>? items) {
    if (items == null || items.isEmpty) {
      return [const Text('(none)')];
    }
    return items
        .map(
          (e) => ListTile(
            title: Text(e.profile?.displayName ?? '(no profile)'),
            subtitle: Text('order ${e.order} · team ${e.team}'),
          ),
        )
        .toList();
  }
}

class SettingsTestPage extends StatefulWidget {
  const SettingsTestPage({super.key});

  @override
  State<SettingsTestPage> createState() => _SettingsTestPageState();
}

class _SettingsTestPageState extends State<SettingsTestPage> {
  @override
  void initState() {
    super.initState();
    context.read<SettingsBloc>().add(const SettingsEvent.onLoadSettings());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: BlocBuilder<SettingsBloc, SettingsState>(
        builder: (context, state) {
          final status = state.status.status;
          final message = state.status.message?.trim();

          if (status == BaseLoadingStatus.loading) {
            return const Center(child: CircularProgressIndicator.adaptive());
          }

          if (status == BaseLoadingStatus.loadingFailed) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  message?.isNotEmpty == true ? message! : 'Failed to load settings',
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }

          final s = state.settings;
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Text('System', style: Theme.of(context).textTheme.titleMedium),
              _RowItem(label: 'objectId', value: s.systemSettings.objectId),
              _RowItem(label: 'showLadderBreakdown', value: s.systemSettings.showLadderBreakdown.toString()),
              const SizedBox(height: 16),
              Text('Fees (${s.fees.items.length})', style: Theme.of(context).textTheme.titleMedium),
              ...s.fees.items.map(
                (f) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: _RowItem(
                    label: f.feeType,
                    value: '${f.cost} (proRata: ${f.proRataCost})',
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text('Ladder breakdown', style: Theme.of(context).textTheme.titleMedium),
              _RowItem(label: 'objectId', value: s.ladderBreakdown.objectId),
              _RowItem(
                label: 'men teams',
                value: '${s.ladderBreakdown.mensteams?.length ?? 0}',
              ),
              _RowItem(
                label: 'ladies teams',
                value: '${s.ladderBreakdown.ladiesTeams?.length ?? 0}',
              ),
              _RowItem(
                label: 'masters teams',
                value: '${s.ladderBreakdown.mastersTeams?.length ?? 0}',
              ),
            ],
          );
        },
      ),
    );
  }
}

class LocationsTestPage extends StatefulWidget {
  const LocationsTestPage({super.key});

  @override
  State<LocationsTestPage> createState() => _LocationsTestPageState();
}

class _LocationsTestPageState extends State<LocationsTestPage> {
  @override
  void initState() {
    super.initState();
    context.read<LocationsBloc>().add(const LocationsEvent.onLoadLocations());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Locations'),
      ),
      body: BlocBuilder<LocationsBloc, LocationsState>(
        builder: (context, state) {
          final status = state.status.status;
          final message = state.status.message?.trim();

          if (status == BaseLoadingStatus.loading) {
            return const Center(child: CircularProgressIndicator.adaptive());
          }

          if (status == BaseLoadingStatus.loadingFailed) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  message?.isNotEmpty == true ? message! : 'Failed to load locations',
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }

          if (state.locations.isEmpty) {
            return const Center(child: Text('No locations found.'));
          }

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: state.locations.length,
            separatorBuilder: (context, index) => const Divider(height: 24),
            itemBuilder: (context, index) {
              final loc = state.locations[index];
              final title = (loc.name ?? '').trim().isEmpty ? '(no name)' : loc.name!;
              final subtitle = [
                if ((loc.vobGuid ?? '').trim().isNotEmpty) loc.vobGuid!,
                if ((loc.latitude ?? '').trim().isNotEmpty || (loc.longitude ?? '').trim().isNotEmpty)
                  '${loc.latitude ?? '—'}, ${loc.longitude ?? '—'}',
              ].join(' · ');
              return ListTile(
                title: Text(title),
                subtitle: Text(subtitle.isEmpty ? '(no details)' : subtitle),
              );
            },
          );
        },
      ),
    );
  }
}

class UsersTestPage extends StatefulWidget {
  const UsersTestPage({super.key});

  @override
  State<UsersTestPage> createState() => _UsersTestPageState();
}

class _UsersTestPageState extends State<UsersTestPage> {
  @override
  void initState() {
    super.initState();
    context.read<UsersBloc>().add(const UsersEvent.onLoadActiveProfiles());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Active profiles'),
      ),
      body: BlocBuilder<UsersBloc, UsersState>(
        builder: (context, state) {
          final status = state.status.status;
          final message = state.status.message?.trim();

          if (status == BaseLoadingStatus.loading) {
            return const Center(child: CircularProgressIndicator.adaptive());
          }

          if (status == BaseLoadingStatus.loadingFailed) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  message?.isNotEmpty == true ? message! : 'Failed to load profiles',
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }

          if (state.profiles.isEmpty) {
            return const Center(child: Text('No active profiles found.'));
          }

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: state.profiles.length,
            separatorBuilder: (context, index) => const Divider(height: 24),
            itemBuilder: (context, index) {
              final p = state.profiles[index];
              return ListTile(
                title: Text(p.displayName.trim().isEmpty ? '(no name)' : p.displayName),
                subtitle: Text((p.email ?? '').isEmpty ? '(no email)' : p.email!),
                trailing: Text(p.isActive == true ? 'active' : 'inactive'),
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (_) => ProfileDetailsPage(profile: p),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}

class ProfileDetailsPage extends StatelessWidget {
  const ProfileDetailsPage({
    super.key,
    required this.profile,
  });

  final BasicProfileDTO profile;

  @override
  Widget build(BuildContext context) {
    final title = profile.displayName.trim().isEmpty ? 'Profile details' : profile.displayName;
    final extended = profile.extendedProfile;

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _RowItem(label: 'objectId', value: profile.objectId),
          _RowItem(label: 'vobGuid', value: profile.vobGuid),
          _RowItem(label: 'firstName', value: profile.firstName),
          _RowItem(label: 'lastName', value: profile.lastName),
          _RowItem(label: 'email', value: profile.email),
          _RowItem(label: 'contactNumber', value: profile.contactNumber),
          _RowItem(label: 'dateOfBirth', value: profile.dateOfBirth),
          _RowItem(label: 'emergencyContactNumber', value: profile.emergencyContactNumber),
          _RowItem(label: 'isActive', value: profile.isActive?.toString()),
          _RowItem(label: 'profilePictureUrl', value: profile.profilePictureUrl),
          const SizedBox(height: 16),
          Text(
            'Extended profile',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          if (extended == null) ...[
            const Text('(none)'),
          ] else ...[
            _RowItem(label: 'objectId', value: extended.objectId),
            _RowItem(label: 'vobGuid', value: extended.vobGuid),
            _RowItem(label: 'isCoach', value: extended.isCoach?.toString()),
            _RowItem(label: 'canShowEmail', value: extended.canShowEmail?.toString()),
            _RowItem(label: 'canShowContactNumber', value: extended.canShowContactNumber?.toString()),
            _RowItem(label: 'canShowDateOfBirth', value: extended.canShowDateOfBirth?.toString()),
            _RowItem(label: 'SSANumber', value: extended.SSANumber),
            _RowItem(label: 'membershipType', value: extended.membershipType?.toString()),
            _RowItem(label: 'emergencyContactNumber', value: extended.emergencyContactNumber),
          ],
        ],
      ),
    );
  }
}

class _RowItem extends StatelessWidget {
  const _RowItem({
    required this.label,
    required this.value,
  });

  final String label;
  final String? value;

  @override
  Widget build(BuildContext context) {
    final v = (value ?? '').trim();
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 170,
            child: Text(
              label,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
          ),
          Expanded(
            child: Text(v.isEmpty ? '(empty)' : v),
          ),
        ],
      ),
    );
  }
}
