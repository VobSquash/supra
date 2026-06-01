import 'package:client_models/client_models.dart';
import 'package:client_email/src/email_send_result.dart';
import 'package:client_email/src/i_client_email.dart';

/// Used when SMTP credentials are not present in app config.
class NoOpClientEmail implements IClientEmail {
  const NoOpClientEmail();

  @override
  bool get isEnabled => false;

  @override
  Future<EmailSendResult> sendBookingConfirmation({
    required CreateBookingDto booking,
    required String recipientEmail,
    required String displayName,
    required String bookingTemplateHtml,
  }) async {
    return const EmailSendResult(sentCount: 0, failedRecipients: []);
  }

  @override
  Future<EmailSendResult> sendWelcomeEmail({
    required String recipientEmail,
    String? welcomePdfPath,
  }) async {
    return const EmailSendResult(sentCount: 0, failedRecipients: []);
  }

  @override
  Future<EmailSendResult> sendGeneralMail({
    required String body,
    required String subject,
    required String generalTemplateHtml,
    required List<String> recipientEmails,
  }) async {
    return const EmailSendResult(sentCount: 0, failedRecipients: []);
  }

  @override
  Future<EmailSendResult> sendLadderChallenge({
    required String challengedEmail,
    required String challengedDisplayName,
    required String challengerDisplayName,
    required String challengerEmail,
    required String generalTemplateHtml,
  }) async {
    return const EmailSendResult(sentCount: 0, failedRecipients: []);
  }

  @override
  Future<EmailSendResult> sendFeesMail({
    required String recipientEmail,
    required String body,
    required String generalTemplateHtml,
    String? feesPdfPath,
  }) async {
    return const EmailSendResult(sentCount: 0, failedRecipients: []);
  }
}
