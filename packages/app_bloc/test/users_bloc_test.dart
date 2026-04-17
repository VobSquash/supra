import 'package:app_bloc/app_bloc.dart';
import 'package:client_models/client_models.dart';
import 'package:middleware/middleware_clients.dart';
import 'package:test/test.dart';

class _FakeUsersFacade implements IUsersFacade {
  _FakeUsersFacade(this._profiles);

  final List<BasicProfileDTO> _profiles;

  @override
  Future<List<BasicProfileDTO>> loadActiveBasicProfiles() async =>
      _profiles.where((p) => p.isActive == true).toList();

  @override
  Future<List<BasicProfileDTO>> loadBasicProfiles() async => _profiles;

  @override
  Future<BasicProfileDTO?> loadProfileByVobGuid(String vobGuid) async {
    try {
      return _profiles.firstWhere((p) => p.vobGuid == vobGuid);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<List<MemberLadderMembershipWithProfileDTO>> loadMemberLadderMembership(String vobGuid) async =>
      const [];

  @override
  Future<BasicProfileDTO> createMemberProfileAsAdmin({required CreateMemberProfileDto dto}) async {
    return BasicProfileDTO.empty().copyWith(
      firstName: dto.firstName,
      lastName: dto.lastName,
      email: dto.email,
    );
  }
}

void main() {
  test('onLoadBasicProfiles ends in loadingSuccess with profiles', () async {
    final sample = BasicProfileDTO.empty().copyWith(
      objectId: '1',
      vobGuid: 'g1',
      firstName: 'A',
      lastName: 'B',
    );
    final bloc = UsersBloc(_FakeUsersFacade([sample]));

    bloc.add(const UsersEvent.onLoadBasicProfiles());
    await bloc.stream.firstWhere(
      (s) => s.status.status == BaseLoadingStatus.loadingSuccess,
    );
    expect(bloc.state.profiles.length, 1);
    expect(bloc.state.profiles.first.vobGuid, 'g1');
    await bloc.close();
  });

  test('onLoadActiveProfiles ends in loadingSuccess with profiles', () async {
    final sample = BasicProfileDTO.empty().copyWith(
      objectId: '1',
      vobGuid: 'g1',
      firstName: 'A',
      lastName: 'B',
      isActive: true,
    );
    final bloc = UsersBloc(_FakeUsersFacade([sample]));

    bloc.add(const UsersEvent.onLoadActiveProfiles());
    await bloc.stream.firstWhere(
      (s) => s.status.status == BaseLoadingStatus.loadingSuccess,
    );
    expect(bloc.state.profiles.length, 1);
    expect(bloc.state.profiles.first.vobGuid, 'g1');
    await bloc.close();
  });

  test('onLoadByVobGuid yields empty profiles when not found', () async {
    final bloc = UsersBloc(_FakeUsersFacade([]));

    bloc.add(const UsersEvent.onLoadByVobGuid('missing'));
    await bloc.stream.firstWhere(
      (s) => s.status.status == BaseLoadingStatus.loadingSuccess,
    );
    expect(bloc.state.profiles, isEmpty);
    await bloc.close();
  });
}
