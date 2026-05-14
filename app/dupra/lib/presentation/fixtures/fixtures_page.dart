import 'package:app_bloc/app_bloc.dart';
import 'package:client_models/client_models.dart';
import 'package:dupra/engine/theme/dupra_colors.dart';
import 'package:dupra/presentation/fixtures/data/fixture_display_helpers.dart';
import 'package:dupra/presentation/fixtures/widgets/dupra_league_fixture_card.dart';
import 'package:dupra/presentation/shell/shell_tab_insets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Member fixtures tab — loads league fixtures via [LeagueFixturesBloc].
class FixturesPage extends StatelessWidget {
  const FixturesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => appBlocSl<LeagueFixturesBloc>()..add(const LeagueFixturesEvent.onLoadLeagueFixtures()),
      child: const _FixturesView(),
    );
  }
}

class _FixturesView extends StatelessWidget {
  const _FixturesView();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LeagueFixturesBloc, LeagueFixturesState>(
      builder: (context, state) {
        final status = state.status.status;

        if (status == BaseLoadingStatus.initial || status == BaseLoadingStatus.loading) {
          return Padding(
            padding: dupraShellTabPadding(context),
            child: const Center(child: CircularProgressIndicator.adaptive()),
          );
        }

        if (status == BaseLoadingStatus.loadingFailed) {
          final trimmed = state.status.message?.trim();
          final errorText = (trimmed != null && trimmed.isNotEmpty) ? trimmed : 'Failed to load fixtures';
          return Padding(
            padding: dupraShellTabPadding(context),
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Text(errorText, textAlign: TextAlign.center),
              ),
            ),
          );
        }

        if (state.fixtures.isEmpty) {
          return Padding(
            padding: dupraShellTabPadding(context),
            child: const Center(child: Text('No fixtures found.')),
          );
        }

        return _FixturesLoadedBody(fixtures: state.fixtures);
      },
    );
  }
}

class _FixturesLoadedBody extends StatefulWidget {
  const _FixturesLoadedBody({required this.fixtures});

  final List<LeagueFixtureDto> fixtures;

  @override
  State<_FixturesLoadedBody> createState() => _FixturesLoadedBodyState();
}

class _FixturesLoadedBodyState extends State<_FixturesLoadedBody> with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  /// Selected league team index per ladder (must exist in data for that ladder).
  final Map<LadderTypeEnum, int> _leagueTeamSelection = {};

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: LadderTypeEnum.values.length, vsync: this);
    _syncSelectionsWithData();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant _FixturesLoadedBody oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.fixtures != widget.fixtures) {
      _syncSelectionsWithData();
    }
  }

  void _syncSelectionsWithData() {
    for (final lt in LadderTypeEnum.values) {
      final ids = _leagueTeamIds(lt);
      if (ids.isEmpty) {
        _leagueTeamSelection.remove(lt);
        continue;
      }
      final current = _leagueTeamSelection[lt];
      if (current == null || !ids.contains(current)) {
        _leagueTeamSelection[lt] = ids.first;
      }
    }
  }

  List<int> _leagueTeamIds(LadderTypeEnum ladder) {
    final ids = widget.fixtures.where((f) => f.ladderType == ladder).map((f) => f.leagueTeam).toSet().toList()
      ..sort();
    return ids;
  }

  List<LeagueFixtureDto> _fixturesFor(LadderTypeEnum ladder, int leagueTeamId) {
    final list = widget.fixtures.where((f) => f.ladderType == ladder && f.leagueTeam == leagueTeamId).toList()
      ..sort((a, b) => a.fixtureDate.compareTo(b.fixtureDate));
    return list;
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final shellBottom = dupraShellTabPadding(context).bottom;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TabBar(
            controller: _tabController,
            tabs: [
              for (final lt in LadderTypeEnum.values)
                Tab(
                  text: _tabLabel(lt),
                ),
            ],
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                for (final lt in LadderTypeEnum.values)
                  _FixturesLadderTab(
                    ladder: lt,
                    leagueTeamIds: _leagueTeamIds(lt),
                    selectedLeagueTeamId: _leagueTeamSelection[lt],
                    textTheme: textTheme,
                    scheme: scheme,
                    shellBottomPadding: shellBottom,
                    onLeagueSelected: (id) => setState(() => _leagueTeamSelection[lt] = id),
                    fixturesForSelection: _fixturesFor,
                  ),
              ],
            ),
          ),
          SizedBox(height: MediaQuery.paddingOf(context).bottom),
        ],
      ),
    );
  }

  String _tabLabel(LadderTypeEnum lt) {
    switch (lt) {
      case LadderTypeEnum.mens:
        return 'Men';
      case LadderTypeEnum.ladies:
        return 'Ladies';
      case LadderTypeEnum.masters:
        return 'Masters';
    }
  }
}

