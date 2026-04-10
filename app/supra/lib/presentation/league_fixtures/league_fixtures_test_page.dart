import 'package:app_bloc/app_bloc.dart';
import 'package:client_models/client_models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../engine/theme/supra_colors.dart';

/// One row in the fixture selector: a ladder plus either all leagues or one league number.
@immutable
class _FixtureScope {
  const _FixtureScope({required this.ladder, this.leagueTeamId});

  final LadderTypeEnum ladder;

  /// `null` = all fixtures for [ladder].
  final int? leagueTeamId;

  @override
  bool operator ==(Object other) {
    return other is _FixtureScope && other.ladder == ladder && other.leagueTeamId == leagueTeamId;
  }

  @override
  int get hashCode => Object.hash(ladder, leagueTeamId);
}

/// "League 1st", "League 2nd", … (uses [leagueTeam] from the API as the number).
String leagueWithOrdinal(int leagueTeam) => 'League ${_englishOrdinal(leagueTeam)}';

String _englishOrdinal(int n) {
  final a = n.abs();
  if (a % 100 >= 11 && a % 100 <= 13) return '${n}th';
  switch (a % 10) {
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

/// Mens ladder, 1st league team: venue display overrides by **fixture date** (calendar day, local).
final Map<DateTime, String> _mensLeagueFirstTeamVenueOverrides = {
  DateTime(2026, 4, 9): 'VOB',
  DateTime(2026, 4, 16): 'WPCC',
  DateTime(2026, 4, 23): 'Stellenbosch',
  DateTime(2026, 5, 7): 'Camps Bay',
  DateTime(2026, 5, 21): 'Fish Hoek',
  DateTime(2026, 5, 28): 'WPCC',
  DateTime(2026, 6, 4): 'UCT',
  DateTime(2026, 6, 11): 'Camps Bay',
  DateTime(2026, 6, 25): 'VOB',
  DateTime(2026, 7, 23): 'Stellenbosch',
  DateTime(2026, 7, 30): 'Fish Hoek',
  DateTime(2026, 8, 6): 'UCT',
  DateTime(2026, 8, 13): 'WPCC',
  DateTime(2026, 8, 20): 'VOB',
};

DateTime _dateOnlyLocal(DateTime d) {
  final l = d.toLocal();
  return DateTime(l.year, l.month, l.day);
}

/// Venue shown on the card: API value unless mens + 1st league + date has an override.
String _displayVenue(LeagueFixtureDto fixture) {
  final base = fixture.venue.trim().isEmpty ? '—' : fixture.venue;
  if (fixture.ladderType != LadderTypeEnum.mens) return base;
  if (fixture.leagueTeam != 1) return base;
  final key = _dateOnlyLocal(fixture.fixtureDate);
  final override = _mensLeagueFirstTeamVenueOverrides[key];
  if (override != null && override.trim().isNotEmpty) return override;
  return base;
}

class LeagueFixturesTestPage extends StatefulWidget {
  const LeagueFixturesTestPage({super.key, this.nested = false});

  /// When true, omits outer [Scaffold]/[AppBar] so a parent shell can host this page.
  final bool nested;

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
          final child = const Center(child: CircularProgressIndicator.adaptive());
          if (widget.nested) return child;
          return Scaffold(
            appBar: AppBar(title: const Text('League fixtures')),
            body: child,
          );
        }

        if (status == BaseLoadingStatus.loadingFailed) {
          final child = Center(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                message?.isNotEmpty == true ? message! : 'Failed to load league fixtures',
                textAlign: TextAlign.center,
              ),
            ),
          );
          if (widget.nested) return child;
          return Scaffold(
            appBar: AppBar(title: const Text('League fixtures')),
            body: child,
          );
        }

        if (state.fixtures.isEmpty) {
          const child = Center(child: Text('No fixtures found.'));
          if (widget.nested) return child;
          return Scaffold(
            appBar: AppBar(title: const Text('League fixtures')),
            body: child,
          );
        }

        final content = _LeagueFixturesLoadedView(fixtures: state.fixtures, nested: widget.nested);

        if (widget.nested) {
          return content;
        }
        return Scaffold(
          appBar: AppBar(title: const Text('League fixtures')),
          body: content,
        );
      },
    );
  }
}

/// Single selector + scrollable fixture list.
class _LeagueFixturesLoadedView extends StatefulWidget {
  const _LeagueFixturesLoadedView({required this.fixtures, required this.nested});

  final List<LeagueFixtureDto> fixtures;
  final bool nested;

  @override
  State<_LeagueFixturesLoadedView> createState() => _LeagueFixturesLoadedViewState();
}

class _LeagueFixturesLoadedViewState extends State<_LeagueFixturesLoadedView> {
  _FixtureScope? _selection;

