import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';

/// Simple desktop placeholder panel for unfinished sections.
class AdminPlaceholderPanel extends StatelessComponent {
  const AdminPlaceholderPanel({
    required this.body,
    this.subtitle,
    super.key,
  });

  /// Short description under the subtitle.
  final String body;

  /// Optional muted line below the routed page title.
  final String? subtitle;

  @override
  Component build(BuildContext context) {
    return div(classes: 'admin-placeholder', [
      if (subtitle != null) p(classes: 'admin-placeholder-subtitle', [Component.text(subtitle!)]),
      p(classes: 'admin-placeholder-body', [Component.text(body)]),
    ]);
  }
}
