import 'package:app_bloc/app_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../shared/widgets/row_item.dart';

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
      appBar: AppBar(title: const Text('Settings')),
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
                  message?.isNotEmpty == true
                      ? message!
                      : 'Failed to load settings',
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
              RowItem(label: 'objectId', value: s.systemSettings.objectId),
              RowItem(
                label: 'showLadderBreakdown',
                value: s.systemSettings.showLadderBreakdown.toString(),
              ),
              const SizedBox(height: 16),
              Text(
                'Fees (${s.fees.items.length})',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              ...s.fees.items.map(
                (f) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: RowItem(
                    label: f.feeType,
                    value: '${f.cost} (proRata: ${f.proRataCost})',
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Ladder breakdown',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              RowItem(label: 'objectId', value: s.ladderBreakdown.objectId),
              RowItem(
                label: 'men teams',
                value: '${s.ladderBreakdown.mensteams?.length ?? 0}',
              ),
              RowItem(
                label: 'ladies teams',
                value: '${s.ladderBreakdown.ladiesTeams?.length ?? 0}',
              ),
              RowItem(
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
