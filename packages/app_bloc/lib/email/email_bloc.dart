import 'package:app_bloc/base/base_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:middleware/middleware_clients.dart';

part 'email_bloc.freezed.dart';
part 'email_events.dart';
part 'email_state.dart';

@injectable
class EmailBloc extends BaseBloc<EmailEvent, EmailState> {
  EmailBloc(this._emailFacade, this._usersFacade)
      : super(initialState1: EmailState.initial()) {
    on<EmailEvent>((event, emit) async {
      await event.map(
        onUpdateBody: (e) {
          emit(state.copyWith(body: e.body));
        },
        onUpdateSubject: (e) {
          emit(state.copyWith(subject: e.subject));
        },
        onSendTestMailer: (e) async {
          await handleLoadingState<void>(
            emit,
            initialState: state,
            onLoading: () => state.copyWith(
              status: BaseLoading.saving('Sending test email…'),
            ),
            action: () async {
              if (!_emailFacade.isEnabled) {
                throw StateError(
                  'Email is not configured. Add SMTP settings to app_config.json.',
                );
              }
              await _emailFacade.sendGeneralTest(
                body: state.body,
                subject: state.subject,
                testRecipientEmail: e.testRecipientEmail,
              );
            },
            onSuccess: (_) => state.copyWith(status: BaseLoading.successSaving()),
            onError: (error) => state.copyWith(
              status: BaseLoading.error(
                error ?? 'Unknown error while sending test email',
              ),
            ),
          );
        },
        onSendGeneralMailer: (e) async {
          await handleLoadingState<void>(
            emit,
            initialState: state,
            onLoadingAsync: () async {
              final users = await _usersFacade.loadActiveBasicProfiles();
              return state.copyWith(
                status: BaseLoading.saving(
                  'Sending to ${users.length} active members…',
                ),
              );
            },
            onLoading: () => state.copyWith(
              status: BaseLoading.saving('Sending email…'),
            ),
            action: () async {
              if (!_emailFacade.isEnabled) {
                throw StateError(
                  'Email is not configured. Add SMTP settings to app_config.json.',
                );
              }
              final users = await _usersFacade.loadActiveBasicProfiles();
              await _emailFacade.sendGeneralToActiveUsers(
                body: state.body,
                subject: state.subject,
                activeProfiles: users,
                minimumRecipientCount: e.minimumRecipientCount,
              );
            },
            onSuccess: (_) => state.copyWith(status: BaseLoading.successSaving()),
            onError: (error) => state.copyWith(
              status: BaseLoading.error(
                error ?? 'Unknown error while sending email',
              ),
            ),
          );
        },
        onSendBookingTestMailer: (e) async {
          await handleLoadingState<void>(
            emit,
            initialState: state,
            onLoading: () => state.copyWith(
              status: BaseLoading.saving('Sending booking test email…'),
            ),
            action: () async {
              if (!_emailFacade.isEnabled) {
                throw StateError(
                  'Email is not configured. Add SMTP settings to app_config.json.',
                );
              }
              await _emailFacade.sendBookingTest(
                recipientEmail: e.testRecipientEmail,
                displayName: e.displayName,
              );
            },
            onSuccess: (_) => state.copyWith(status: BaseLoading.successSaving()),
            onError: (error) => state.copyWith(
              status: BaseLoading.error(
                error ?? 'Unknown error while sending booking test email',
              ),
            ),
          );
        },
        onSendFeesEmail: (e) async {
          await handleLoadingState<void>(
            emit,
            initialState: state,
            onLoading: () => state.copyWith(
              status: BaseLoading.saving('Sending fees email…'),
            ),
            action: () async {
              if (!_emailFacade.isEnabled) {
                throw StateError(
                  'Email is not configured. Add SMTP settings to app_config.json.',
                );
              }
              await _emailFacade.sendFeesToRecipient(
                recipientEmail: e.recipientEmail,
                feesPdfPath: e.feesPdfPath,
              );
            },
            onSuccess: (_) => state.copyWith(status: BaseLoading.successSaving()),
            onError: (error) => state.copyWith(
              status: BaseLoading.error(
                error ?? 'Unknown error while sending fees email',
              ),
            ),
          );
        },
        onSendWelcomeEmail: (e) async {
          await handleLoadingState<void>(
            emit,
            initialState: state,
            onLoading: () => state.copyWith(
              status: BaseLoading.saving('Sending welcome email…'),
            ),
            action: () async {
              if (!_emailFacade.isEnabled) {
                throw StateError(
                  'Email is not configured. Add SMTP settings to app_config.json.',
                );
              }
              await _emailFacade.sendWelcomeEmail(
                recipientEmail: e.email,
                welcomePdfPath: e.welcomePdfPath,
              );
            },
            onSuccess: (_) => state.copyWith(status: BaseLoading.successSaving()),
            onError: (error) => state.copyWith(
              status: BaseLoading.error(
                error ?? 'Unknown error while sending welcome email',
              ),
            ),
          );
        },
        onSendChallengeTestMailer: (e) async {
          await handleLoadingState<void>(
            emit,
            initialState: state,
            onLoading: () => state.copyWith(
              status: BaseLoading.saving('Sending ladder challenge test email…'),
            ),
            action: () async {
              if (!_emailFacade.isEnabled) {
                throw StateError(
                  'Email is not configured. Add SMTP settings to app_config.json.',
                );
              }
              await _emailFacade.sendLadderChallenge(
                challengedEmail: e.challengedEmail,
                challengedDisplayName: e.challengedDisplayName,
                challengerDisplayName: e.challengerDisplayName,
                challengerEmail: e.challengerEmail,
              );
            },
            onSuccess: (_) => state.copyWith(status: BaseLoading.successSaving()),
            onError: (error) => state.copyWith(
              status: BaseLoading.error(
                error ?? 'Unknown error while sending challenge test email',
              ),
            ),
          );
        },
      );
    });
  }

  final IEmailFacade _emailFacade;
  final IUsersFacade _usersFacade;
}
