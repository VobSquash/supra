import 'package:app_bloc/app_bloc.dart';
import 'package:client_models/client_models.dart';
import 'package:dupra/presentation/admin/data/upcoming_admin_birthdays.dart';
import 'package:dupra/presentation/shell/shell_tab_insets.dart';
import 'package:dupra/presentation/widgets/dupra_upcoming_birthday_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'widgets/birthday.dart';

/// Admin shell — overview plus birthday reminders for the roster.
class AdminHomePlaceholderPage extends StatefulWidget {
  const AdminHomePlaceholderPage({super.key});

  /// Matches “today plus six more calendar days”.
  static const int birthdayHorizonDaysAheadInclusive = 6;

  @override
  State<AdminHomePlaceholderPage> createState() => _AdminHomePlaceholderPageState();
}

class _AdminHomePlaceholderPageState extends State<AdminHomePlaceholderPage> {
  @override
  void initState() {
    super.initState();
    context.read<UsersBloc>().add(const UsersEvent.onLoadActiveProfiles());
  }

  void _reloadProfiles() {
    context.read<UsersBloc>().add(const UsersEvent.onLoadActiveProfiles());
  }

  @override
  Widget build(BuildContext context) {
    final variant = Theme.of(context).colorScheme.onSurfaceVariant;
    final today = DateUtils.dateOnly(DateTime.now());

    return BlocBuilder<UsersBloc, UsersState>(
      buildWhen: (prev, curr) =>
          prev.profiles.length != curr.profiles.length ||
          prev.status.status != curr.status.status ||
          prev.status.message != curr.status.message,
      builder: (context, state) {
        final profiles = [...state.profiles.where((p) => p.isActive ?? true)];
        final loading = state.status.status == BaseLoadingStatus.loading;
        final failed = state.status.status == BaseLoadingStatus.loadingFailed;

        return CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: [
            SliverPadding(
              padding: dupraShellTabPadding(context),
              sliver: SliverList.list(
                children: [
                  Text(
                    'Admin home',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Birthdays in the next week (today through six days ahead)',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: variant),
                  ),
                  const SizedBox(height: 24),
                  _AdminHomeBirthdays(
                    variant: variant,
                    today: today,
                    loading: loading,
                    failed: failed,
                    message: state.status.message,
                    profiles: profiles,
                    onReload: _reloadProfiles,
                  ),
                  const SizedBox(height: 32),
                  Text(
                    'Use the bar below for admin tabs or exit admin mode from the app bar.',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: variant),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
