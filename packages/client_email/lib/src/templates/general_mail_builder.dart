import 'package:client_email/src/email_config.dart';
import 'package:mailer/mailer.dart';

import 'template_renderer.dart';

abstract final class GeneralMailBuilder {
  GeneralMailBuilder._();

  static Message buildMessage({
    required EmailConfig config,
    required String recipientEmail,
    required String subject,
    required String body,
    required String generalTemplateHtml,
    String title = 'Message from VOB to you',
  }) {
    final html = TemplateRenderer.formatGeneralMail(
      template: generalTemplateHtml,
      title: title,
      body: body,
    );

    return Message()
      ..from = Address(config.fromEmail, config.fromName)
      ..recipients.add(recipientEmail)
      ..subject = subject
      ..html = html;
  }
}
