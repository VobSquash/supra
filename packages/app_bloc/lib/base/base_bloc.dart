import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'base_bloc.freezed.dart';

/// Base [Bloc] with [handleLoadingState], matching the pattern in
/// `packages/examples/file_examples/base_bloc.dart`.
class BaseBloc<E, S> extends Bloc<E, S> {
  BaseBloc({required this.initialState1}) : super(initialState1);

  final S initialState1;

  Future<void> handleLoadingState<T>(
    Emitter<S> emit, {
    required S initialState,
    required Future<T?> Function() action,
    S Function(T? result)? onSuccess,
    Future<S> Function(T? result)? onSuccessAsync,
    required S Function(String? error) onError,
    S Function()? onLoading,
    Future<S> Function()? onLoadingAsync,
  }) async {
    assert(
      onSuccess != null || onSuccessAsync != null,
      'onSuccess or onSuccessAsync must be provided',
    );
    emit(initialState);
    if (onLoadingAsync != null) {
      emit(await onLoadingAsync());
    } else {
      emit(onLoading!());
    }

    try {
      final result = await action();
      if (onSuccessAsync != null) {
        emit(await onSuccessAsync(result));
      } else {
        emit(onSuccess!(result));
      }
    } catch (e) {
      // ignore: avoid_print
      print('$e - bloc handler');
      emit(onError(e.toString()));
    }
  }
}

@freezed
class BaseLoading with _$BaseLoading {
  const factory BaseLoading({
    required String? message,
    required BaseLoadingStatus status,
  }) = _BaseLoading;

  factory BaseLoading.initial() => const BaseLoading(
        message: '',
        status: BaseLoadingStatus.initial,
      );
  factory BaseLoading.loading() => const BaseLoading(
        message: '',
        status: BaseLoadingStatus.loading,
      );
  factory BaseLoading.saving(String? message) => BaseLoading(
        message: message,
        status: BaseLoadingStatus.saving,
      );
  factory BaseLoading.success() => const BaseLoading(
        message: '',
        status: BaseLoadingStatus.loadingSuccess,
      );
  factory BaseLoading.successSaving({String message = ''}) => BaseLoading(
        message: message,
        status: BaseLoadingStatus.saveSuccess,
      );
  factory BaseLoading.errorSaving(String? message) => BaseLoading(
        message: message?.replaceAll('Exception:', ''),
        status: BaseLoadingStatus.saveFailed,
      );
  factory BaseLoading.error(String? message) => BaseLoading(
        message: message,
        status: BaseLoadingStatus.loadingFailed,
      );
}

enum BaseLoadingStatus {
  initial,
  loading,
  loadingSuccess,
  loadingFailed,
  saving,
  saveSuccess,
  saveFailed,
}
