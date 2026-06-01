import 'package:client_email/src/email_config.dart';
import 'package:mailer/mailer.dart';

import 'template_renderer.dart';

abstract final class ChallengeMailBuilder {
  ChallengeMailBuilder._();

  static Message buildMessage({
    required EmailConfig config,
    required String recipientEmail,
    required String challengedDisplayName,
    required String challengerDisplayName,
    required String challengerEmail,
    required String generalTemplateHtml,
  }) {
    final body = _challengeBody(
      challengedDisplayName: challengedDisplayName,
      challengerDisplayName: challengerDisplayName,
    );
    final html = TemplateRenderer.formatGeneralMail(
      template: generalTemplateHtml,
      title: 'Ladder challenge',
      body: body,
    );

    final message = Message()
      ..from = Address(config.fromEmail, config.fromName)
      ..recipients.add(recipientEmail)
      ..subject = 'Vob Ladder Challenge'
      ..html = html;

    final challenger = challengerEmail.trim();
    if (challenger.isNotEmpty) {
      message.ccRecipients.add(
        Address(challenger, challengerDisplayName),
      );
    }
    for (final cc in config.challengeCcEmails) {
      message.ccRecipients.add(Address(cc));
    }

    return message;
  }

  static String _challengeBody({
    required String challengedDisplayName,
    required String challengerDisplayName,
  }) {
    return [
      'Hi $challengedDisplayName',
      'You have been challenged to a ladder match by $challengerDisplayName.',
      'Please contact your challenger ASAP (copied on this email) to arrange the match within the next 7 days.',
      'The challenge will be considered a walk-over if not played within this time.',
      'Normal challenge rules apply.',
    ].join('\n');
  }
}
