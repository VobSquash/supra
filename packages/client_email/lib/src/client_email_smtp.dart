import 'package:client_models/client_models.dart';
import 'package:client_email/src/email_config.dart';
import 'package:client_email/src/email_send_result.dart';
import 'package:client_email/src/i_client_email.dart';
import 'package:client_email/src/templates/booking_confirmation_builder.dart';
import 'package:client_email/src/templates/challenge_mail_builder.dart';
import 'package:client_email/src/templates/fees_mail_builder.dart';
import 'package:client_email/src/templates/general_mail_builder.dart';
import 'package:client_email/src/templates/welcome_mail_builder.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';

class SmtpClientEmail implements IClientEmail {
  SmtpClientEmail({required EmailConfig config}) : _config = config;

  final EmailConfig _config;

  @override
  bool get isEnabled => _config.isConfigured;

  SmtpServer get _smtpServer => SmtpServer(
        _config.smtpHost,
        ssl: _config.useSsl,
        username: _config.smtpUsername,
        password: _config.smtpPassword,
      );

  @override
  Future<EmailSendResult> sendBookingConfirmation({
    required CreateBookingDto booking,
    required String recipientEmail,
    required String displayName,
    required String bookingTemplateHtml,
  }) async {
    final message = BookingConfirmationBuilder.buildMessage(
      config: _config,
      booking: booking,
      displayName: displayName,
      recipientEmail: recipientEmail,
      bookingTemplateHtml: bookingTemplateHtml,
    );
    return _sendToRecipients(message, [recipientEmail]);
  }

  @override
  Future<EmailSendResult> sendWelcomeEmail({
    required String recipientEmail,
    String? welcomePdfPath,
  }) async {
    final message = WelcomeMailBuilder.buildMessage(
      config: _config,
      recipientEmail: recipientEmail,
      welcomePdfPath: welcomePdfPath,
    );
    return _sendToRecipients(message, [recipientEmail]);
  }

  @override
  Future<EmailSendResult> sendGeneralMail({
    required String body,
    required String subject,
    required String generalTemplateHtml,
    required List<String> recipientEmails,
  }) async {
    final normalized = recipientEmails
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toList(growable: false);

    var sent = 0;
    final failed = <String>[];

    for (final email in normalized) {
      final message = GeneralMailBuilder.buildMessage(
        config: _config,
        recipientEmail: email,
        subject: subject,
        body: body,
        generalTemplateHtml: generalTemplateHtml,
      );
      try {
        await send(message, _smtpServer);
        sent++;
      } on MailerException catch (_) {
        failed.add(email);
      }
    }

    return EmailSendResult(sentCount: sent, failedRecipients: failed);
  }

  @override
  Future<EmailSendResult> sendLadderChallenge({
    required String challengedEmail,
    required String challengedDisplayName,
    required String challengerDisplayName,
    required String challengerEmail,
    required String generalTemplateHtml,
  }) async {
    final message = ChallengeMailBuilder.buildMessage(
      config: _config,
      recipientEmail: challengedEmail,
      challengedDisplayName: challengedDisplayName,
      challengerDisplayName: challengerDisplayName,
      challengerEmail: challengerEmail,
      generalTemplateHtml: generalTemplateHtml,
    );
    return _sendToRecipients(message, [challengedEmail]);
  }

  @override
  Future<EmailSendResult> sendFeesMail({
    required String recipientEmail,
    required String body,
    required String generalTemplateHtml,
    String? feesPdfPath,
  }) async {
    final message = FeesMailBuilder.buildMessage(
      config: _config,
      recipientEmail: recipientEmail,
      body: body,
      generalTemplateHtml: generalTemplateHtml,
      feesPdfPath: feesPdfPath,
    );
    return _sendToRecipients(message, [recipientEmail]);
  }

  Future<EmailSendResult> _sendToRecipients(
    Message templateMessage,
    List<String> recipientEmails,
  ) async {
    var sent = 0;
    final failed = <String>[];

    for (final email in recipientEmails) {
      final trimmed = email.trim();
      if (trimmed.isEmpty) continue;

      final msg = Message()
        ..from = templateMessage.from
        ..recipients.add(trimmed)
        ..subject = templateMessage.subject
        ..html = templateMessage.html
        ..attachments.addAll(templateMessage.attachments)
        ..ccRecipients.addAll(templateMessage.ccRecipients);

      try {
        await send(msg, _smtpServer);
        sent++;
      } on MailerException catch (_) {
        failed.add(trimmed);
      }
    }

    return EmailSendResult(sentCount: sent, failedRecipients: failed);
  }
}
