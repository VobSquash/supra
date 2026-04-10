import 'package:app_bloc/app_bloc.dart';
import 'package:client_models/client_models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../shared/widgets/row_item.dart';

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
      appBar: AppBar(title: const Text('Ladders')),
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
                  message?.isNotEmpty == true
                      ? message!
                      : 'Failed to load ladders',
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }

          final l = state.ladders;
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              RowItem(
                label: 'showLadderBreakdown',
                value: l.showLadderBreakdown.toString(),
              ),
              const SizedBox(height: 16),
              Text(
                'Men (${l.men?.length ?? 0})',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              ..._ladderItems(l.men),
              const SizedBox(height: 16),
              Text(
                'Ladies (${l.ladies?.length ?? 0})',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              ..._ladderItems(l.ladies),
              const SizedBox(height: 16),
              Text(
                'Masters (${l.masters?.length ?? 0})',
                style: Theme.of(context).textTheme.titleMedium,
              ),
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
