import 'dart:io';

import 'package:app_bloc/app_bloc.dart';
import 'package:dupra/presentation/shell/shell_tab_insets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path_provider/path_provider.dart';

/// Admin shell tab — test booking, general, challenge, fees, welcome, and broadcast emails.
class AdminEmailPage extends StatefulWidget {
  const AdminEmailPage({super.key});

  @override
  State<AdminEmailPage> createState() => _AdminEmailPageState();
}

class _AdminEmailPageState extends State<AdminEmailPage> {
  late final TextEditingController _subjectController;
  late final TextEditingController _bodyController;
  late final TextEditingController _testEmailController;
  late final TextEditingController _displayNameController;
  late final TextEditingController _welcomeEmailController;
  late final TextEditingController _challengedNameController;
  late final TextEditingController _challengerNameController;
  late final TextEditingController _challengerEmailController;

  @override
  void initState() {
    super.initState();
    _subjectController = TextEditingController(text: 'Message from VOB');
    _bodyController = TextEditingController(text: 'This is a test message from the Dupra admin mailer.');
    _testEmailController = TextEditingController();
    _displayNameController = TextEditingController(text: 'Test Member');
    _welcomeEmailController = TextEditingController();
    _challengedNameController = TextEditingController(text: 'Challenged Player');
    _challengerNameController = TextEditingController(text: 'Test Challenger');
    _challengerEmailController = TextEditingController();
  }

  @override
  void dispose() {
    _subjectController.dispose();
    _bodyController.dispose();
    _testEmailController.dispose();
    _displayNameController.dispose();
    _welcomeEmailController.dispose();
    _challengedNameController.dispose();
    _challengerNameController.dispose();
    _challengerEmailController.dispose();
    super.dispose();
  }

  void _syncSubject(EmailBloc bloc) {
    bloc.add(EmailEvent.onUpdateSubject(_subjectController.text));
  }

  void _syncBody(EmailBloc bloc, String value) {
    bloc.add(EmailEvent.onUpdateBody(value.replaceAll('\n', '/n')));
  }

  InputDecoration _decoration(String label) {
    return InputDecoration(
      labelText: label,
      border: const OutlineInputBorder(),
    );
  }

