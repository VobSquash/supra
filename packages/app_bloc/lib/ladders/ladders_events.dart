part of 'ladders_bloc.dart';

@freezed
class LaddersEvent with _$LaddersEvent {
  const factory LaddersEvent.onLoadLadders() = OnLoadLadders;

  const factory LaddersEvent.onResetLadders() = OnResetLadders;
}
