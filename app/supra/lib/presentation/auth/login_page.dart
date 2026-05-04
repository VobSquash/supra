import 'package:app_bloc/app_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart' hide AuthState;
import 'package:supra/gen/assets.gen.dart';

/// Email/password sign-in; [AuthBloc] handles base64 encoding for [AuthService.signIn].
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

  AssetGenImage _logoAsset(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    return dark ? Assets.images.homeDarkMode : Assets.images.homeLightMode;
  }

  Future<void> _showForgotPasswordDialog() async {
    await showDialog<void>(
      context: context,
      builder: (_) => _ForgotPasswordOtpDialog(initialEmail: _email.text.trim()),
    );
  }

  @override
  Widget build(BuildContext context) {
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
              padding: const EdgeInsets.all(24),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 24),
                    Semantics(
                      label: 'Supra',
                      child: Center(
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(maxHeight: 72, maxWidth: 260),
                          child: _logoAsset(context).image(fit: BoxFit.contain, alignment: Alignment.center),
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),
                    Text('Sign in', style: Theme.of(context).textTheme.headlineMedium),
                    const SizedBox(height: 24),
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
                    const SizedBox(height: 8),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: loading ? null : _showForgotPasswordDialog,
                        child: const Text('Forgot password?'),
                      ),
                    ),
                    const SizedBox(height: 16),
                    FilledButton(
                      onPressed: loading ? null : _submit,
                      child: loading
                          ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2))
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

/// Password reset via **email OTP** + new password — no redirect URL or localhost server.
///
/// Requires the Supabase **Reset password** email template to include the numeric code,
/// e.g. `{{ .Token }}` (see Supabase Auth → Email templates).
class _ForgotPasswordOtpDialog extends StatefulWidget {
  const _ForgotPasswordOtpDialog({required this.initialEmail});

  final String initialEmail;

  @override
  State<_ForgotPasswordOtpDialog> createState() => _ForgotPasswordOtpDialogState();
}

class _ForgotPasswordOtpDialogState extends State<_ForgotPasswordOtpDialog> {
  late final TextEditingController _email = TextEditingController(text: widget.initialEmail);
  final _otp = TextEditingController();
  final _password = TextEditingController();
  final _confirm = TextEditingController();

  bool _awaitingCode = true;
  bool _busy = false;

  @override
  void dispose() {
    _email.dispose();
    _otp.dispose();
    _password.dispose();
    _confirm.dispose();
    super.dispose();
  }

  Future<void> _sendCode() async {
    final trimmed = _email.text.trim();
    final messenger = ScaffoldMessenger.of(context);
    if (trimmed.isEmpty) {
      messenger.showSnackBar(const SnackBar(content: Text('Enter your email address.')));
      return;
    }
    setState(() => _busy = true);
    try {
      await Supabase.instance.client.auth.resetPasswordForEmail(trimmed);
      if (!mounted) return;
      setState(() {
        _busy = false;
        _awaitingCode = false;
      });
      messenger.showSnackBar(const SnackBar(content: Text('If that account exists, an email with a code was sent.')));
    } on AuthException catch (e) {
      if (!mounted) return;
      setState(() => _busy = false);
      final m = e.message.trim();
      final rateLimited = _isAuthEmailRateLimited(e);
      messenger.showSnackBar(
        SnackBar(
          content: Text(rateLimited ? _authEmailRateLimitUserMessage() : (m.isEmpty ? 'Could not send code.' : m)),
          backgroundColor: Theme.of(context).colorScheme.errorContainer,
        ),
      );
    } catch (e) {
      if (!mounted) return;
      setState(() => _busy = false);
      messenger.showSnackBar(
        SnackBar(content: Text(e.toString()), backgroundColor: Theme.of(context).colorScheme.errorContainer),
      );
    }
  }

