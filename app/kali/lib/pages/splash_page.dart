import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';

class SplashPage extends StatelessComponent {
  const SplashPage({super.key});

  @override
  Component build(BuildContext context) {
    return div(classes: 'auth-shell', [
      div(classes: 'auth-card splash-card', [
        p(classes: 'splash-copy', [
          Component.text('Checking session…'),
        ]),
      ]),
    ]);
  }
}
