import 'dart:io';

import 'package:client_email/src/email_config.dart';
import 'package:mailer/mailer.dart';

abstract final class WelcomeMailBuilder {
  WelcomeMailBuilder._();

  static Message buildMessage({
    required EmailConfig config,
    required String recipientEmail,
    String? welcomePdfPath,
  }) {
    final message = Message()
      ..from = Address(config.fromEmail, config.fromName)
      ..recipients.add(recipientEmail)
      ..subject = 'Welcome to Vob Squash'
      ..html = '<html><body><p>Welcome to Vob Squash</p></body></html>';

    for (final cc in config.welcomeCcEmails) {
      message.ccRecipients.add(Address(cc));
    }

    final path = welcomePdfPath?.trim();
    if (path != null && path.isNotEmpty) {
      final file = File(path);
      if (file.existsSync()) {
        message.attachments.add(FileAttachment(file));
      }
    }

    return message;
  }
}