  Future<void> _completeReset() async {
    final trimmedEmail = _email.text.trim();
    final code = _otp.text.trim();
    final pw = _password.text;
    final messenger = ScaffoldMessenger.of(context);

    if (code.isEmpty) {
      messenger.showSnackBar(const SnackBar(content: Text('Enter the code from your email.')));
      return;
    }
    if (pw.length < 6) {
      messenger.showSnackBar(const SnackBar(content: Text('Password must be at least 6 characters.')));
      return;
    }
    if (pw != _confirm.text) {
      messenger.showSnackBar(const SnackBar(content: Text('Passwords do not match.')));
      return;
    }

    setState(() => _busy = true);
    try {
      await Supabase.instance.client.auth.verifyOTP(email: trimmedEmail, token: code, type: OtpType.recovery);
      await Supabase.instance.client.auth.updateUser(UserAttributes(password: pw));
      if (!mounted) return;
      final authBloc = context.read<AuthBloc>();
      final scaffoldMessenger = ScaffoldMessenger.maybeOf(context);
      // Pop first, then sync [AuthBloc] on a later frame so the login [TextField]s are not disposed
      // while the IME is still tearing down (avoids "controller used after disposed").
      FocusManager.instance.primaryFocus?.unfocus();
      Navigator.of(context).pop();
      WidgetsBinding.instance.addPostFrameCallback((_) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          authBloc.add(const AuthEvent.checkRequested());
          scaffoldMessenger?.showSnackBar(const SnackBar(content: Text('Password updated. You are signed in.')));
        });
      });
    } on AuthException catch (e) {
      if (!mounted) return;
      setState(() => _busy = false);
      final m = e.message.trim();
      messenger.showSnackBar(
        SnackBar(
          content: Text(m.isEmpty ? 'Invalid code or reset expired.' : m),
          backgroundColor: Theme.of(context).colorScheme.errorContainer,
        ),
      );
    } catch (e) {
      if (!mounted) return;
      setState(() => _busy = false);
      messenger.showSnackBar(
        SnackBar(content: Text(e.toString()), backgroundColor: Theme.of(context).colorScheme.errorContainer),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(_awaitingCode ? 'Reset password' : 'Enter code'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (_awaitingCode) ...[
              TextField(
                controller: _email,
                decoration: const InputDecoration(labelText: 'Email'),
                keyboardType: TextInputType.emailAddress,
                autofillHints: const [AutofillHints.email],
              ),
            ] else ...[
              Text(
                'Enter the code from your email and choose a new password.',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _otp,
                decoration: const InputDecoration(labelText: 'Code'),
                keyboardType: TextInputType.number,
                autofillHints: const [AutofillHints.oneTimeCode],
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _password,
                obscureText: true,
                decoration: const InputDecoration(labelText: 'New password'),
                autofillHints: const [AutofillHints.newPassword],
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _confirm,
                obscureText: true,
                decoration: const InputDecoration(labelText: 'Confirm new password'),
                autofillHints: const [AutofillHints.newPassword],
              ),
              const SizedBox(height: 4),
            ],
          ],
        ),
      ),
      actions: [
        TextButton(onPressed: _busy ? null : () => Navigator.of(context).pop(), child: const Text('Cancel')),
        if (_awaitingCode)
          FilledButton(
            onPressed: _busy ? null : _sendCode,
            child: _busy
                ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2))
                : const Text('Send code'),
          )
        else ...[
          TextButton(onPressed: _busy ? null : _sendCode, child: const Text('Resend code')),
          FilledButton(
            onPressed: _busy ? null : _completeReset,
            child: _busy
                ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2))
                : const Text('Set password'),
          ),
        ],
      ],
    );
  }
}

bool _isAuthEmailRateLimited(AuthException e) {
  final code = e.statusCode ?? '';
  if (code == '429') return true;
  final m = e.message.toLowerCase();
  return m.contains('rate limit') || m.contains('too many requests');
}

String _authEmailRateLimitUserMessage() =>
    'Too many reset emails were sent (rate limit). Wait a few minutes before '
    'trying again';
