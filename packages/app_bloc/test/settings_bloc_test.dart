import 'package:app_bloc/app_bloc.dart';
import 'package:client_models/client_models.dart';
import 'package:middleware/middleware_clients.dart';
import 'package:test/test.dart';

class _FakeSettingsFacade implements ISettingsFacade {
  @override
  Future<SettingsDTO> loadSettings() async => SettingsDTO.empty().copyWith(
        systemSettings: SystemSettingsDTO.empty().copyWith(
          objectId: '1',
          showLadderBreakdown: true,
        ),
      );
}

void main() {
  test('onLoadSettings ends in loadingSuccess', () async {
    final bloc = SettingsBloc(_FakeSettingsFacade());

    bloc.add(const SettingsEvent.onLoadSettings());
    await bloc.stream.firstWhere(
      (s) => s.status.status == BaseLoadingStatus.loadingSuccess,
    );
    expect(bloc.state.settings.systemSettings.showLadderBreakdown, true);
    await bloc.close();
  });
}
