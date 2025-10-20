import 'package:bloc_adapter/src/core/presentation_shared/async_state/async_value_for_bloc.dart';
import 'package:core/public_api/core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// [CubitWithAsyncValue<T>] — base cubit for features that expose [AsyncValueForBLoC<T>].
/// - One-liners for loading/data/error/Either
/// - Error handling is Failure-only (no stack traces here)
/// - Consistent UX: optional "preserve UI on refresh" semantics via copyWithPrevious()
//
abstract class CubitWithAsyncValue<T> extends Cubit<AsyncValueForBLoC<T>> {
  ///-------------------------------------------------------------------
  CubitWithAsyncValue() : super(AsyncValueForBLoC.loading());

  /// Maps any thrown object to a domain Failure.
  /// Override if a feature needs custom mapping.
  Failure mapError(Object error, StackTrace stackTrace) =>
      error.mapToFailure(stackTrace);

  /// Convenience flag to avoid emitting after close.
  bool get _alive => !isClosed;

  /// ⏳ Emit `loading()`. If [preserveUi]=true and previous state has data/error,
  /// the loading state will carry that previous value for better UX.
  void emitLoading({bool preserveUi = false}) {
    if (!_alive) return;
    final next = AsyncValueForBLoC<T>.loading();
    emit(preserveUi ? next.copyWithPrevious(state) : next);
  }

  /// ✅ Emit data
  void emitData(T value) {
    if (!_alive) return;
    emit(AsyncValueForBLoC<T>.data(value));
  }

  /// ❌ Emit error
  void emitFailure(Failure failure) {
    if (!_alive) return;
    emit(AsyncValueForBLoC<T>.error(failure));
  }

  /// ♻️ `Either<Failure, T>` → state
  void emitFromEither(Either<Failure, T> result) {
    if (!_alive) return;
    result.fold(emitFailure, emitData);
  }

  /// 🛡️ Run [task] with unified Loading/Data/Error emissions.
  ///   - Emits `loading()` (optionally preserving previous UI).
  ///   - On success -> `data(value)`.
  ///   - On error   -> map to `Failure` and emit `error(failure)`.
  Future<void> emitGuarded(
    Future<T> Function() task, {
    bool preserveUi = false,
  }) async {
    emitLoading(preserveUi: preserveUi);
    try {
      final v = await task();
      if (!_alive) return;
      emitData(v);
    } on Object catch (e, st) {
      if (!_alive) return;
      emitFailure(mapError(e, st));
    }
  }

  /// ♻️ Hard reset to a pure `loading()` (useful in tests or after sign-out).
  void resetToLoading() {
    if (!_alive) return;
    emit(AsyncValueForBLoC<T>.loading());
  }

  //
}
