import 'package:app_bloc/base/base_bloc.dart';
import 'package:client_models/client_models.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:middleware/middleware_clients.dart';

part 'settings_bloc.freezed.dart';
part 'settings_events.dart';
part 'settings_state.dart';

/// Loads aggregated [SettingsDTO] via [ISettingsFacade].
@injectable
class SettingsBloc extends BaseBloc<SettingsEvent, SettingsState> {
  SettingsBloc(this._settingsFacade) : super(initialState1: SettingsState.initial()) {
    on<SettingsEvent>(
      (event, emit) async {
        await event.map(
          onLoadSettings: (_) async {
            await handleLoadingState<SettingsDTO>(
              emit,
              initialState: SettingsState.initial(),
              onLoading: () => state.copyWith(
                settings: SettingsDTO.empty(),
                status: BaseLoading.loading(),
              ),
              action: () => _settingsFacade.loadSettings(),
              onSuccess: (result) => state.copyWith(
                settings: result ?? SettingsDTO.empty(),
                status: BaseLoading.success(),
              ),
              onError: (error) => state.copyWith(
                settings: SettingsDTO.empty(),
                status: BaseLoading.error(
                  error ?? 'Unknown error while loading settings',
                ),
              ),
            );
          },
          onResetSettings: (_) async {
            emit(SettingsState.initial());
          },
        );
      },
    );
  }

  final ISettingsFacade _settingsFacade;
}
