import 'package:client_models/client_models.dart';
import 'package:client_email/src/email_send_result.dart';

/// Low-level mail transport; implementations may no-op when SMTP is not configured.
abstract class IClientEmail {
  bool get isEnabled;

  Future<EmailSendResult> sendBookingConfirmation({
    required CreateBookingDto booking,
    required String recipientEmail,
    required String displayName,
    required String bookingTemplateHtml,
  });

  Future<EmailSendResult> sendWelcomeEmail({
    required String recipientEmail,
    String? welcomePdfPath,
  });

  Future<EmailSendResult> sendGeneralMail({
    required String body,
    required String subject,
    required String generalTemplateHtml,
    required List<String> recipientEmails,
  });

  Future<EmailSendResult> sendLadderChallenge({
    required String challengedEmail,
    required String challengedDisplayName,
    required String challengerDisplayName,
    required String challengerEmail,
    required String generalTemplateHtml,
  });

  Future<EmailSendResult> sendFeesMail({
    required String recipientEmail,
    required String body,
    required String generalTemplateHtml,
    String? feesPdfPath,
  });
}
