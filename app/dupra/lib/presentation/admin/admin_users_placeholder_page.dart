import 'dart:async';

import 'package:app_bloc/app_bloc.dart';
import 'package:client_models/client_models.dart';
import 'package:dupra/presentation/admin/admin_member_profile_edit_page.dart';
import 'package:dupra/presentation/admin/data/admin_profiles_filters.dart';
import 'package:dupra/presentation/shell/shell_tab_insets.dart';
import 'package:dupra/presentation/users/data/users_directory_lead_letter.dart';
import 'package:dupra/presentation/users/data/users_directory_metrics.dart';
import 'package:dupra/presentation/users/users_directory_loaded_panel.dart';
import 'package:dupra/presentation/users/users_directory_search_bar.dart';
import 'package:dupra/presentation/users/users_directory_tile.dart';
import 'package:dupra/presentation/users/users_profiles_load_error.dart';
import 'package:dupra/presentation/users/users_stale_refresh_banner.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'users/widgets/admin_users_management_body.dart';
part 'users/widgets/admin_users_roster_pane.dart';

/// Admin shell — full roster split into Active and Inactive tabs with shared name search.
class AdminUsersPlaceholderPage extends StatelessWidget {
  const AdminUsersPlaceholderPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const _AdminUsersManagementBody();
  }
}
