part of 'email_bloc.dart';

@freezed
class EmailState with _$EmailState {
  const factory EmailState({
    required String subject,
    required String body,
    required BaseLoading status,
  }) = _EmailState;

  factory EmailState.initial() => EmailState(
        subject: 'Message from VOB',
        body: '',
        status: BaseLoading.initial(),
      );
}