  @override
  void didUpdateWidget(covariant _LeagueFixturesLoadedView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.fixtures.isEmpty) return;
    if (oldWidget.fixtures.isEmpty && widget.fixtures.isNotEmpty) {
      _selection = _defaultSelection(widget.fixtures);
    }
  }

  @override
  void initState() {
    super.initState();
    if (widget.fixtures.isNotEmpty) {
      _selection = _defaultSelection(widget.fixtures);
    }
  }

  _FixtureScope _selectionOrDefault() {
    return _selection ?? _defaultSelection(widget.fixtures)!;
  }

  List<int> _leagueTeamIds(LadderTypeEnum ladder) {
    final ids = widget.fixtures.where((f) => f.ladderType == ladder).map((f) => f.leagueTeam).toSet().toList()..sort();
    return ids;
  }

  List<DropdownMenuEntry<_FixtureScope>> _menuEntries() {
    final out = <DropdownMenuEntry<_FixtureScope>>[];
    for (final lt in LadderTypeEnum.values) {
      final ids = _leagueTeamIds(lt);
      if (ids.isEmpty) continue;
      out.add(
        DropdownMenuEntry<_FixtureScope>(
          value: _FixtureScope(ladder: lt, leagueTeamId: null),
          label: '${lt.friendlyName} · All leagues',
        ),
      );
      for (final id in ids) {
        out.add(
          DropdownMenuEntry<_FixtureScope>(
            value: _FixtureScope(ladder: lt, leagueTeamId: id),
            label: '${lt.friendlyName} · ${leagueWithOrdinal(id)}',
          ),
        );
      }
    }
    return out;
  }

  List<LeagueFixtureDto> _filteredFor(_FixtureScope sel) {
    var list = widget.fixtures.where((f) => f.ladderType == sel.ladder).toList();
    if (sel.leagueTeamId != null) {
      list = list.where((f) => f.leagueTeam == sel.leagueTeamId).toList();
    }
    list.sort((a, b) => a.fixtureDate.compareTo(b.fixtureDate));
    return list;
  }

  @override
  Widget build(BuildContext context) {
    final entries = _menuEntries();
    if (entries.isEmpty) {
      return const Center(child: Text('No fixtures to show.'));
    }

    final sel = entries.any((e) => e.value == _selectionOrDefault()) ? _selectionOrDefault() : entries.first.value;

    final filtered = _filteredFor(sel);
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final maxMenuWidth = 320.0;

    void onSelected(_FixtureScope? value) {
      if (value == null) return;
      setState(() => _selection = value);
    }

    final filters = Padding(
      padding: const EdgeInsets.fromLTRB(10, 12, 10, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Align(
            alignment: Alignment.center,
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: maxMenuWidth),
              child: DropdownMenuFormField<_FixtureScope>(
                initialSelection: sel,
                label: const Text('Fixtures'),
                dropdownMenuEntries: entries,
                onSelected: onSelected,
                width: maxMenuWidth,
                menuStyle: MenuStyle(maximumSize: WidgetStateProperty.all(Size(maxMenuWidth, 360))),
              ),
            ),
          ),
        ],
      ),
    );

    final teamIds = _leagueTeamIds(sel.ladder);

    final list = filtered.isEmpty
        ? Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Text(
                teamIds.isEmpty ? 'No fixtures for this ladder.' : 'No fixtures for this selection.',
                textAlign: TextAlign.center,
                style: textTheme.bodyLarge?.copyWith(color: SupraColors.textSecondary),
              ),
            ),
          )
        : ListView.builder(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
            itemCount: filtered.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: _FixtureCard(fixture: filtered[index]),
              );
            },
          );

    if (widget.nested) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Material(color: scheme.surface.withValues(alpha: 0.35), child: filters),
          Expanded(child: list),
        ],
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        filters,
        Expanded(child: list),
      ],
    );
  }
}

_FixtureScope? _defaultSelection(List<LeagueFixtureDto> fixtures) {
  final firstLt = _firstLadderWithFixtures(fixtures);
  if (firstLt == null) return null;
  return _FixtureScope(ladder: firstLt, leagueTeamId: null);
}

LadderTypeEnum? _firstLadderWithFixtures(List<LeagueFixtureDto> fixtures) {
  for (final lt in LadderTypeEnum.values) {
    if (fixtures.any((f) => f.ladderType == lt)) return lt;
  }
  return null;
}

bool _isVobSide(String team) => team.trim().toUpperCase() == 'VOB';

/// VOB plays at home when listed as the home team (see [LeagueFixtureAssembler]).
bool _isVobHome(LeagueFixtureDto f) => _isVobSide(f.homeTeam);

Future<void> _launchPhoneDialer(String? raw) async {
  if (raw == null || raw.trim().isEmpty) return;
  final cleaned = raw.replaceAll(RegExp(r'[\s\-]'), '');
  if (cleaned.isEmpty) return;
  final uri = Uri.parse('tel:$cleaned');
  if (await canLaunchUrl(uri)) {
    await launchUrl(uri);
  }
}

class _FixtureCard extends StatelessWidget {
  const _FixtureCard({required this.fixture});

  final LeagueFixtureDto fixture;

