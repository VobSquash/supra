import 'package:app_bloc/app_bloc.dart';
import 'package:auth/auth.dart';
import 'dart:typed_data';

import 'package:client_models/client_models.dart';
import 'package:get_it/get_it.dart';
import 'package:middleware/middleware_clients.dart';
import 'package:session_storage/session_storage.dart';
import 'package:test/test.dart';

class _FakeFacade implements IUsersFacade {
  @override
  Future<List<BasicProfileDTO>> loadActiveBasicProfiles() async => const [];

  @override
  Future<List<BasicProfileDTO>> loadBasicProfiles() async => const [];

  @override
  Future<BasicProfileDTO?> loadProfileByVobGuid(String vobGuid) async => null;

  @override
  Future<List<MemberLadderMembershipWithProfileDTO>> loadMemberLadderMembership(String vobGuid) async =>
      const [];

  @override
  Future<BasicProfileDTO> createMemberProfileAsAdmin({required CreateMemberProfileDto dto}) async =>
      BasicProfileDTO.empty();

  @override
  Future<BasicProfileDTO?> loadCurrentUserProfile() async => null;

  @override
  Future<BasicProfileDTO> updateOwnProfile({required UpdateOwnProfileDto dto}) async =>
      BasicProfileDTO.empty();

  @override
  Future<BasicProfileDTO> uploadOwnProfilePicture({
    required Uint8List bytes,
    required String contentType,
  }) async =>
      BasicProfileDTO.empty();

  @override
  Future<BasicProfileDTO> updateMemberProfileAsAdmin({
    required String profileRowId,
    required String? vobGuid,
    String? extensionId,
    required UpdateAdminProfileDto dto,
  }) async =>
      BasicProfileDTO.empty();
}

class _FakeLocationsFacade implements ILocationsFacade {
  @override
  Future<List<LocationsItemDTO>> loadLocations() async => const [];
}

class _FakeSettingsFacade implements ISettingsFacade {
  @override
  Future<SettingsDTO> loadSettings() async => SettingsDTO.empty();
}

class _FakeLaddersFacade implements ILaddersFacade {
  @override
  Future<LaddersListDTO> loadLadders() async => LaddersListDTO.empty();

  @override
  Future<void> saveLadderDivision({
    required LadderDivision division,
    required List<LadderItemDTO> items,
  }) async {}

  @override
  Future<void> addMemberToDivision({
    required LadderDivision division,
    required String vobGuid,
    required int sortOrder,
    int? team,
    bool canBeChallenged = false,
  }) async {}

  @override
  Future<void> removeMemberFromDivision({
    required LadderDivision division,
    required String vobGuid,
  }) async {}
}

class _FakeLeagueFixturesFacade implements ILeagueFixturesFacade {
  @override
  Future<List<LeagueFixtureDto>> loadLeagueFixtures() async => const [];
}

class _FakeBookingsFacade implements IBookingsFacade {
  @override
  Future<BookingListDto> loadBookings({required DateTime forDate}) async => BookingListDto.empty();

  @override
  Future<void> createBooking({required CreateBookingDto booking}) async {}

  @override
  Future<void> deleteBooking({required String bookingId}) async {}

  @override
  Future<void> createAdminBookings({required CreateAdminBookingDto dto}) async {}

  @override
  Future<void> deleteBookingAsAdmin({required String bookingId}) async {}

  @override
  Future<void> deleteAllBookingsForDateAsAdmin({required DateTime forDate}) async {}
}

class _FakeAuthService implements AuthService {
  @override
  Future<AuthResult> signIn({
    required String email,
    required String encodedPassword,
  }) async =>
      const AuthResult.failure('test');

  @override
  Future<AuthResult> restoreFromStoredToken(String jwt) async => const AuthResult.failure('test');

  @override
  Future<SessionSnapshot?> tryRestoreActiveSession() async => null;

  @override
  Future<void> signOut() async {}

  @override
  Future<AuthResult> updatePassword({required String newPassword}) async =>
      const AuthResult.failure('test');
}

