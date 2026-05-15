import 'dart:async';

import 'package:app_bloc/app_bloc.dart';
import 'package:client_models/client_models.dart';
import 'package:dupra/presentation/admin/ladders/data/ladder_membership_eligibility.dart';
import 'package:dupra/presentation/shell/shell_tab_insets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:middleware/middleware.dart';

part 'ladders/widgets/admin_ladders_management_body.dart';
part 'ladders/widgets/admin_ladders_editable_list.dart';
part 'ladders/widgets/admin_ladders_select_profile_dialog.dart';

/// Admin shell — ladder divisions: reorder, add members, save.
class AdminLaddersPlaceholderPage extends StatelessWidget {
  const AdminLaddersPlaceholderPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => appBlocSl<LaddersBloc>()..add(const LaddersEvent.onLoadLadders()),
      child: const _AdminLaddersManagementBody(),
    );
  }
}
