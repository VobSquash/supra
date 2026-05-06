import 'package:app_bloc/app_bloc.dart';
import 'package:dupra/presentation/widgets/dupra_modal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfileStubPage extends StatelessWidget {
  const ProfileStubPage({super.key, this.embedInShell = false});

  /// When true (embedded in the main shell `PageView`), no scaffold/app bar — the
  /// shell provides chrome. When false, full screen for standalone routes.
  final bool embedInShell;

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
    final padding = embedInShell
        ? EdgeInsets.fromLTRB(24, 0, 24, 24 + bottomInset)
        : EdgeInsets.fromLTRB(24, 16, 24, 24 + bottomInset);

    final body = Padding(
      padding: padding,
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
    );

    if (embedInShell) {
      return body;
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: body,
    );
  }
}
