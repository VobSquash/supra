import 'package:app_bloc/app_bloc.dart';
import 'package:client_models/client_models.dart';
import 'package:dupra/engine/accessibility/dupra_build_context_accessibility.dart';
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
