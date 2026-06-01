import 'dart:io';

import 'package:client_email/client_email.dart';
import 'package:client_models/client_models.dart';
import 'package:middleware/src/clients/email/i_fees_pdf_exporter.dart';
import 'package:injectable/injectable.dart';
import 'package:middleware/src/clients/email/i_email_facade.dart';
import 'package:middleware/src/clients/email/i_email_html_preparer.dart';
import 'package:middleware/src/clients/email/i_email_template_provider.dart';
import 'package:middleware/src/clients/settings/i_settings_facade.dart';
import 'package:middleware/src/injection.dart';

@LazySingleton(as: IEmailFacade)
class EmailFacade implements IEmailFacade {
  EmailFacade(this._clientEmail);

  final IClientEmail _clientEmail;

  IEmailHtmlPreparer? get _htmlPreparer {
    if (!middlewareSl.isRegistered<IEmailHtmlPreparer>()) return null;
    return middlewareSl<IEmailHtmlPreparer>();
  }

  Future<String> _prepareTemplate(String html) async {
    final preparer = _htmlPreparer;
    if (preparer == null) return html;
    return preparer.prepareHtml(html);
  }

  IEmailTemplateProvider get _templates {
    if (!middlewareSl.isRegistered<IEmailTemplateProvider>()) {
      throw StateError(
        'IEmailTemplateProvider is not registered. '
        'Register DupraEmailTemplateProvider (or equivalent) during app bootstrap.',
      );
    }
    return middlewareSl<IEmailTemplateProvider>();
  }

  @override
  bool get isEnabled => _clientEmail.isEnabled;

  @override
  Future<void> sendBookingConfirmation({
    required CreateBookingDto booking,
    required String recipientEmail,
    required String displayName,
  }) async {
    if (!isEnabled) return;
    final email = recipientEmail.trim();
    if (email.isEmpty) return;

    final template = await _prepareTemplate(await _templates.loadBookingMailHtml());
    await _clientEmail.sendBookingConfirmation(
      booking: booking,
      recipientEmail: email,
      displayName: displayName,
      bookingTemplateHtml: template,
    );
  }

  @override
  Future<void> sendWelcomeEmail({
    required String recipientEmail,
    String? welcomePdfPath,
  }) async {
    if (!isEnabled) return;
    final email = recipientEmail.trim();
    if (email.isEmpty) return;

    await _clientEmail.sendWelcomeEmail(
      recipientEmail: email,
      welcomePdfPath: welcomePdfPath,
    );
  }

  @override
  Future<void> sendGeneralToActiveUsers({
    required String body,
    required String subject,
    required List<BasicProfileDTO> activeProfiles,
    int minimumRecipientCount = 10,
  }) async {
    if (!isEnabled) return;

    final emails = activeProfiles
        .map((p) => p.email?.trim() ?? '')
        .where((e) => e.isNotEmpty)
        .toList(growable: false);

    if (emails.length < minimumRecipientCount) {
      throw StateError(
        'Refusing to broadcast: only ${emails.length} recipients with email '
        '(minimum $minimumRecipientCount).',
      );
    }

    final template = await _prepareTemplate(await _templates.loadGeneralMailHtml());
    final result = await _clientEmail.sendGeneralMail(
      body: body,
      subject: subject,
      generalTemplateHtml: template,
      recipientEmails: emails,
    );

    if (result.hasFailures) {
      throw StateError(
        'Some messages failed (${result.failedRecipients.length}): '
        '${result.failedRecipients.take(3).join(', ')}',
      );
    }
  }

  @override
  Future<void> sendLadderChallenge({
    required String challengedEmail,
    required String challengedDisplayName,
    required String challengerDisplayName,
    required String challengerEmail,
  }) async {
    if (!isEnabled) return;
    final to = challengedEmail.trim();
    if (to.isEmpty) return;

    final template = await _prepareTemplate(await _templates.loadGeneralMailHtml());
    await _clientEmail.sendLadderChallenge(
      challengedEmail: to,
      challengedDisplayName: challengedDisplayName,
      challengerDisplayName: challengerDisplayName,
      challengerEmail: challengerEmail,
      generalTemplateHtml: template,
    );
  }

  @override
  Future<void> sendFeesToRecipient({
    required String recipientEmail,
    String? feesPdfPath,
  }) async {
    if (!isEnabled) return;
    final to = recipientEmail.trim();
    if (to.isEmpty) return;

    final settings = await middlewareSl<ISettingsFacade>().loadSettings();
    final fees = FeesService.calculateProRata(settings.fees.items);

    var pdfPath = feesPdfPath?.trim();
    if (pdfPath == null || pdfPath.isEmpty) {
      if (middlewareSl.isRegistered<IFeesPdfExporter>()) {
        pdfPath = await middlewareSl<IFeesPdfExporter>().exportFeesToPdf(data: fees);
      }
    }

    final hasPdf = pdfPath != null && pdfPath.isNotEmpty && File(pdfPath).existsSync();
    final body = hasPdf
        ? 'Please see the attached PDF for current membership fee options.'
        : FeesBodyFormatter.format(fees);
    final template = await _prepareTemplate(await _templates.loadGeneralMailHtml());
    await _clientEmail.sendFeesMail(
      recipientEmail: to,
      body: body,
      generalTemplateHtml: template,
      feesPdfPath: hasPdf ? pdfPath : null,
    );
  }

  @override
  Future<void> sendBookingTest({
    required String recipientEmail,
    required String displayName,
    CreateBookingDto? sampleBooking,
  }) async {
    if (!isEnabled) return;
    final email = recipientEmail.trim();
    if (email.isEmpty) return;

    final now = DateTime.now();
    final booking = sampleBooking ??
        CreateBookingDto(
          courtNo: 1,
          bookingDate: DateTime.utc(now.year, now.month, now.day, 18, 0),
          displayName: displayName,
        );

    await sendBookingConfirmation(
      booking: booking,
      recipientEmail: email,
      displayName: displayName,
    );
  }

  @override
  Future<void> sendGeneralTest({
    required String body,
    required String subject,
    required String testRecipientEmail,
  }) async {
    if (!isEnabled) return;
    final email = testRecipientEmail.trim();
    if (email.isEmpty) return;

    final template = await _prepareTemplate(await _templates.loadGeneralMailHtml());
    await _clientEmail.sendGeneralMail(
      body: body,
      subject: subject,
      generalTemplateHtml: template,
      recipientEmails: [email],
    );
  }
}
