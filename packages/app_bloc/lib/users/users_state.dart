part of 'users_bloc.dart';

@freezed
class UsersState with _$UsersState {
  const factory UsersState({
    required List<BasicProfileDTO> profiles,
    required BaseLoading status,
  }) = _UsersState;

  factory UsersState.initial() => UsersState(
        profiles: const [],
        status: BaseLoading.initial(),
      );
}
