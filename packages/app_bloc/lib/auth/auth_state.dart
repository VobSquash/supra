part of 'auth_bloc.dart';

@freezed
class AuthState with _$AuthState {
  const factory AuthState.initial() = AuthInitial;

  const factory AuthState.loading() = AuthLoading;

  const factory AuthState.unauthenticated({String? message}) = AuthUnauthenticated;

  const factory AuthState.authenticated(SessionSnapshot snapshot) = AuthAuthenticated;
}
