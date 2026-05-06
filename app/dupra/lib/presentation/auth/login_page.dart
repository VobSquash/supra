import 'package:app_bloc/app_bloc.dart';
import 'package:dupra/engine/theme/dupra_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Email/password sign-in using the shared auth bloc and middleware AuthService.
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _email = TextEditingController();
  final _password = TextEditingController();

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    context.read<AuthBloc>().add(AuthEvent.signInRequested(email: _email.text.trim(), password: _password.text));
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      body: SafeArea(
        child: BlocConsumer<AuthBloc, AuthState>(
          listenWhen: (prev, curr) => curr.maybeWhen(unauthenticated: (m) => (m ?? '').isNotEmpty, orElse: () => false),
          listener: (context, state) {
            state.maybeWhen(
              unauthenticated: (message) {
                if (message != null && message.isNotEmpty) {
                  _password.clear();
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
                }
              },
              orElse: () {},
            );
          },
          builder: (context, state) {
            final loading = state.maybeWhen(loading: () => true, orElse: () => false);

            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 48),
                    const Icon(Icons.sports_tennis_rounded, size: 64, color: DupraColors.secondary),
                    const SizedBox(height: 16),
                    GestureDetector(
                      onTap: () => {
                        setState(() {
                          _email.text = 'designstyles1@gmail.com';
                          _password.text = '123123';
                        }),
                      },
                      child: Text(
                        'Dupra',
                        textAlign: TextAlign.center,
                        style: Theme.of(
                          context,
                        ).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w800, color: scheme.onSurface),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Sign in to continue',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: scheme.onSurfaceVariant),
                    ),
                    const SizedBox(height: 36),
                    TextFormField(
                      controller: _email,
                      decoration: const InputDecoration(labelText: 'Email'),
                      keyboardType: TextInputType.emailAddress,
                      autofillHints: const [AutofillHints.email],
                      validator: (v) {
                        if (v == null || v.trim().isEmpty) return 'Enter email';
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _password,
                      obscureText: true,
                      decoration: const InputDecoration(labelText: 'Password'),
                      autofillHints: const [AutofillHints.password],
                      validator: (v) {
                        if (v == null || v.isEmpty) return 'Enter password';
                        return null;
                      },
                    ),
                    const SizedBox(height: 28),
                    FilledButton(
                      onPressed: loading ? null : _submit,
                      child: loading
                          ? SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Theme.of(context).colorScheme.onPrimary,
                              ),
                            )
                          : const Text('Sign in'),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
