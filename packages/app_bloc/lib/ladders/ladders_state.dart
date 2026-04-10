part of 'ladders_bloc.dart';

@freezed
class LaddersState with _$LaddersState {
  const factory LaddersState({
    required LaddersListDTO ladders,
    required BaseLoading status,
  }) = _LaddersState;

  factory LaddersState.initial() => LaddersState(
        ladders: LaddersListDTO.empty(),
        status: BaseLoading.initial(),
      );
}