  String? _testEmailOrSnack() {
    final email = _testEmailController.text.trim();
    if (email.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Enter a test recipient email first')),
      );
      return null;
    }
    return email;
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => appBlocSl<EmailBloc>(),
      child: BlocBuilder<EmailBloc, EmailState>(
        builder: (context, state) {
          final bloc = context.read<EmailBloc>();
          final saving = state.status.status == BaseLoadingStatus.saving;
          final variant = Theme.of(context).colorScheme.onSurfaceVariant;

          return CustomScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            slivers: [
              SliverPadding(
                padding: dupraShellTabPadding(context),
                sliver: SliverList.list(
                  children: [
                    Text(
                      'Email testing',
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Send test messages without creating bookings or members. '
                      'Template images use public Supabase URLs (email-images bucket).',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: variant),
                    ),
                    const SizedBox(height: 20),
                    TextField(
                      controller: _testEmailController,
                      decoration: _decoration('Test recipient email'),
                      keyboardType: TextInputType.emailAddress,
                      autofillHints: const [AutofillHints.email],
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _displayNameController,
                      decoration: _decoration('Display name (booking test)'),
                    ),
                    const SizedBox(height: 24),
                    _SectionTitle(title: 'General mailer'),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _subjectController,
                      decoration: _decoration('Subject'),
                      onChanged: (_) => _syncSubject(bloc),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _bodyController,
                      decoration: _decoration('Body'),
                      maxLines: 5,
                      onChanged: (v) => _syncBody(bloc, v),
                    ),
                    const SizedBox(height: 12),
                    FilledButton(
                      onPressed: saving
                          ? null
                          : () {
                              final email = _testEmailOrSnack();
                              if (email == null) return;
                              _syncSubject(bloc);
                              _syncBody(bloc, _bodyController.text);
                              bloc.add(EmailEvent.onSendTestMailer(testRecipientEmail: email));
                            },
                      child: const Text('Send general test email'),
                    ),
                    const SizedBox(height: 8),
                    FilledButton.tonal(
                      onPressed: saving
                          ? null
                          : () {
                              final email = _testEmailOrSnack();
                              if (email == null) return;
                              _syncSubject(bloc);
                              _syncBody(bloc, _bodyController.text);
                              bloc.add(
                                const EmailEvent.onSendGeneralMailer(minimumRecipientCount: 1),
                              );
                            },
                      child: const Text('Send general to all active users'),
                    ),
                    const SizedBox(height: 24),
                    _SectionTitle(title: 'Booking confirmation'),
                    const SizedBox(height: 8),
                    Text(
                      'Uses booking_mail.html with a sample court 1 slot at 18:00 today (UTC).',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(color: variant),
                    ),
                    const SizedBox(height: 12),
                    FilledButton(
                      onPressed: saving
                          ? null
                          : () {
                              final email = _testEmailOrSnack();
                              if (email == null) return;
                              final name = _displayNameController.text.trim();
                              bloc.add(
                                EmailEvent.onSendBookingTestMailer(
                                  testRecipientEmail: email,
                                  displayName: name.isEmpty ? 'Member' : name,
                                ),
                              );
                            },
                      child: const Text('Send booking test email'),
                    ),
                    const SizedBox(height: 24),
                    const _SectionTitle(title: 'Fees schedule'),
                    const SizedBox(height: 8),
                    Text(
                      'Builds a membership fees PDF from current settings and sends it with a short email.',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(color: variant),
                    ),
                    const SizedBox(height: 12),
                    FilledButton.tonal(
                      onPressed: saving
                          ? null
                          : () {
                              final email = _testEmailOrSnack();
                              if (email == null) return;
                              bloc.add(
                                EmailEvent.onSendFeesEmail(recipientEmail: email),
                              );
                            },
                      child: const Text('Send fees to test email'),
                    ),
                    const SizedBox(height: 24),
                    const _SectionTitle(title: 'Ladder challenge'),
                    const SizedBox(height: 8),
                    Text(
                      'Sends the ladder challenge template (general mail) to the test recipient. '
                      'The challenger is CC’d so you can verify both inboxes.',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(color: variant),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _challengedNameController,
                      decoration: _decoration('Challenged display name'),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _challengerNameController,
                      decoration: _decoration('Challenger display name'),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _challengerEmailController,
                      decoration: _decoration('Challenger email (CC)'),
                      keyboardType: TextInputType.emailAddress,
                    ),
                    const SizedBox(height: 12),
                    FilledButton(
                      onPressed: saving
                          ? null
                          : () {
                              final challengedEmail = _testEmailOrSnack();
                              if (challengedEmail == null) return;
                              final challengerEmail = _challengerEmailController.text.trim();
                              if (challengerEmail.isEmpty) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Enter a challenger email for CC'),
                                  ),
                                );
                                return;
                              }
                              final challengedName = _challengedNameController.text.trim();
                              final challengerName = _challengerNameController.text.trim();
                              bloc.add(
                                EmailEvent.onSendChallengeTestMailer(
                                  challengedEmail: challengedEmail,
                                  challengedDisplayName:
                                      challengedName.isEmpty ? 'Member' : challengedName,
                                  challengerDisplayName: challengerName.isEmpty
                                      ? 'A VOB member'
                                      : challengerName,
                                  challengerEmail: challengerEmail,
                                ),
                              );
                            },
                      child: const Text('Send ladder challenge test email'),
                    ),
                    const SizedBox(height: 24),
                    _SectionTitle(title: 'Welcome email'),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _welcomeEmailController,
                      decoration: _decoration('Welcome recipient (defaults to test email above)'),
                      keyboardType: TextInputType.emailAddress,
                    ),
                    const SizedBox(height: 12),
                    FilledButton(
                      onPressed: saving
                          ? null
                          : () async {
                              final email = _welcomeEmailController.text.trim().isNotEmpty
                                  ? _welcomeEmailController.text.trim()
                                  : _testEmailController.text.trim();
                              if (email.isEmpty) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Enter a welcome recipient email')),
                                );
                                return;
                              }
                              final pdfPath = await _resolveWelcomePdfPath();
                              bloc.add(
                                EmailEvent.onSendWelcomeEmail(
                                  email: email,
                                  welcomePdfPath: pdfPath,
                                ),
                              );
                            },
                      child: const Text('Send welcome email'),
                    ),
                    const SizedBox(height: 24),
                    _StatusBanner(state: state),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Future<String?> _resolveWelcomePdfPath() async {
    const assetPath = 'assets/pdfs/VOB_Welcome.pdf';
    try {
      final data = await rootBundle.load(assetPath);
      final dir = await getTemporaryDirectory();
      final file = File('${dir.path}/VOB_Welcome.pdf');
      await file.writeAsBytes(data.buffer.asUint8List());
      return file.path;
    } catch (_) {
      return null;
    }
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
    );
  }
}

class _StatusBanner extends StatelessWidget {
  const _StatusBanner({required this.state});

  final EmailState state;

  @override
  Widget build(BuildContext context) {
    final status = state.status.status;
    final message = state.status.message?.trim() ?? '';

    if (status == BaseLoadingStatus.initial) {
      return const SizedBox.shrink();
    }

    Color? bg;
    String text;
    switch (status) {
      case BaseLoadingStatus.saving:
        bg = Theme.of(context).colorScheme.surfaceContainerHighest;
        text = message.isNotEmpty ? message : 'Sending…';
      case BaseLoadingStatus.saveSuccess:
        bg = Theme.of(context).colorScheme.primaryContainer;
        text = 'Email sent successfully';
      case BaseLoadingStatus.saveFailed:
        bg = Theme.of(context).colorScheme.errorContainer;
        text = message.isNotEmpty ? message : 'Send failed';
      case BaseLoadingStatus.initial:
      case BaseLoadingStatus.loading:
      case BaseLoadingStatus.loadingSuccess:
      case BaseLoadingStatus.loadingFailed:
        return const SizedBox.shrink();
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(text),
    );
  }
}
