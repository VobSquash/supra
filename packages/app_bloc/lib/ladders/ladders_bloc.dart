import 'package:app_bloc/base/base_bloc.dart';
import 'package:client_models/client_models.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:middleware/middleware_clients.dart';

part 'ladders_bloc.freezed.dart';
part 'ladders_events.dart';
part 'ladders_state.dart';

@injectable
class LaddersBloc extends BaseBloc<LaddersEvent, LaddersState> {
  LaddersBloc(this._laddersFacade) : super(initialState1: LaddersState.initial()) {
    on<LaddersEvent>(
      (event, emit) async {
        await event.map(
          onLoadLadders: (_) async {
            await handleLoadingState<LaddersListDTO>(
              emit,
              initialState: LaddersState.initial(),
              onLoading: () => state.copyWith(
                ladders: LaddersListDTO.empty(),
                status: BaseLoading.loading(),
              ),
              action: () => _laddersFacade.loadLadders(),
              onSuccess: (result) => state.copyWith(
                ladders: result ?? LaddersListDTO.empty(),
                status: BaseLoading.success(),
              ),
              onError: (error) => state.copyWith(
                ladders: LaddersListDTO.empty(),
                status: BaseLoading.error(
                  error ?? 'Unknown error while loading ladders',
                ),
              ),
            );
          },
          onResetLadders: (_) async {
            emit(LaddersState.initial());
          },
        );
      },
    );
  }

  final ILaddersFacade _laddersFacade;
}
