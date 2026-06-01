import 'package:app_bloc/app_bloc.dart';
import 'package:client_models/client_models.dart';
import 'package:dupra/presentation/shell/shell_tab_insets.dart';
import 'package:dupra/presentation/widgets/dupra_avatar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'widgets/ladders_colors.dart';
part 'widgets/ladders_team_support.dart';
part 'widgets/ladders_player_row.dart';
part 'widgets/ladders_team_block.dart';
part 'widgets/ladders_tab_body.dart';
part 'widgets/ladders_view.dart';

/// Confirms and sends a ladder challenge email via [LaddersBloc].
Future<void> confirmLadderChallenge(BuildContext context, LadderItemDTO challenged) async {
  final name = challenged.profile?.displayName.trim();
  final label = (name != null && name.isNotEmpty) ? name : 'this player';

  final send = await showDialog<bool>(
    context: context,
    builder: (ctx) => AlertDialog(
      title: const Text('Send ladder challenge?'),
      content: Text(
        'Email $label to arrange a match within 7 days. You will be copied on the message.',
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')),
        FilledButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Send challenge')),
      ],
    ),
  );
  if (send != true || !context.mounted) return;

  final messenger = ScaffoldMessenger.of(context);
  try {
    await context.read<LaddersBloc>().requestChallenge(challenged: challenged);
    if (!context.mounted) return;
    messenger.showSnackBar(SnackBar(content: Text('Challenge email sent to $label.')));
  } catch (e) {
    if (!context.mounted) return;
    messenger.showSnackBar(SnackBar(content: Text(e.toString())));
  }
}

/// Member ladders tab — loads ladder divisions locally via `LaddersBloc`.
class LaddersPage extends StatelessWidget {
  const LaddersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => appBlocSl<LaddersBloc>()..add(const LaddersEvent.onLoadLadders()),
      child: const _LaddersView(),
    );
  }
}
