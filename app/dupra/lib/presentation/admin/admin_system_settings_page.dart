import 'package:app_bloc/app_bloc.dart';
import 'package:client_models/client_models.dart';
import 'package:dupra/engine/theme/dupra_colors.dart';
import 'package:dupra/presentation/widgets/dupra_accent_section_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

/// System flags and ladder breakdown from [SettingsBloc].
class AdminSystemSettingsPage extends StatefulWidget {
  const AdminSystemSettingsPage({super.key});

  @override
  State<AdminSystemSettingsPage> createState() => _AdminSystemSettingsPageState();
}

BreakdownTeamsDTO _snapshotLadderDraft(BreakdownTeamsDTO b) => BreakdownTeamsDTO(
      objectId: b.objectId,
      mensteams: b.mensteams != null ? List<BreakdownItemDTO>.from(b.mensteams!) : [],
      ladiesTeams: b.ladiesTeams != null ? List<BreakdownItemDTO>.from(b.ladiesTeams!) : [],
      mastersTeams: b.mastersTeams != null ? List<BreakdownItemDTO>.from(b.mastersTeams!) : [],
    );

enum _LadderBucket { men, ladies, masters }

class _AdminSystemSettingsPageState extends State<AdminSystemSettingsPage> {
  BreakdownTeamsDTO? _ladderDraft;
  bool _ladderDraftDirty = false;
  bool _awaitingLadderSave = false;

  @override
  void initState() {
    super.initState();
    context.read<SettingsBloc>().add(const SettingsEvent.onLoadSettings());
  }

  Future<void> _onRefresh() async {
    final bloc = context.read<SettingsBloc>()..add(const SettingsEvent.onLoadSettings());
    try {
      await bloc.stream.timeout(const Duration(seconds: 45)).firstWhere(
            (s) =>
                s.status.status == BaseLoadingStatus.loadingSuccess ||
                s.status.status == BaseLoadingStatus.loadingFailed,
          );
    } on Exception {
      // Stop the indicator even if the request stalls.
    }
  }

  void _patchMemberCount(_LadderBucket bucket, int index, int? memberCount) {
    final blocState = context.read<SettingsBloc>().state;
    final base = _ladderDraft ?? _snapshotLadderDraft(blocState.settings.ladderBreakdown);
    switch (bucket) {
      case _LadderBucket.men:
        final next = List<BreakdownItemDTO>.from(base.mensteams ?? []);
        if (index < 0 || index >= next.length) return;
        final cur = next[index];
        next[index] = BreakdownItemDTO(teamNumber: cur.teamNumber, teamMemberCount: memberCount);
        setState(() {
          _ladderDraft = base.copyWith(mensteams: next);
          _ladderDraftDirty = true;
        });
      case _LadderBucket.ladies:
        final next = List<BreakdownItemDTO>.from(base.ladiesTeams ?? []);
        if (index < 0 || index >= next.length) return;
        final cur = next[index];
        next[index] = BreakdownItemDTO(teamNumber: cur.teamNumber, teamMemberCount: memberCount);
        setState(() {
          _ladderDraft = base.copyWith(ladiesTeams: next);
          _ladderDraftDirty = true;
        });
      case _LadderBucket.masters:
        final next = List<BreakdownItemDTO>.from(base.mastersTeams ?? []);
        if (index < 0 || index >= next.length) return;
        final cur = next[index];
        next[index] = BreakdownItemDTO(teamNumber: cur.teamNumber, teamMemberCount: memberCount);
        setState(() {
          _ladderDraft = base.copyWith(mastersTeams: next);
          _ladderDraftDirty = true;
        });
    }
  }

  List<BreakdownItemDTO>? _listForBucket(BreakdownTeamsDTO d, _LadderBucket bucket) => switch (bucket) {
        _LadderBucket.men => d.mensteams,
        _LadderBucket.ladies => d.ladiesTeams,
        _LadderBucket.masters => d.mastersTeams,
      };

