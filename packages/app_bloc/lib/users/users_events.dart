part of 'users_bloc.dart';

@freezed
class UsersEvent with _$UsersEvent {
  const factory UsersEvent.onLoadBasicProfiles() = OnLoadBasicProfiles;

  const factory UsersEvent.onLoadActiveProfiles() = OnLoadActiveProfiles;

  const factory UsersEvent.onLoadByVobGuid(String vobGuid) = OnLoadByVobGuid;

  /// Signed-in profile from [IUsersFacade.loadCurrentUserProfile] (RLS-backed row).
  const factory UsersEvent.loadCurrentUserProfile() = OnLoadCurrentUserProfile;

  const factory UsersEvent.reset() = OnReset;
}
