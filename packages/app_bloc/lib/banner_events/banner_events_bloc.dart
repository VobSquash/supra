import 'package:app_bloc/base/base_bloc.dart';
import 'package:client_models/client_models.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:middleware/middleware_clients.dart';

part 'banner_events_bloc.freezed.dart';
part 'banner_events_events.dart';
part 'banner_events_state.dart';

/// Loads [EventBannerDTO] rows from the `banner_events` storage bucket.
@injectable
class BannerEventsBloc extends BaseBloc<BannerEventsEvent, BannerEventsState> {
  BannerEventsBloc(this._facade) : super(initialState1: BannerEventsState.initial()) {
    on<BannerEventsEvent>(
      (event, emit) async {
        await event.map(
          onLoadEventBanners: (_) async {
            await handleLoadingState<List<EventBannerDTO>>(
              emit,
              initialState: BannerEventsState.initial(),
              onLoading: () => state.copyWith(
                banners: const [],
                status: BaseLoading.loading(),
              ),
              action: () => _facade.loadEventBanners(),
              onSuccess: (result) => state.copyWith(
                banners: result ?? const [],
                status: BaseLoading.success(),
              ),
              onError: (error) => state.copyWith(
                banners: const [],
                status: BaseLoading.error(
                  error ?? 'Unknown error while loading event banners',
                ),
              ),
            );
          },
          onResetEventBanners: (_) async {
            emit(BannerEventsState.initial());
          },
        );
      },
    );
  }

  final IBannerEventsFacade _facade;
}
