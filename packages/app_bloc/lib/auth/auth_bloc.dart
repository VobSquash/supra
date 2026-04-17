import 'dart:convert';

import 'package:auth/auth.dart';
import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:session_storage/session_storage.dart';

part 'auth_bloc.freezed.dart';
part 'auth_events.dart';
part 'auth_state.dart';

/// Session gate: cold restore, sign-in, sign-out.
///
/// Resolve with `appBlocSl<AuthBloc>()` after [registerAppBlocDependencies].
@lazySingleton
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc(this._authService) : super(const AuthState.initial()) {
    on<AuthCheckRequested>(_onCheck);
    on<AuthSignInRequested>(_onSignIn);
    on<AuthSignOutRequested>(_onSignOut);
  }

  final AuthService _authService;

  Future<void> _onCheck(AuthCheckRequested event, Emitter<AuthState> emit) async {
    emit(const AuthState.loading());
    final snapshot = await _authService.tryRestoreActiveSession();
    final hasAccess = snapshot?.supabaseAccessToken?.isNotEmpty ?? false;
    if (snapshot != null && hasAccess) {
      emit(AuthState.authenticated(snapshot));
    } else {
      emit(const AuthState.unauthenticated());
    }
  }

  Future<void> _onSignIn(AuthSignInRequested event, Emitter<AuthState> emit) async {
    emit(const AuthState.loading());
    final encoded = base64Encode(utf8.encode(event.password));
    final result = await _authService.signIn(
      email: event.email,
      encodedPassword: encoded,
    );
    if (result.success && result.session != null) {
      emit(AuthState.authenticated(result.session!));
    } else {
      emit(AuthState.unauthenticated(message: result.errorMessage ?? 'Sign in failed'));
    }
  }

  Future<void> _onSignOut(AuthSignOutRequested event, Emitter<AuthState> emit) async {
    await _authService.signOut();
    // Emit directly from authenticated → unauthenticated so root [BlocListener] can detect
    // logout (it does not see loading in between).
    emit(const AuthState.unauthenticated());
  }
}
