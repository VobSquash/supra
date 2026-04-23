import 'package:app_bloc/app_bloc.dart';
import 'package:client_models/client_models.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:middleware/middleware.dart';

class AdminLaddersManagementPage extends StatefulWidget {
  const AdminLaddersManagementPage({super.key});

  @override
  State<AdminLaddersManagementPage> createState() => _AdminLaddersManagementPageState();
}

class _AdminLaddersManagementPageState extends State<AdminLaddersManagementPage> with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  final IUsersFacade _users = appBlocSl<IUsersFacade>();

  List<LadderItemDTO> _men = const [];
  List<LadderItemDTO> _ladies = const [];
  List<LadderItemDTO> _masters = const [];
  bool _initializedFromState = false;

  List<BasicProfileDTO> _allProfiles = const [];
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    context.read<LaddersBloc>().add(const LaddersEvent.onLoadLadders());
    _loadProfiles();
  }

  Future<void> _loadProfiles() async {
    try {
      final profiles = await _users.loadBasicProfiles();
      if (!mounted) return;
      setState(() => _allProfiles = profiles);
    } catch (_) {
      // Keep page usable for reorder even if profile search fails.
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _showCopyableErrorSnack(String message) {
    final messenger = ScaffoldMessenger.of(context);
    messenger.showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 20),
        action: SnackBarAction(
          label: 'Copy',
          onPressed: () async {
            await Clipboard.setData(ClipboardData(text: message));
            if (!mounted) return;
            messenger.hideCurrentSnackBar();
            messenger.showSnackBar(const SnackBar(content: Text('Copied to clipboard')));
          },
        ),
      ),
    );
  }

  LadderDivision get _activeDivision {
    switch (_tabController.index) {
      case 0:
        return LadderDivision.men;
      case 1:
        return LadderDivision.ladies;
      case 2:
        return LadderDivision.masters;
      default:
        return LadderDivision.men;
    }
  }

  List<LadderItemDTO> _itemsFor(LadderDivision d) {
    switch (d) {
      case LadderDivision.men:
        return _men;
      case LadderDivision.ladies:
        return _ladies;
      case LadderDivision.masters:
        return _masters;
    }
  }

  void _setItemsFor(LadderDivision d, List<LadderItemDTO> v) {
    switch (d) {
      case LadderDivision.men:
        _men = v;
        return;
      case LadderDivision.ladies:
        _ladies = v;
        return;
      case LadderDivision.masters:
        _masters = v;
        return;
    }
  }

  Future<void> _saveActiveDivision() async {
    if (_saving) return;
    final d = _activeDivision;
    final items = _itemsFor(d);
    setState(() => _saving = true);
    try {
      await context.read<LaddersBloc>().saveLadderDivision(division: d, items: items);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Ladder saved.')));
      setState(() => _initializedFromState = false);
      context.read<LaddersBloc>().add(const LaddersEvent.onLoadLadders());
    } catch (e) {
      if (!mounted) return;
      _showCopyableErrorSnack(e.toString());
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  Future<void> _addMemberToActiveDivision() async {
    final d = _activeDivision;
    final existingGuids = _itemsFor(d).map((e) => e.vobGuid?.trim()).whereType<String>().where((e) => e.isNotEmpty).toSet();
    final available = _allProfiles
        .where((p) {
          final g = p.vobGuid?.trim();
          return g != null &&
              g.isNotEmpty &&
              !existingGuids.contains(g) &&
              p.isActive == true &&
              _isLadderEligibleMembership(p.extendedProfile?.membershipType);
        })
        .toList(growable: false);
    if (available.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('No available members to add.')));
      return;
    }

    final selected = await showDialog<BasicProfileDTO>(
      context: context,
      builder: (ctx) => _SelectProfileDialog(profiles: available),
    );
    if (selected == null || !mounted) return;

    final list = List<LadderItemDTO>.of(_itemsFor(d));
    final nextOrder = list.length + 1;
    final nextTeam = list.isNotEmpty ? list.last.team : 1;
    final newItem = LadderItemDTO.empty().copyWith(
      vobGuid: selected.vobGuid,
      order: nextOrder,
      team: nextTeam,
      canBeChallenged: false,
      profile: selected,
    );
    setState(() => _setItemsFor(d, [...list, newItem]));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Member added locally. Tap Save order to persist.')),
    );
  }

  Future<void> _removeMemberFromActiveDivision(LadderItemDTO item) async {
    final d = _activeDivision;
    final guid = item.vobGuid?.trim();
    if (guid == null || guid.isEmpty) return;
    final name = item.profile?.displayName.trim().isNotEmpty == true ? item.profile!.displayName.trim() : 'this member';
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Remove from ladder?'),
        content: Text('Remove $name from this ladder?'),
        actions: [
          TextButton(onPressed: () => Navigator.of(ctx).pop(false), child: const Text('Cancel')),
          FilledButton(onPressed: () => Navigator.of(ctx).pop(true), child: const Text('Remove')),
        ],
      ),
    );
    if (confirm != true || !mounted) return;

    setState(() => _saving = true);
    try {
      await context.read<LaddersBloc>().removeMemberFromDivision(division: d, vobGuid: guid);
      if (!mounted) return;
      final updated = List<LadderItemDTO>.of(_itemsFor(d))
          .where((e) => (e.vobGuid?.trim() ?? '') != guid)
          .toList(growable: false);
      for (var i = 0; i < updated.length; i++) {
        updated[i] = updated[i].copyWith(order: i + 1);
      }
      setState(() => _setItemsFor(d, updated));
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Member removed from ladder.')));
    } catch (e) {
      if (!mounted) return;
      _showCopyableErrorSnack(e.toString());
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, authState) {
        final canAdmin = authState.maybeWhen(
          authenticated: (s) => ProfileTypeEnum.get(s.profileTypeId ?? -1).isAdminOrElevated,
          orElse: () => false,
        );
        if (!canAdmin) {
          return Scaffold(
            appBar: AppBar(title: const Text('Ladder management')),
            body: const Center(child: Text('Only administrators/elevated users can manage ladders.')),
          );
        }

        return BlocBuilder<LaddersBloc, LaddersState>(
          builder: (context, state) {
            if (!_initializedFromState && state.status.status == BaseLoadingStatus.loadingSuccess) {
              _men = _sorted(state.ladders.men);
              _ladies = _sorted(state.ladders.ladies);
              _masters = _sorted(state.ladders.masters);
              _initializedFromState = true;
            }

            final loading = state.status.status == BaseLoadingStatus.loading && !_initializedFromState;
            if (loading) {
              return const Scaffold(body: Center(child: CircularProgressIndicator.adaptive()));
            }

            return Scaffold(
              appBar: AppBar(
                title: const Text('Ladder management'),
                actions: [
                  IconButton(
                    tooltip: 'Add member',
                    onPressed: _saving ? null : _addMemberToActiveDivision,
                    icon: const Icon(Icons.person_add_alt_1_rounded),
                  ),
                  TextButton(
                    onPressed: _saving ? null : _saveActiveDivision,
                    child: _saving
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator.adaptive(strokeWidth: 2),
                          )
                        : const Text('Save'),
                  ),
                ],
                bottom: TabBar(
                  controller: _tabController,
                  onTap: (_) => setState(() {}),
                  tabs: [
                    Tab(text: 'Men (${_men.length})'),
                    Tab(text: 'Ladies (${_ladies.length})'),
                    Tab(text: 'Masters (${_masters.length})'),
                  ],
                ),
              ),
              body: TabBarView(
                controller: _tabController,
                children: [
                  _EditableLadderList(
                    items: _men,
                    onChanged: (v) => setState(() => _men = v),
                    onRemove: _removeMemberFromActiveDivision,
                  ),
                  _EditableLadderList(
                    items: _ladies,
                    onChanged: (v) => setState(() => _ladies = v),
                    onRemove: _removeMemberFromActiveDivision,
                  ),
                  _EditableLadderList(
                    items: _masters,
                    onChanged: (v) => setState(() => _masters = v),
                    onRemove: _removeMemberFromActiveDivision,
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  List<LadderItemDTO> _sorted(List<LadderItemDTO>? input) {
    final v = List<LadderItemDTO>.from(input ?? const []);
    v.sort((a, b) => (a.order ?? 0).compareTo(b.order ?? 0));
    return v;
  }

  bool _isLadderEligibleMembership(MembershipTypeEnum? t) {
    if (t == null) return false;
    switch (t) {
      case MembershipTypeEnum.leagueMen:
      case MembershipTypeEnum.leagueStudent:
      case MembershipTypeEnum.leagueScholar:
      case MembershipTypeEnum.ladiesLeague:
      case MembershipTypeEnum.leagueAndMasters:
      case MembershipTypeEnum.mastersOnly:
        return true;
      default:
        return false;
    }
  }
}

class _EditableLadderList extends StatelessWidget {
  const _EditableLadderList({
    required this.items,
    required this.onChanged,
    required this.onRemove,
  });

  final List<LadderItemDTO> items;
  final ValueChanged<List<LadderItemDTO>> onChanged;
  final ValueChanged<LadderItemDTO> onRemove;

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return const Center(child: Text('No ladder entries yet.'));
    }
    return ReorderableListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
      itemCount: items.length,
      onReorder: (oldIndex, newIndex) {
        final mutable = List<LadderItemDTO>.of(items);
        if (newIndex > oldIndex) newIndex -= 1;
        final moved = mutable.removeAt(oldIndex);
        mutable.insert(newIndex, moved);
        final normalized = <LadderItemDTO>[];
        for (var i = 0; i < mutable.length; i++) {
          normalized.add(mutable[i].copyWith(order: i + 1));
        }
        onChanged(normalized);
      },
      itemBuilder: (context, index) {
        final item = items[index];
        final title = item.profile?.displayName.trim();
        final name = (title != null && title.isNotEmpty) ? title : '(No name)';
        return Card(
          key: ValueKey('${item.vobGuid ?? 'unknown'}-$index'),
          margin: const EdgeInsets.symmetric(vertical: 6),
          child: ListTile(
            leading: CircleAvatar(child: Text('${index + 1}')),
            title: Text(name),
            subtitle: Text('Team ${item.team ?? '-'}'),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  tooltip: 'Remove from ladder',
                  icon: const Icon(Icons.person_remove_alt_1_outlined),
                  onPressed: () => onRemove(item),
                ),
                const Icon(Icons.drag_indicator_rounded),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _SelectProfileDialog extends StatefulWidget {
  const _SelectProfileDialog({required this.profiles});

  final List<BasicProfileDTO> profiles;

  @override
  State<_SelectProfileDialog> createState() => _SelectProfileDialogState();
}

class _SelectProfileDialogState extends State<_SelectProfileDialog> {
  final _search = TextEditingController();

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final q = _search.text.trim().toLowerCase();
    final filtered = widget.profiles.where((p) {
      if (q.isEmpty) return true;
      final n = p.displayName.toLowerCase();
      final e = (p.email ?? '').toLowerCase();
      return n.contains(q) || e.contains(q);
    }).toList(growable: false);

    return AlertDialog(
      title: const Text('Add member to ladder'),
      content: SizedBox(
        width: 520,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _search,
              decoration: const InputDecoration(
                hintText: 'Search member',
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: (_) => setState(() {}),
            ),
            const SizedBox(height: 10),
            Flexible(
              child: filtered.isEmpty
                  ? const Center(child: Text('No matching members.'))
                  : ListView.builder(
                      shrinkWrap: true,
                      itemCount: filtered.length,
                      itemBuilder: (context, index) {
                        final p = filtered[index];
                        return ListTile(
                          dense: true,
                          title: Text(p.displayName),
                          subtitle: Text((p.email ?? '').trim()),
                          onTap: () => Navigator.of(context).pop(p),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
      ],
    );
  }
}