  static final _dateFormat = DateFormat('EEEE, d MMMM y');

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final scheme = Theme.of(context).colorScheme;
    final isHome = _isVobHome(fixture);
    final cap = fixture.clubCaptain;
    final catering = cap?.isCatering == true;
    final captainName = cap?.captainName?.trim();
    final phone = cap?.captainContactNo?.trim();
    final venue = !isHome ? 'Playing at: ${_displayVenue(fixture)}' : '';
    final dateLabel = _dateFormat.format(fixture.fixtureDate);
    final matchTitle = '${fixture.homeTeam} vs ${fixture.awayTeam}';

    return Card(
      elevation: 0,
      color: scheme.surface.withValues(alpha: 0.92),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: scheme.outline.withValues(alpha: 0.22)),
      ),
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    matchTitle,
                    style: textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700, height: 1.2),
                    maxLines: 4,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 12),
                Flexible(
                  child: Text(
                    dateLabel,
                    textAlign: TextAlign.right,
                    style: textTheme.titleSmall?.copyWith(
                      color: SupraColors.textSecondary,
                      fontWeight: FontWeight.w600,
                      height: 1.25,
                    ),
                    maxLines: 4,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                _HomeAwayBadge(isHome: isHome),
                _CateringTag(isCatering: catering),
              ],
            ),
            const SizedBox(height: 12),
            if (!isHome) ...[
              Text(venue, style: textTheme.bodyLarge?.copyWith(height: 1.35)),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 14),
                child: Divider(height: 1, color: scheme.tertiary.withValues(alpha: 0.45)),
              ),
            ],

            Text(
              'Opposition captain',
              style: textTheme.labelLarge?.copyWith(
                color: SupraColors.textSecondary,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.2,
              ),
            ),
            const SizedBox(height: 8),
            if (captainName != null && captainName.isNotEmpty && phone != null && phone.isNotEmpty)
              Semantics(
                button: true,
                label: 'Call $captainName on $phone',
                child: Material(
                  color: scheme.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                  child: InkWell(
                    onTap: () => _launchPhoneDialer(phone),
                    borderRadius: BorderRadius.circular(12),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(Icons.phone_in_talk_outlined, size: 22, color: scheme.primary),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text.rich(
                                  TextSpan(
                                    style: textTheme.titleMedium?.copyWith(height: 1.25),
                                    children: [
                                      TextSpan(
                                        text: captainName,
                                        style: const TextStyle(fontWeight: FontWeight.w700),
                                      ),
                                      TextSpan(
                                        text: ' · ',
                                        style: TextStyle(color: SupraColors.textSecondary, fontWeight: FontWeight.w500),
                                      ),
                                      TextSpan(
                                        text: phone,
                                        style: TextStyle(color: scheme.primary, fontWeight: FontWeight.w700),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Row(
                                  children: [
                                    Icon(Icons.touch_app_outlined, size: 16, color: SupraColors.textSecondary),
                                    const SizedBox(width: 6),
                                    Text(
                                      'Tap to call',
                                      style: textTheme.bodySmall?.copyWith(color: SupraColors.textSecondary),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Icon(Icons.chevron_right_rounded, color: SupraColors.textSecondary),
                        ],
                      ),
                    ),
                  ),
                ),
              )
            else if (captainName != null && captainName.isNotEmpty)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(captainName, style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700, height: 1.25)),
                  const SizedBox(height: 6),
                  Text(
                    'No phone number on file',
                    style: textTheme.bodySmall?.copyWith(color: SupraColors.textSecondary),
                  ),
                ],
              )
            else
              Text('Not listed', style: textTheme.bodyMedium?.copyWith(color: SupraColors.textSecondary)),
          ],
        ),
      ),
    );
  }
}

/// Compact catering hint (replaces a tall [Chip]).
class _CateringTag extends StatelessWidget {
  const _CateringTag({required this.isCatering});
  final bool isCatering;
  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final scheme = Theme.of(context).colorScheme;
    final icon = isCatering ? Icons.restaurant_outlined : Icons.restaurant_outlined;
    final text = isCatering ? 'Catering' : 'No catering';
    final color = isCatering ? scheme.tertiary : SupraColors.warning;
    final backgroundColor = isCatering
        ? scheme.tertiary.withValues(alpha: 0.2)
        : SupraColors.warning.withValues(alpha: 0.1);
    return DecoratedBox(
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 16, color: color),
            const SizedBox(width: 6),
            Text(
              text,
              style: textTheme.labelMedium?.copyWith(fontWeight: FontWeight.w600, color: scheme.onSurface),
            ),
          ],
        ),
      ),
    );
  }
}

class _HomeAwayBadge extends StatelessWidget {
  const _HomeAwayBadge({required this.isHome});

  final bool isHome;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: isHome ? SupraColors.secondary.withValues(alpha: 0.22) : SupraColors.tertiary.withValues(alpha: 0.35),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: isHome ? SupraColors.secondary : SupraColors.tertiary, width: 1),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Text(
          isHome ? 'Home' : 'Away',
          style: textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w800, letterSpacing: 0.5),
        ),
      ),
    );
  }
}
