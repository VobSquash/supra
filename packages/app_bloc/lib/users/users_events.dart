part of 'users_bloc.dart';

@freezed
class UsersEvent with _$UsersEvent {
  const factory UsersEvent.onLoadBasicProfiles() = OnLoadBasicProfiles;

  const factory UsersEvent.onLoadActiveProfiles() = OnLoadActiveProfiles;

  const factory UsersEvent.onLoadByVobGuid(String vobGuid) = OnLoadByVobGuid;

  const factory UsersEvent.reset() = OnReset;
}
