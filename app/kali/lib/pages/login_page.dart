import 'package:app_bloc/app_bloc.dart';
import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';
import 'package:middleware/middleware.dart';

/// Email/password sign-in using shared [AuthBloc] + middleware [`AuthService`] (Dupra-aligned).
class LoginPage extends StatefulComponent {
  const LoginPage({super.key});

  @override
  State<StatefulComponent> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String _email = '';
  String _password = '';

  void _submit() {
    middlewareSl<AuthBloc>().add(
      AuthEvent.signInRequested(email: _email.trim(), password: _password.trim()),
    );
  }

  @override
  Component build(BuildContext context) {
    final auth = middlewareSl<AuthBloc>().state;
    final busy = auth.maybeWhen(loading: () => true, orElse: () => false);
    final err = auth.maybeWhen(unauthenticated: (m) => m, orElse: () => null);
    final trimmedErr = err?.trim();
    final showErr = trimmedErr != null && trimmedErr.isNotEmpty && !busy;

    return div(classes: 'auth-shell', [
      div(classes: 'auth-card', [
        h1(classes: 'auth-heading', [Component.text('Sign in')]),
        p(classes: 'auth-lead', [
          Component.text('Kali admin portal — authenticated against the same Supabase project as Dupra.'),
        ]),
        if (showErr) div(classes: 'auth-banner', [Component.text(trimmedErr)]),
        form(
          events: {
            'submit': (event) {
              event.preventDefault();
              if (!busy) _submit();
            },
          },
          [
            div(classes: 'auth-field-block', [
              label([Component.text('Email')]),
              input<String>(
                type: InputType.email,
                attributes: {'name': 'email', 'autocomplete': 'email'},
                value: _email,
                disabled: busy,
                onInput: (value) {
                  setState(() => _email = value);
                },
              ),
            ]),
            div(classes: 'auth-field-block', [
              label([Component.text('Password')]),
              input<String>(
                type: InputType.password,
                attributes: {'name': 'password', 'autocomplete': 'current-password'},
                value: _password,
                disabled: busy,
                onInput: (value) {
                  setState(() => _password = value);
                },
              ),
            ]),
            div(classes: 'auth-submit-row', [
              button(
                disabled: busy,
                type: busy ? ButtonType.button : ButtonType.submit,
                [Component.text(busy ? 'Signing in…' : 'Continue')],
              ),
            ]),
          ],
        ),
      ]),
    ]);
  }
}
