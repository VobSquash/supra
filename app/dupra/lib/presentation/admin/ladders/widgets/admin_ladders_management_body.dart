part of '../../admin_ladders_placeholder_page.dart';

class _AdminLaddersManagementBody extends StatefulWidget {
  const _AdminLaddersManagementBody();

  @override
  State<_AdminLaddersManagementBody> createState() => _AdminLaddersManagementBodyState();
}

class _AdminLaddersManagementBodyState extends State<_AdminLaddersManagementBody>
    with SingleTickerProviderStateMixin {
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
    unawaited(_loadProfiles());
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
            messenger
              ..hideCurrentSnackBar()
              ..showSnackBar(const SnackBar(content: Text('Copied to clipboard')));
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
    final existingGuids =
        _itemsFor(d).map((e) => e.vobGuid?.trim()).whereType<String>().where((e) => e.isNotEmpty).toSet();
    final available = _allProfiles
        .where((p) {
          final g = p.vobGuid?.trim();
          return g != null &&
              g.isNotEmpty &&
              !existingGuids.contains(g) &&
              (p.isActive ?? false) &&
              ladderMembershipEligibleForAdmin(p.extendedProfile?.membershipType);
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
      const SnackBar(content: Text('Member added locally. Tap Save to persist.')),
    );
  }

  Future<void> _removeMemberFromActiveDivision(LadderItemDTO item) async {
    final d = _activeDivision;
    final guid = item.vobGuid?.trim();
    if (guid == null || guid.isEmpty) return;
    final name = (item.profile?.displayName.trim().isNotEmpty ?? false)
        ? item.profile!.displayName.trim()
        : 'this member';
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
    final variant = Theme.of(context).colorScheme.onSurfaceVariant;

    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, authState) {
        final canAdmin = authState.maybeWhen(
          authenticated: (s) => ProfileTypeEnum.get(s.profileTypeId ?? -1).isAdminOrElevated,
          orElse: () => false,
        );
        if (!canAdmin) {
          return Padding(
            padding: dupraShellTabPadding(context),
            child: Center(
              child: Text(
                'Only administrators or elevated users can manage ladders.',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: variant),
              ),
            ),
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
              return const Padding(
                padding: EdgeInsets.all(24),
                child: Center(child: CircularProgressIndicator.adaptive()),
              );
            }

            return Padding(
              padding: dupraShellTabPadding(context),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Admin · ladders',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Reorder divisions, add members, then save.',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: variant),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
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
                  ),
                  TabBar(
                    controller: _tabController,
                    onTap: (_) => setState(() {}),
                    tabs: [
                      Tab(text: 'Men (${_men.length})'),
                      Tab(text: 'Ladies (${_ladies.length})'),
                      Tab(text: 'Masters (${_masters.length})'),
                    ],
                  ),
                  Expanded(
                    child: TabBarView(
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
    return List<LadderItemDTO>.from(input ?? const [])
      ..sort((a, b) => (a.order ?? 0).compareTo(b.order ?? 0));
  }
}
