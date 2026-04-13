import 'package:app_bloc/base/base_bloc.dart';
import 'package:client_models/client_models.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:middleware/middleware.dart';

part 'users_bloc.freezed.dart';
part 'users_events.dart';
part 'users_state.dart';

/// User/profile bloc using [BaseBloc.handleLoadingState].
///
/// Registered via injectable after [registerAppBlocDependencies] (resolve with
/// `appBlocSl<UsersBloc>()` or `GetIt.instance<UsersBloc>()`).
///
/// Each [UsersEvent] subtype has its own [on] handler so each async load uses
/// one straight `await handleLoadingState` path with bloc 9’s [Emitter].
@injectable
class UsersBloc extends BaseBloc<UsersEvent, UsersState> {
  UsersBloc(this._usersFacade) : super(initialState1: UsersState.initial()) {
    on<OnLoadBasicProfiles>(
      (event, emit) async {
        await handleLoadingState<List<BasicProfileDTO>>(
          emit,
          initialState: UsersState.initial(),
          onLoading: () => UsersState(
            profiles: const [],
            status: BaseLoading.loading(),
          ),
          action: () => _usersFacade.loadBasicProfiles(),
          onSuccess: (result) => UsersState(
            profiles: result ?? const [],
            status: BaseLoading.success(),
          ),
          onError: (error) => UsersState(
            profiles: const [],
            status: BaseLoading.error(
              error ?? 'Unknown error while loading profiles',
            ),
          ),
        );
      },
    );

    on<OnLoadActiveProfiles>(
      (event, emit) async {
        await handleLoadingState<List<BasicProfileDTO>>(
          emit,
          initialState: UsersState.initial(),
          onLoading: () => UsersState(
            profiles: const [],
            status: BaseLoading.loading(),
          ),
          action: () => _usersFacade.loadActiveBasicProfiles(),
          onSuccess: (result) => UsersState(
            profiles: result ?? const [],
            status: BaseLoading.success(),
          ),
          onError: (error) => UsersState(
            profiles: const [],
            status: BaseLoading.error(
              error ?? 'Unknown error while loading active profiles',
            ),
          ),
        );
      },
    );

    on<OnLoadByVobGuid>(
      (event, emit) async {
        await handleLoadingState<BasicProfileDTO>(
          emit,
          initialState: UsersState.initial(),
          onLoading: () => UsersState(
            profiles: const [],
            status: BaseLoading.loading(),
          ),
          action: () => _usersFacade.loadProfileByVobGuid(event.vobGuid),
          onSuccess: (result) => UsersState(
            profiles: result == null ? const [] : [result],
            status: BaseLoading.success(),
          ),
          onError: (error) => UsersState(
            profiles: const [],
            status: BaseLoading.error(
              error ?? 'Unknown error while loading profile',
            ),
          ),
        );
      },
    );

    on<OnReset>(
      (event, emit) {
        emit(UsersState.initial());
      },
    );
  }

  final IUsersFacade _usersFacade;
}
