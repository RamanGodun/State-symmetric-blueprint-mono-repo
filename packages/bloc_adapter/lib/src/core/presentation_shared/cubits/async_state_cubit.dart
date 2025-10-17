import 'package:bloc_adapter/src/core/presentation_shared/async_state/async_value_for_bloc.dart';
import 'package:core/public_api/core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// 🧩 [CubitWithAsyncValue] — base Cubit for [AsyncValueForBLoC]
/// ✅ One-liners for loading/data/error/Either
//
abstract class CubitWithAsyncValue<T> extends Cubit<AsyncValueForBLoC<T>> {
  ///-------------------------------------------------------------------
  CubitWithAsyncValue() : super(AsyncValueForBLoC.loading());

  /// Centralized mapping (Exception/Error → Failure)
  Failure mapError(Object e, StackTrace st) => e.mapToFailure(st);

  bool get _alive => !isClosed;

  /// ⏳ Emit loading; preserves previous UI when [preserveUi]=true
  void emitLoading({bool preserveUi = false}) {
    if (!_alive) return;
    emit(
      preserveUi
          ? AsyncValueForBLoC<T>.loading().copyWithPrevious(state)
          : AsyncValueForBLoC<T>.loading(),
    );
  }

  /// ✅ Emit data
  void emitData(T value) {
    if (!_alive) return;
    emit(AsyncValueForBLoC<T>.data(value));
  }

  /// ❌ Emit error
  void emitFailure(Failure f) {
    if (!_alive) return;
    emit(AsyncValueForBLoC<T>.error(f));
  }

  /// ♻️ `Either<Failure, T>` → state
  void emitFromEither(Either<Failure, T> result) {
    if (!_alive) return;
    result.fold(emitFailure, emitData);
  }

  /// 🔁 loading → task → data/error (task throws on failure)
  Future<void> loadTask(
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

  /// ♻️ Hard reset to pure `loading` (e.g. on logout).
  void resetToLoading() {
    if (!_alive) return;
    emit(AsyncValueForBLoC<T>.loading());
  }

  //
}
