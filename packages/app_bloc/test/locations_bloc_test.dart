import 'package:app_bloc/app_bloc.dart';
import 'package:client_models/client_models.dart';
import 'package:middleware/middleware_clients.dart';
import 'package:test/test.dart';

class _FakeLocationsFacade implements ILocationsFacade {
  _FakeLocationsFacade(this._locations);

  final List<LocationsItemDTO> _locations;

  @override
  Future<List<LocationsItemDTO>> loadLocations() async => _locations;
}

void main() {
  test('onLoadLocations ends in loadingSuccess with locations', () async {
    final sample = LocationsItemDTO.empty().copyWith(
      name: 'Test',
      vobGuid: 'g1',
      latitude: '-36',
      longitude: '174',
    );
    final bloc = LocationsBloc(_FakeLocationsFacade([sample]));

    bloc.add(const LocationsEvent.onLoadLocations());
    await bloc.stream.firstWhere(
      (s) => s.status.status == BaseLoadingStatus.loadingSuccess,
    );
    expect(bloc.state.locations.length, 1);
    expect(bloc.state.locations.first.vobGuid, 'g1');
    await bloc.close();
  });
}