  @override
  Widget build(BuildContext context) {
    final variant = Theme.of(context).colorScheme.onSurfaceVariant;

    return BlocListener<SettingsBloc, SettingsState>(
      listenWhen: (prev, curr) =>
          prev.status.status != curr.status.status &&
          (curr.status.status == BaseLoadingStatus.loadingSuccess ||
              curr.status.status == BaseLoadingStatus.saveSuccess ||
              curr.status.status == BaseLoadingStatus.saveFailed),
      listener: (context, state) {
        final st = state.status.status;
        if (st == BaseLoadingStatus.loadingSuccess && !_ladderDraftDirty) {
          setState(() {
            _ladderDraft = _snapshotLadderDraft(state.settings.ladderBreakdown);
          });
        }
        if (st == BaseLoadingStatus.saveSuccess && _awaitingLadderSave) {
          setState(() {
            _awaitingLadderSave = false;
            _ladderDraftDirty = false;
            _ladderDraft = _snapshotLadderDraft(state.settings.ladderBreakdown);
          });
        }
        if (st == BaseLoadingStatus.saveFailed && _awaitingLadderSave) {
          setState(() {
            _awaitingLadderSave = false;
          });
        }
      },
      child: BlocConsumer<SettingsBloc, SettingsState>(
        listenWhen: (prev, curr) =>
            prev.status.status != curr.status.status &&
            (curr.status.status == BaseLoadingStatus.saveSuccess || curr.status.status == BaseLoadingStatus.saveFailed),
        listener: (context, state) {
          final messenger = ScaffoldMessenger.of(context);
          final st = state.status.status;
          if (st == BaseLoadingStatus.saveSuccess) {
            messenger.showSnackBar(const SnackBar(content: Text('Saved.')));
          } else if (st == BaseLoadingStatus.saveFailed) {
            final msg = state.status.message?.trim();
            messenger.showSnackBar(
              SnackBar(content: Text(msg != null && msg.isNotEmpty ? msg : 'Could not save.')),
            );
          }
        },
        builder: (context, state) {
          final status = state.status.status;
          final err = state.status.message?.trim();
          final saving = status == BaseLoadingStatus.saving;
          final s = state.settings;
          final ladder = _ladderDraft ?? _snapshotLadderDraft(s.ladderBreakdown);

          return Scaffold(
            appBar: AppBar(
              title: const Text('System settings'),
              leading: IconButton(
                icon: const Icon(Icons.arrow_back_rounded),
                onPressed: () => context.pop(),
              ),
            ),
            body: switch (status) {
              BaseLoadingStatus.loading || BaseLoadingStatus.initial =>
                const Center(child: CircularProgressIndicator.adaptive()),
              BaseLoadingStatus.loadingFailed => Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Text(
                      err != null && err.isNotEmpty ? err : 'Failed to load settings.',
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              _ => RefreshIndicator(
                  onRefresh: _onRefresh,
                  child: CustomScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    slivers: [
                      SliverPadding(
                        padding: EdgeInsets.fromLTRB(
                          24,
                          16,
                          24,
                          24 + MediaQuery.paddingOf(context).bottom,
                        ),
                        sliver: SliverList.list(
                          children: [
                            Text(
                              'Values come from the ${SettingsTypeEnum.systemSettings.friendlyName} and '
                              '${SettingsTypeEnum.currentLeagueTeamBreakdown.friendlyName} rows.',
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: variant),
                            ),
                            const SizedBox(height: 20),
                            DupraAccentSectionCard(
                              accentColor: DupraColors.secondary,
                              headerTitle: SettingsTypeEnum.systemSettings.friendlyName,
                              headerIcon: Icons.tune_rounded,
                              body: Padding(
                                padding: const EdgeInsets.only(bottom: 8),
                                child: Column(
                                  children: [
                                    ListTile(
                                      title: const Text('Legacy object id'),
                                      subtitle: SelectableText(
                                        s.systemSettings.objectId.isEmpty ? '—' : s.systemSettings.objectId,
                                      ),
                                    ),
                                    SwitchListTile.adaptive(
                                      title: const Text('Show ladder breakdown'),
                                      subtitle: Text(
                                        'Controls whether ladder breakdown data is surfaced in member-facing UX.',
                                        style: Theme.of(context).textTheme.bodySmall?.copyWith(color: variant),
                                      ),
                                      value: s.systemSettings.showLadderBreakdown,
                                      onChanged: saving
                                          ? null
                                          : (v) {
                                              context.read<SettingsBloc>().add(
                                                    SettingsEvent.onSaveShowLadderBreakdown(show: v),
                                                  );
                                            },
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),
                            DupraAccentSectionCard(
                              accentColor: DupraColors.tertiary,
                              headerTitle: 'Ladder team breakdown',
                              headerIcon: Icons.grid_view_rounded,
                              body: Padding(
                                padding: const EdgeInsets.only(bottom: 12),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.stretch,
                                  children: [
                                    ListTile(
                                      title: const Text('Breakdown row id'),
                                      subtitle: SelectableText(
                                        ladder.objectId?.isNotEmpty != true ? '—' : ladder.objectId!,
                                      ),
                                    ),
                                    _EditableTeamBreakdownExpansion(
                                      title: "Men's teams",
                                      teams: _listForBucket(ladder, _LadderBucket.men),
                                      bucket: _LadderBucket.men,
                                      enabled: !saving,
                                      onMemberCountCommitted: _patchMemberCount,
                                    ),
                                    _EditableTeamBreakdownExpansion(
                                      title: "Ladies' teams",
                                      teams: _listForBucket(ladder, _LadderBucket.ladies),
                                      bucket: _LadderBucket.ladies,
                                      enabled: !saving,
                                      onMemberCountCommitted: _patchMemberCount,
                                    ),
                                    _EditableTeamBreakdownExpansion(
                                      title: 'Masters teams',
                                      teams: _listForBucket(ladder, _LadderBucket.masters),
                                      bucket: _LadderBucket.masters,
                                      enabled: !saving,
                                      onMemberCountCommitted: _patchMemberCount,
                                    ),
                                    const SizedBox(height: 12),
                                    Align(
                                      alignment: Alignment.centerRight,
                                      child: FilledButton(
                                        onPressed: saving || !_ladderDraftDirty || _ladderDraft == null
                                            ? null
                                            : () {
                                                FocusScope.of(context).unfocus();
                                                FocusManager.instance.primaryFocus?.unfocus();
                                                WidgetsBinding.instance.addPostFrameCallback((_) {
                                                  if (!context.mounted) {
                                                    return;
                                                  }
                                                  final draft = _ladderDraft;
                                                  if (draft == null || !_ladderDraftDirty) {
                                                    return;
                                                  }
                                                  setState(() => _awaitingLadderSave = true);
                                                  context.read<SettingsBloc>().add(
                                                        SettingsEvent.onSaveLadderTeamBreakdown(breakdown: draft),
                                                      );
                                                });
                                              },
                                        child: const Text('Save breakdown'),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Edit members per team, then tap Save breakdown. Persisted via Supabase PATCH on the ladder settings row.',
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(color: variant),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
            },
          );
        },
      ),
    );
  }
}

class _EditableTeamBreakdownExpansion extends StatelessWidget {
  const _EditableTeamBreakdownExpansion({
    required this.title,
    required this.teams,
    required this.bucket,
    required this.enabled,
    required this.onMemberCountCommitted,
  });

  final String title;
  final List<BreakdownItemDTO>? teams;
  final _LadderBucket bucket;
  final bool enabled;
  final void Function(_LadderBucket bucket, int index, int? memberCount) onMemberCountCommitted;

  @override
  Widget build(BuildContext context) {
    final list = teams;
    final n = list?.length ?? 0;
    final scheme = Theme.of(context).colorScheme;

    return ExpansionTile(
      title: Text('$title ($n)'),
      children: [
        if (list == null || list.isEmpty)
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'No teams in this bucket.',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(color: scheme.onSurfaceVariant),
              ),
            ),
          )
        else
          Padding(
            padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
            child: Column(
              children: [
                for (var i = 0; i < list.length; i++)
                  ListTile(
                    dense: true,
                    title: Text('Team ${list[i].teamNumber ?? '—'}'),
                    trailing: SizedBox(
                      width: 88,
                      child: _MemberCountField(
                        key: ValueKey<String>('${bucket.name}-${list[i].teamNumber}-$i'),
                        initialCount: list[i].teamMemberCount,
                        enabled: enabled,
                        onCommitted: (v) => onMemberCountCommitted(bucket, i, v),
                      ),
                    ),
                  ),
              ],
            ),
          ),
      ],
    );
  }
}

class _MemberCountField extends StatefulWidget {
  const _MemberCountField({
    required this.initialCount,
    required this.enabled,
    required this.onCommitted,
    super.key,
  });

  final int? initialCount;
  final bool enabled;
  final ValueChanged<int?> onCommitted;

  @override
  State<_MemberCountField> createState() => _MemberCountFieldState();
}

class _MemberCountFieldState extends State<_MemberCountField> {
  late final TextEditingController _controller;
  FocusNode? _focus;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialCount?.toString() ?? '');
    _focus = FocusNode()..addListener(_onFocusChange);
  }

  void _onFocusChange() {
    if (_focus?.hasFocus ?? false) {
      return;
    }
    _commit();
  }

  void _commit() {
    final raw = _controller.text.trim();
    widget.onCommitted(raw.isEmpty ? null : int.tryParse(raw));
  }

  @override
  void didUpdateWidget(_MemberCountField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialCount != widget.initialCount && !(_focus?.hasFocus ?? false)) {
      final next = widget.initialCount?.toString() ?? '';
      if (_controller.text != next) {
        _controller.text = next;
      }
    }
  }

  @override
  void dispose() {
    _focus?.removeListener(_onFocusChange);
    _focus?.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _controller,
      focusNode: _focus,
      enabled: widget.enabled,
      keyboardType: TextInputType.number,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      textAlign: TextAlign.end,
      decoration: const InputDecoration(
        isDense: true,
      ),
      onChanged: (_) => _commit(),
      onEditingComplete: _commit,
    );
  }
}
