import 'package:app_bloc/base/base_bloc.dart';
import 'package:client_models/client_models.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:middleware/middleware.dart';

part 'users_bloc.freezed.dart';
part 'users_events.dart';
part 'users_state.dart';

/// User/profile bloc using [BaseBloc.handleLoadingState] and a single
/// [UsersEvent.map] dispatcher — same shape as
/// `packages/examples/file_examples/users/users_bloc.dart`.
///
/// Registered via injectable after [registerAppBlocDependencies] (resolve with
/// `appBlocSl<UsersBloc>()` or `GetIt.instance<UsersBloc>()`).
@injectable
class UsersBloc extends BaseBloc<UsersEvent, UsersState> {
  UsersBloc(this._usersFacade) : super(initialState1: UsersState.initial()) {
    on<UsersEvent>(
      (event, emit) async {
        await event.map(
          onLoadBasicProfiles: (_) async {
            await handleLoadingState<List<BasicProfileDTO>>(
              emit,
              initialState: UsersState.initial(),
              onLoading: () => state.copyWith(
                profiles: const [],
                status: BaseLoading.loading(),
              ),
              action: () => _usersFacade.loadBasicProfiles(),
              onSuccess: (result) => state.copyWith(
                profiles: result ?? const [],
                status: BaseLoading.success(),
              ),
              onError: (error) => state.copyWith(
                profiles: const [],
                status: BaseLoading.error(
                  error ?? 'Unknown error while loading profiles',
                ),
              ),
            );
          },
          onLoadActiveProfiles: (_) async {
            await handleLoadingState<List<BasicProfileDTO>>(
              emit,
              initialState: UsersState.initial(),
              onLoading: () => state.copyWith(
                profiles: const [],
                status: BaseLoading.loading(),
              ),
              action: () => _usersFacade.loadActiveBasicProfiles(),
              onSuccess: (result) => state.copyWith(
                profiles: result ?? const [],
                status: BaseLoading.success(),
              ),
              onError: (error) => state.copyWith(
                profiles: const [],
                status: BaseLoading.error(
                  error ?? 'Unknown error while loading active profiles',
                ),
              ),
            );
          },
          onLoadByVobGuid: (value) async {
            await handleLoadingState<BasicProfileDTO>(
              emit,
              initialState: UsersState.initial(),
              onLoading: () => state.copyWith(
                profiles: const [],
                status: BaseLoading.loading(),
              ),
              action: () => _usersFacade.loadProfileByVobGuid(value.vobGuid),
              onSuccess: (result) => state.copyWith(
                profiles: result == null ? const [] : [result],
                status: BaseLoading.success(),
              ),
              onError: (error) => state.copyWith(
                profiles: const [],
                status: BaseLoading.error(
                  error ?? 'Unknown error while loading profile',
                ),
              ),
            );
          },
          reset: (_) async {
            emit(UsersState.initial());
          },
        );
      },
    );
  }

  final IUsersFacade _usersFacade;
}
