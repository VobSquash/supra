import 'package:jaspr/jaspr.dart';

import '../components/admin_placeholder_panel.dart';

class LadderPage extends StatelessComponent {
  const LadderPage({super.key});

  @override
  Component build(BuildContext context) {
    return const AdminPlaceholderPanel(
      subtitle: 'Standings',
      body: 'Ladders, ranking rules, ties, and season snapshots will consolidate here.',
    );
  }
}
