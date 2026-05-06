import 'package:app_bloc/base/base_bloc.dart';
import 'package:client_models/client_models.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:middleware/middleware_clients.dart';

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
          initialState: state.copyWith(status: BaseLoading.initial()),
          onLoading: () => state.copyWith(status: BaseLoading.loading()),
          action: () => _usersFacade.loadBasicProfiles(),
          onSuccess: (result) => state.copyWith(
            profiles: result ?? const [],
            status: BaseLoading.success(),
          ),
          onError: (error) => state.copyWith(
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
          initialState: state.copyWith(status: BaseLoading.initial()),
          onLoading: () => state.copyWith(status: BaseLoading.loading()),
          action: () => _usersFacade.loadActiveBasicProfiles(),
          onSuccess: (result) => state.copyWith(
            profiles: result ?? const [],
            status: BaseLoading.success(),
          ),
          onError: (error) => state.copyWith(
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
          initialState: state.copyWith(
            profiles: const [],
            status: BaseLoading.initial(),
          ),
          onLoading: () => state.copyWith(
            profiles: const [],
            status: BaseLoading.loading(),
          ),
          action: () => _usersFacade.loadProfileByVobGuid(event.vobGuid),
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
    );

    on<OnLoadCurrentUserProfile>(
      (event, emit) async {
        try {
          final profile = await _usersFacade.loadCurrentUserProfile();
          emit(state.copyWith(currentUserProfile: profile));
        } catch (_) {
          // Keep prior profile on failure so the shell does not flicker.
        }
      },
    );

    on<OnReset>(
      (event, emit) {
        emit(UsersState.initial());
      },
    );
  }

  final IUsersFacade _usersFacade;

  /// Creates a profile + extension (admin / elevated only). Reload the list on success.
  Future<BasicProfileDTO> createMemberProfileAsAdmin({required CreateMemberProfileDto dto}) {
    return _usersFacade.createMemberProfileAsAdmin(dto: dto);
  }

  /// PATCH member profile (+ extension) fields (admin / elevated only).
  Future<BasicProfileDTO> updateMemberProfileAsAdmin({
    required String profileRowId,
    required String? vobGuid,
    String? extensionId,
    required UpdateAdminProfileDto dto,
  }) {
    return _usersFacade.updateMemberProfileAsAdmin(
      profileRowId: profileRowId,
      vobGuid: vobGuid,
      extensionId: extensionId,
      dto: dto,
    );
  }
}
