import 'package:app_bloc/base/base_bloc.dart';
import 'package:client_models/client_models.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:middleware/middleware_clients.dart';

part 'locations_bloc.freezed.dart';
part 'locations_events.dart';
part 'locations_state.dart';

/// Loads [LocationsItemDTO] rows via [ILocationsFacade].
@injectable
class LocationsBloc extends BaseBloc<LocationsEvent, LocationsState> {
  LocationsBloc(this._locationsFacade) : super(initialState1: LocationsState.initial()) {
    on<LocationsEvent>(
      (event, emit) async {
        await event.map(
          onLoadLocations: (_) async {
            await handleLoadingState<List<LocationsItemDTO>>(
              emit,
              initialState: LocationsState.initial(),
              onLoading: () => state.copyWith(
                locations: const [],
                status: BaseLoading.loading(),
              ),
              action: () => _locationsFacade.loadLocations(),
              onSuccess: (result) => state.copyWith(
                locations: result ?? const [],
                status: BaseLoading.success(),
              ),
              onError: (error) => state.copyWith(
                locations: const [],
                status: BaseLoading.error(
                  error ?? 'Unknown error while loading locations',
                ),
              ),
            );
          },
          onResetLocations: (_) async {
            emit(LocationsState.initial());
          },
        );
      },
    );
  }

  final ILocationsFacade _locationsFacade;
}
