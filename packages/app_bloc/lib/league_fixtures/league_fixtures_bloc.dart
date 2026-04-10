import 'package:app_bloc/base/base_bloc.dart';
import 'package:client_models/client_models.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:middleware/middleware.dart';

part 'league_fixtures_bloc.freezed.dart';
part 'league_fixtures_events.dart';
part 'league_fixtures_state.dart';

/// Loads [LeagueFixtureDto] rows via [ILeagueFixturesFacade].
@injectable
class LeagueFixturesBloc extends BaseBloc<LeagueFixturesEvent, LeagueFixturesState> {
  LeagueFixturesBloc(this._facade) : super(initialState1: LeagueFixturesState.initial()) {
    on<LeagueFixturesEvent>(
      (event, emit) async {
        await event.map(
          onLoadLeagueFixtures: (_) async {
            await handleLoadingState<List<LeagueFixtureDto>>(
              emit,
              initialState: LeagueFixturesState.initial(),
              onLoading: () => state.copyWith(
                fixtures: const [],
                status: BaseLoading.loading(),
              ),
              action: () => _facade.loadLeagueFixtures(),
              onSuccess: (result) => state.copyWith(
                fixtures: result ?? const [],
                status: BaseLoading.success(),
              ),
              onError: (error) => state.copyWith(
                fixtures: const [],
                status: BaseLoading.error(
                  error ?? 'Unknown error while loading league fixtures',
                ),
              ),
            );
          },
          onResetLeagueFixtures: (_) async {
            emit(LeagueFixturesState.initial());
          },
        );
      },
    );
  }

  final ILeagueFixturesFacade _facade;
}
