import 'dart:io';

import 'package:client_email/src/email_config.dart';
import 'package:client_models/client_models.dart';
import 'package:mailer/mailer.dart';

import 'general_mail_builder.dart';

abstract final class FeesMailBuilder {
  FeesMailBuilder._();

  static Message buildMessage({
    required EmailConfig config,
    required String recipientEmail,
    required String body,
    required String generalTemplateHtml,
    String? feesPdfPath,
    DateTime? asOf,
  }) {
    final sentAt = asOf ?? DateTime.now();
    final year = sentAt.year;
    final path = feesPdfPath?.trim();
    final hasPdf =
        path != null && path.isNotEmpty && File(path).existsSync();
    final subject = hasPdf
        ? 'Vob Fees $year ${sentAt.toDMMMMY()}'
        : 'Vob Fees $year';

    final message = GeneralMailBuilder.buildMessage(
      config: config,
      recipientEmail: recipientEmail,
      subject: subject,
      body: body,
      generalTemplateHtml: generalTemplateHtml,
      title: 'Membership fees',
    );

    if (hasPdf) {
      message.attachments.add(FileAttachment(File(path)));
    }

    return message;
  }
}
