import 'package:core/core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// 🧩 [CubitWithAsyncState] — base Cubit for [AsyncState] state
/// ✅ Unified loader + Either helper
/// ✅ Ready for distinct-emits (pair with Equatable AsyncState)
///
abstract class CubitWithAsyncState<T> extends Cubit<AsyncState<T>> {
  ///--------------------------------------------------------
  CubitWithAsyncState() : super(const AsyncState.loading());

  /// 🗺️ Centralized mapping (errors_management): Exception/Error → Failure
  Failure mapError(Object e, StackTrace st) => e.mapToFailure(st);

  /// 🔁 Universal loader: loading → task → data/error
  /// 💡 Override if you need side-effects around load boundaries
  Future<void> loadTask(Future<T> Function() task) async {
    emit(const AsyncState.loading());
    try {
      final v = await task();
      emit(AsyncState<T>.data(v));
    } on Object catch (e, st) {
      // 🛡️ IMPORTANT: 'on Object catch (...)' to capture everything
      emit(AsyncState<T>.error(mapError(e, st)));
    }
  }

  /// ♻️ Helper for [Either<Failure, T>] sources
  void emitFromEither(Either<Failure, T> result) {
    result.fold(
      (f) => emit(AsyncState<T>.error(f)),
      (v) => emit(AsyncState<T>.data(v)),
    );
  }

  //
}
