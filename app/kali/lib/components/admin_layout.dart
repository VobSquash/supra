import 'package:app_bloc/app_bloc.dart';
import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';
import 'package:jaspr_router/jaspr_router.dart';
import 'package:middleware/middleware.dart';

import '../navigation/nav_items.dart';

/// Desktop shell: left navigation, top app bar (title + signed-in user), main content (`child`).
class AdminLayout extends StatelessComponent {
  const AdminLayout({
    required this.child,
    super.key,
  });

  final Component child;

  String _welcomeLine(AuthState auth) {
    return auth.maybeWhen(
      authenticated: (snap) {
        final name = snap.displayName?.trim();
        if (name != null && name.isNotEmpty) return name;
        final mail = snap.email?.trim();
        if (mail != null && mail.isNotEmpty) return mail;
        return 'Signed in';
      },
      orElse: () => '',
    );
  }

  @override
  Component build(BuildContext context) {
    final state = RouteState.of(context);
    final appBarTitle = labelForRoutePath(state.location);
    final auth = middlewareSl<AuthBloc>().state;
    final signedInWelcome = _welcomeLine(auth);

    return div(classes: 'admin-root', [
      aside(classes: 'admin-sidebar', [
        div(classes: 'admin-sidebar-brand', [Component.text('Kali')]),
        nav(classes: 'admin-sidebar-nav', [
          for (final item in kaliNavItemsVisibleFor(auth))
            Link(
              to: item.path,
              classes:
                  'admin-sidebar-link${routePathIsActive(location: state.location, navPath: item.path) ? ' is-active' : ''}',
              child: Component.text(item.label),
            ),
        ]),
      ]),
      div(classes: 'admin-main-column', [
        header(classes: 'admin-app-bar', [
          div(classes: 'admin-app-bar-inner', [
            div(classes: 'admin-app-bar-titles', [
              span(classes: 'admin-app-bar-eyebrow', [Component.text('Admin portal')]),
              h1(classes: 'admin-app-bar-title', [Component.text(appBarTitle)]),
            ]),
            div(classes: 'admin-app-bar-actions', [
              if (signedInWelcome.isNotEmpty) span(classes: 'admin-app-bar-welcome', [Component.text(signedInWelcome)]),
              button(
                classes: 'admin-sign-out',
                events: {
                  'click': (_) => middlewareSl<AuthBloc>().add(const AuthEvent.signOutRequested()),
                },
                [
                  Component.text('Sign out'),
                ],
              ),
            ]),
          ]),
        ]),
        main_(classes: 'admin-content', [child]),
      ]),
    ]);
  }
}
