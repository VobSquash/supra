import 'package:jaspr/jaspr.dart';

import '../components/admin_placeholder_panel.dart';

class UsersPage extends StatelessComponent {
  const UsersPage({super.key});

  @override
  Component build(BuildContext context) {
    return const AdminPlaceholderPanel(
      subtitle: 'User administration',
      body: 'User directory, roles, invitations, and access controls will ship in this panel.',
    );
  }
}
