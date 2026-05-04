import 'package:app_bloc/app_bloc.dart';
import 'package:client_models/client_models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../widgets/profile_avatar.dart';

/// Stripe colours to tell teams apart at a glance (repeated if many teams).
const _kTeamStripeColors = <Color>[
  Color(0xFF1565C0),
  Color(0xFF2E7D32),
  Color(0xFFE65100),
  Color(0xFF6A1B9A),
  Color(0xFF00838F),
  Color(0xFFC62828),
];

class LaddersTestPage extends StatefulWidget {
  const LaddersTestPage({super.key});

  @override
  State<LaddersTestPage> createState() => _LaddersTestPageState();
}

class _LaddersTestPageState extends State<LaddersTestPage> with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    context.read<LaddersBloc>().add(const LaddersEvent.onLoadLadders());
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LaddersBloc, LaddersState>(
      builder: (context, state) {
        final status = state.status.status;
        final message = state.status.message?.trim();

        if (status == BaseLoadingStatus.loading) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator.adaptive()),
          );
        }

        if (status == BaseLoadingStatus.loadingFailed) {
          return Scaffold(
            appBar: AppBar(title: const Text('Ladders')),
            body: Center(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  message?.isNotEmpty == true ? message! : 'Failed to load ladders',
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          );
        }

        final l = state.ladders;
        final menCount = l.men?.length ?? 0;
        final ladiesCount = l.ladies?.length ?? 0;
        final mastersCount = l.masters?.length ?? 0;

        return Scaffold(
          appBar: AppBar(
            title: const Text('Ladders'),
            bottom: TabBar(
              controller: _tabController,
              tabs: [
                Tab(text: 'Men${menCount > 0 ? ' ($menCount)' : ''}'),
                Tab(text: 'Ladies${ladiesCount > 0 ? ' ($ladiesCount)' : ''}'),
                Tab(text: 'Masters${mastersCount > 0 ? ' ($mastersCount)' : ''}'),
              ],
            ),
          ),
          body: TabBarView(
            controller: _tabController,
            children: [
              _LadderTabBody(
                items: l.men,
                emptyLabel: 'No men’s ladder entries yet.',
                showLadderBreakdown: l.showLadderBreakdown,
              ),
              _LadderTabBody(
                items: l.ladies,
                emptyLabel: 'No ladies’ ladder entries yet.',
                showLadderBreakdown: l.showLadderBreakdown,
              ),
              _LadderTabBody(
                items: l.masters,
                emptyLabel: 'No masters ladder entries yet.',
                showLadderBreakdown: l.showLadderBreakdown,
              ),
            ],
          ),
        );
      },
    );
  }
}

class _LadderTabBody extends StatelessWidget {
  const _LadderTabBody({
    required this.items,
    required this.emptyLabel,
    required this.showLadderBreakdown,
  });

  final List<LadderItemDTO>? items;
  final String emptyLabel;
  final bool showLadderBreakdown;

  @override
  Widget build(BuildContext context) {
    final list = items;
    if (list == null || list.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Text(
            emptyLabel,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
                ),
          ),
        ),
      );
    }

    if (!showLadderBreakdown) {
      final flat = List<LadderItemDTO>.of(list)
        ..sort((a, b) => (a.order ?? 0).compareTo(b.order ?? 0));
      return ListView.builder(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
        itemCount: flat.length,
        itemBuilder: (context, index) {
          return _PlayerRow(
            item: flat[index],
            rankWithinTeam: index + 1,
          );
        },
      );
    }

    final grouped = _groupByTeamSorted(list);
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
      itemCount: grouped.length,
      itemBuilder: (context, index) {
        final team = grouped[index].key;
        final rows = grouped[index].value;
        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: _TeamBlock(team: team, items: rows),
        );
      },
    );
  }
}

/// Sorted list of (teamId, members ordered by ladder `order`).
List<MapEntry<int, List<LadderItemDTO>>> _groupByTeamSorted(List<LadderItemDTO> items) {
  final map = <int, List<LadderItemDTO>>{};
  for (final e in items) {
    final t = e.team ?? 0;
    map.putIfAbsent(t, () => []).add(e);
  }
  for (final list in map.values) {
    list.sort((a, b) => (a.order ?? 0).compareTo(b.order ?? 0));
  }
  final keys = map.keys.toList()
    ..sort((a, b) {
      if (a == 0 && b != 0) return 1;
      if (b == 0 && a != 0) return -1;
      return a.compareTo(b);
    });
  return [for (final k in keys) MapEntry(k, map[k]!)];
}

Color _accentForTeam(int team) {
  if (team <= 0) return const Color(0xFF607D8E);
  return _kTeamStripeColors[(team - 1) % _kTeamStripeColors.length];
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

String _leagueTitle(int team) {
  if (team <= 0) return 'Unassigned league';
  return '${_ordinalEnglish(team)} League';
}

class _TeamBlock extends StatelessWidget {
  const _TeamBlock({
    required this.team,
    required this.items,
  });

  final int team;
  final List<LadderItemDTO> items;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final accent = _accentForTeam(team);
    final title = _leagueTitle(team);

    return Card(
      elevation: 0,
      color: scheme.surfaceContainerHigh,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: scheme.outline.withValues(alpha: 0.22),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          DecoratedBox(
            decoration: BoxDecoration(
              border: Border(left: BorderSide(color: accent, width: 4)),
              color: accent.withValues(alpha: 0.12),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  Icon(Icons.groups_2_outlined, color: accent, size: 22),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      title,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                    ),
                  ),
                  Text(
                    '${items.length} ${items.length == 1 ? 'player' : 'players'}',
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                          color: scheme.onSurface.withValues(alpha: 0.65),
                        ),
                  ),
                ],
              ),
            ),
          ),
          for (var i = 0; i < items.length; i++) ...[
            if (i > 0) Divider(height: 1, color: scheme.outline.withValues(alpha: 0.2)),
            _PlayerRow(item: items[i], rankWithinTeam: i + 1),
          ],
        ],
      ),
    );
  }
}

class _PlayerRow extends StatelessWidget {
  const _PlayerRow({
    required this.item,
    required this.rankWithinTeam,
  });

  final LadderItemDTO item;
  final int rankWithinTeam;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final name = item.profile?.displayName.trim();
    final titleText = (name != null && name.isNotEmpty) ? name : '(No name)';
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
        leading: ProfileAvatar(
          displayName: titleText,
          imageUrl: item.profile?.profilePictureUrl,
          radius: 22,
          zoomOnTap: true,
        ),
        title: Text(
          titleText,
          style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600),
        ),
        subtitle: Text(
          'Rank $rankWithinTeam',
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: scheme.onSurface.withValues(alpha: 0.62),
              ),
        ),
        trailing: item.canBeChallenged == true
            ? Tooltip(
                message: 'Can be challenged',
                child: Icon(Icons.sports_tennis, color: scheme.primary, size: 22),
              )
            : null,
      ),
    );
  }
}
