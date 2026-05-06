import 'package:app_bloc/app_bloc.dart';
import 'package:dupra/presentation/widgets/dupra_modal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfileStubPage extends StatelessWidget {
  const ProfileStubPage({super.key});

  Future<void> _offerLogout(BuildContext context) {
    return DupraModal.confirm(
      title: 'Log out?',
      message: 'You will need to sign in again to continue.',
      confirmLabel: 'Log out',
      onConfirm: () {
        context.read<AuthBloc>().add(const AuthEvent.signOutRequested());
      },
    ).show(context);
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.paddingOf(context).bottom;

    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: Padding(
        padding: EdgeInsets.fromLTRB(24, 16, 24, 24 + bottomInset),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Align(
                alignment: Alignment.topCenter,
                child: Text(
                  'Profile shell — scrolling header in production.',
                  style: Theme.of(
                    context,
                  ).textTheme.bodyLarge?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant),
                ),
              ),
            ),
            OutlinedButton.icon(
              onPressed: () => _offerLogout(context),
              icon: const Icon(Icons.logout_rounded),
              label: const Text('Log out'),
            ),
          ],
        ),
      ),
    );
  }
}
