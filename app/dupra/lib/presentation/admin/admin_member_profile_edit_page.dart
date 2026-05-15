import 'package:app_bloc/app_bloc.dart';
import 'package:client_models/client_models.dart';
import 'package:dio/dio.dart';
import 'package:dupra/engine/theme/dupra_colors.dart';
import 'package:dupra/presentation/widgets/dupra_avatar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'member_profile/widgets/admin_member_profile_edit_body.dart';
part 'member_profile/widgets/admin_member_profile_set_temp_password_page.dart';

const _adminResetFunctionName = 'admin-reset-password';

/// Admin: edit another member's profile (`UpdateAdminProfileDto`) + password actions.
class AdminMemberProfileEditPage extends StatefulWidget {
  const AdminMemberProfileEditPage({required this.profile, super.key});

  final BasicProfileDTO profile;

  @override
  State<AdminMemberProfileEditPage> createState() => _AdminMemberProfileEditPageState();
}
