import 'package:app_bloc/app_bloc.dart';
import 'package:client_models/client_models.dart';
import 'package:middleware/middleware.dart';
import 'package:test/test.dart';

class _FakeLaddersFacade implements ILaddersFacade {
  @override
  Future<LaddersListDTO> loadLadders() async => LaddersListDTO.empty().copyWith(
        showLadderBreakdown: true,
        men: [
          LadderItemDTO.empty().copyWith(order: 0, profile: BasicProfileDTO.empty().copyWith(firstName: 'A', lastName: 'B')),
        ],
      );
}

void main() {
  test('onLoadLadders ends in loadingSuccess', () async {
    final bloc = LaddersBloc(_FakeLaddersFacade());

    bloc.add(const LaddersEvent.onLoadLadders());
    await bloc.stream.firstWhere(
      (s) => s.status.status == BaseLoadingStatus.loadingSuccess,
    );
    expect(bloc.state.ladders.showLadderBreakdown, true);
    expect(bloc.state.ladders.men?.length, 1);
    await bloc.close();
  });
}
