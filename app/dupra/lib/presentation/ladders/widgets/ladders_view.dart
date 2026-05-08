part of '../ladders_page.dart';

class _LaddersView extends StatefulWidget {
  const _LaddersView();

  @override
  State<_LaddersView> createState() => _LaddersViewState();
}

class _LaddersViewState extends State<_LaddersView> with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
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

        if (status == BaseLoadingStatus.initial || status == BaseLoadingStatus.loading) {
          return Padding(
            padding: dupraShellTabPadding(context),
            child: const Center(child: CircularProgressIndicator.adaptive()),
          );
        }

        if (status == BaseLoadingStatus.loadingFailed) {
          final trimmed = state.status.message?.trim();
          final errorText = (trimmed != null && trimmed.isNotEmpty) ? trimmed : 'Failed to load ladders';
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

        final l = state.ladders;
        final menCount = l.men?.length ?? 0;
        final ladiesCount = l.ladies?.length ?? 0;
        final mastersCount = l.masters?.length ?? 0;

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TabBar(
                controller: _tabController,
                tabs: [
                  Tab(text: 'Men${menCount > 0 ? ' ($menCount)' : ''}'),
                  Tab(text: 'Ladies${ladiesCount > 0 ? ' ($ladiesCount)' : ''}'),
                  Tab(text: 'Masters${mastersCount > 0 ? ' ($mastersCount)' : ''}'),
                ],
              ),
              Expanded(
                child: TabBarView(
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
              ),
              SizedBox(height: MediaQuery.paddingOf(context).bottom),
            ],
          ),
        );
      },
    );
  }
}