void main() {
  tearDown(() async {
    await GetIt.instance.reset();
  });

  test('registerAppBlocDependencies registers factory UsersBloc', () {
    final sl = GetIt.instance;
    sl.registerSingleton<IUsersFacade>(_FakeFacade());
    sl.registerSingleton<ILocationsFacade>(_FakeLocationsFacade());
    sl.registerSingleton<ISettingsFacade>(_FakeSettingsFacade());
    sl.registerSingleton<ILaddersFacade>(_FakeLaddersFacade());
    sl.registerSingleton<ILeagueFixturesFacade>(_FakeLeagueFixturesFacade());
    sl.registerSingleton<IBookingsFacade>(_FakeBookingsFacade());
    sl.registerSingleton<AuthService>(_FakeAuthService());
    registerAppBlocDependencies(sl);

    final a = sl<UsersBloc>();
    final b = sl<UsersBloc>();
    expect(a, isA<UsersBloc>());
    expect(b, isA<UsersBloc>());
    expect(identical(a, b), isFalse);
  });

  test('registerAppBlocDependencies registers factory LocationsBloc', () {
    final sl = GetIt.instance;
    sl.registerSingleton<IUsersFacade>(_FakeFacade());
    sl.registerSingleton<ILocationsFacade>(_FakeLocationsFacade());
    sl.registerSingleton<ISettingsFacade>(_FakeSettingsFacade());
    sl.registerSingleton<ILaddersFacade>(_FakeLaddersFacade());
    sl.registerSingleton<ILeagueFixturesFacade>(_FakeLeagueFixturesFacade());
    sl.registerSingleton<IBookingsFacade>(_FakeBookingsFacade());
    sl.registerSingleton<AuthService>(_FakeAuthService());
    registerAppBlocDependencies(sl);

    final a = sl<LocationsBloc>();
    final b = sl<LocationsBloc>();
    expect(a, isA<LocationsBloc>());
    expect(b, isA<LocationsBloc>());
    expect(identical(a, b), isFalse);
  });

  test('registerAppBlocDependencies registers factory SettingsBloc', () {
    final sl = GetIt.instance;
    sl.registerSingleton<IUsersFacade>(_FakeFacade());
    sl.registerSingleton<ILocationsFacade>(_FakeLocationsFacade());
    sl.registerSingleton<ISettingsFacade>(_FakeSettingsFacade());
    sl.registerSingleton<ILaddersFacade>(_FakeLaddersFacade());
    sl.registerSingleton<ILeagueFixturesFacade>(_FakeLeagueFixturesFacade());
    sl.registerSingleton<IBookingsFacade>(_FakeBookingsFacade());
    sl.registerSingleton<AuthService>(_FakeAuthService());
    registerAppBlocDependencies(sl);

    final a = sl<SettingsBloc>();
    final b = sl<SettingsBloc>();
    expect(a, isA<SettingsBloc>());
    expect(b, isA<SettingsBloc>());
    expect(identical(a, b), isFalse);
  });

  test('registerAppBlocDependencies registers factory LaddersBloc', () {
    final sl = GetIt.instance;
    sl.registerSingleton<IUsersFacade>(_FakeFacade());
    sl.registerSingleton<ILocationsFacade>(_FakeLocationsFacade());
    sl.registerSingleton<ISettingsFacade>(_FakeSettingsFacade());
    sl.registerSingleton<ILaddersFacade>(_FakeLaddersFacade());
    sl.registerSingleton<ILeagueFixturesFacade>(_FakeLeagueFixturesFacade());
    sl.registerSingleton<IBookingsFacade>(_FakeBookingsFacade());
    sl.registerSingleton<AuthService>(_FakeAuthService());
    registerAppBlocDependencies(sl);

    final a = sl<LaddersBloc>();
    final b = sl<LaddersBloc>();
    expect(a, isA<LaddersBloc>());
    expect(b, isA<LaddersBloc>());
    expect(identical(a, b), isFalse);
  });

  test('registerAppBlocDependencies registers factory LeagueFixturesBloc', () {
    final sl = GetIt.instance;
    sl.registerSingleton<IUsersFacade>(_FakeFacade());
    sl.registerSingleton<ILocationsFacade>(_FakeLocationsFacade());
    sl.registerSingleton<ISettingsFacade>(_FakeSettingsFacade());
    sl.registerSingleton<ILaddersFacade>(_FakeLaddersFacade());
    sl.registerSingleton<ILeagueFixturesFacade>(_FakeLeagueFixturesFacade());
    sl.registerSingleton<IBookingsFacade>(_FakeBookingsFacade());
    sl.registerSingleton<AuthService>(_FakeAuthService());
    registerAppBlocDependencies(sl);

    final a = sl<LeagueFixturesBloc>();
    final b = sl<LeagueFixturesBloc>();
    expect(a, isA<LeagueFixturesBloc>());
    expect(b, isA<LeagueFixturesBloc>());
    expect(identical(a, b), isFalse);
  });

  test('registerAppBlocDependencies registers factory BookingsBloc', () {
    final sl = GetIt.instance;
    sl.registerSingleton<IUsersFacade>(_FakeFacade());
    sl.registerSingleton<ILocationsFacade>(_FakeLocationsFacade());
    sl.registerSingleton<ISettingsFacade>(_FakeSettingsFacade());
    sl.registerSingleton<ILaddersFacade>(_FakeLaddersFacade());
    sl.registerSingleton<ILeagueFixturesFacade>(_FakeLeagueFixturesFacade());
    sl.registerSingleton<IBookingsFacade>(_FakeBookingsFacade());
    sl.registerSingleton<AuthService>(_FakeAuthService());
    registerAppBlocDependencies(sl);

    final a = sl<BookingsBloc>();
    final b = sl<BookingsBloc>();
    expect(a, isA<BookingsBloc>());
    expect(b, isA<BookingsBloc>());
    expect(identical(a, b), isFalse);
  });
}
