import 'package:jaspr/jaspr.dart';

import '../components/admin_placeholder_panel.dart';

class FixturesPage extends StatelessComponent {
  const FixturesPage({super.key});

  @override
  Component build(BuildContext context) {
    return const AdminPlaceholderPanel(
      subtitle: 'Competition fixtures',
      body: 'Fixture rounds, schedules, venues, and result entry will wire up later.',
    );
  }
}
