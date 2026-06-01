part of 'email_bloc.dart';

@freezed
class EmailEvent with _$EmailEvent {
  const factory EmailEvent.onUpdateBody(String body) = OnUpdateBody;
  const factory EmailEvent.onUpdateSubject(String subject) = OnUpdateSubject;

  const factory EmailEvent.onSendTestMailer({
    required String testRecipientEmail,
  }) = OnSendTestMailer;

  const factory EmailEvent.onSendGeneralMailer({
  @Default(10) int minimumRecipientCount,
}) = OnSendGeneralMailer;

  const factory EmailEvent.onSendBookingTestMailer({
    required String testRecipientEmail,
    required String displayName,
  }) = OnSendBookingTestMailer;

  const factory EmailEvent.onSendWelcomeEmail({
    required String email,
    String? welcomePdfPath,
  }) = OnSendWelcomeEmail;

  const factory EmailEvent.onSendFeesEmail({
    required String recipientEmail,
    String? feesPdfPath,
  }) = OnSendFeesEmail;

  const factory EmailEvent.onSendChallengeTestMailer({
    required String challengedEmail,
    required String challengedDisplayName,
    required String challengerDisplayName,
    required String challengerEmail,
  }) = OnSendChallengeTestMailer;
}
