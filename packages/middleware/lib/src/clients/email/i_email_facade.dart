import 'package:client_models/client_models.dart';

/// Orchestrates club email sends via [client_email].
abstract class IEmailFacade {
  bool get isEnabled;

  Future<void> sendBookingConfirmation({
    required CreateBookingDto booking,
    required String recipientEmail,
    required String displayName,
  });

  Future<void> sendWelcomeEmail({
    required String recipientEmail,
    String? welcomePdfPath,
  });

  /// Broadcast to active members with email addresses.
  Future<void> sendGeneralToActiveUsers({
    required String body,
    required String subject,
    required List<BasicProfileDTO> activeProfiles,
    int minimumRecipientCount = 10,
  });

  /// Sends a single test message (e.g. to the operator's inbox).
  Future<void> sendGeneralTest({
    required String body,
    required String subject,
    required String testRecipientEmail,
  });

  /// Sends a sample booking confirmation (no DB booking created).
  Future<void> sendBookingTest({
    required String recipientEmail,
    required String displayName,
    CreateBookingDto? sampleBooking,
  });

  /// Notifies a member they have been challenged on the ladder.
  Future<void> sendLadderChallenge({
    required String challengedEmail,
    required String challengedDisplayName,
    required String challengerDisplayName,
    required String challengerEmail,
  });

  /// Sends current fee schedule (pro-rata) to one recipient.
  Future<void> sendFeesToRecipient({
    required String recipientEmail,
    String? feesPdfPath,
  });
}