class _FixturesLadderTab extends StatelessWidget {
  const _FixturesLadderTab({
    required this.ladder,
    required this.leagueTeamIds,
    required this.selectedLeagueTeamId,
    required this.textTheme,
    required this.scheme,
    required this.shellBottomPadding,
    required this.onLeagueSelected,
    required this.fixturesForSelection,
  });

  final LadderTypeEnum ladder;
  final List<int> leagueTeamIds;
  final int? selectedLeagueTeamId;
  final TextTheme textTheme;
  final ColorScheme scheme;
  final double shellBottomPadding;
  final ValueChanged<int> onLeagueSelected;
  final List<LeagueFixtureDto> Function(LadderTypeEnum ladder, int leagueTeamId) fixturesForSelection;

  static const double _maxMenuWidth = 320;

  String _emptyMessage(LadderTypeEnum lt) {
    switch (lt) {
      case LadderTypeEnum.mens:
        return 'No men’s fixtures yet.';
      case LadderTypeEnum.ladies:
        return 'No ladies’ fixtures yet.';
      case LadderTypeEnum.masters:
        return 'No masters fixtures yet.';
    }
  }

  @override
  Widget build(BuildContext context) {
    if (leagueTeamIds.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Text(
            _emptyMessage(ladder),
            textAlign: TextAlign.center,
            style: textTheme.bodyLarge?.copyWith(color: DupraColors.textSecondary),
          ),
        ),
      );
    }

    final selId = selectedLeagueTeamId ?? leagueTeamIds.first;
    final filtered = fixturesForSelection(ladder, selId);

    final filters = Padding(
      padding: const EdgeInsets.fromLTRB(10, 12, 10, 8),
      child: Align(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: _maxMenuWidth),
          child: DropdownMenuFormField<int>(
            key: ValueKey('fixtures-league-$ladder-$selId-${leagueTeamIds.join('-')}'),
            initialSelection: selId,
            label: const Text('League'),
            dropdownMenuEntries: [
              for (final id in leagueTeamIds)
                DropdownMenuEntry<int>(
                  value: id,
                  label: leagueWithOrdinalLabel(id),
                ),
            ],
            onSelected: (value) {
              if (value == null) return;
              onLeagueSelected(value);
            },
            width: _maxMenuWidth,
            menuStyle: MenuStyle(maximumSize: WidgetStateProperty.all(const Size(_maxMenuWidth, 360))),
          ),
        ),
      ),
    );

    final list = filtered.isEmpty
        ? Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Text(
                'No fixtures for this league.',
                textAlign: TextAlign.center,
                style: textTheme.bodyLarge?.copyWith(color: DupraColors.textSecondary),
              ),
            ),
          )
        : ListView.builder(
            padding: EdgeInsets.only(top: 8, bottom: shellBottomPadding),
            itemCount: filtered.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: DupraLeagueFixtureCard(fixture: filtered[index]),
              );
            },
          );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Material(color: scheme.surface.withValues(alpha: 0.35), child: filters),
        Expanded(child: list),
      ],
    );
  }
}
