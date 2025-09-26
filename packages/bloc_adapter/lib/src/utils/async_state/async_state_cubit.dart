import 'package:bloc_adapter/src/utils/async_state/async_value_for_bloc.dart';
import 'package:core/core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// 🧩 [CubitWithAsyncValue] — base Cubit for [AsyncValueForBLoC] state
/// ✅ Unified loader + Either helper
/// ✅ Ready for distinct-emits (pair with Equatable AsyncState)
///
abstract class CubitWithAsyncValue<T> extends Cubit<AsyncValueForBLoC<T>> {
  ///--------------------------------------------------------
  CubitWithAsyncValue() : super(const AsyncValueForBLoC.loading());

  /// 🗺️ Centralized mapping (errors_management): Exception/Error → Failure
  Failure mapError(Object e, StackTrace st) => e.mapToFailure(st);

  /// 🔁 Universal loader: loading → task → data/error
  /// 💡 Override if you need side-effects around load boundaries
  Future<void> loadTask(Future<T> Function() task) async {
    emit(const AsyncValueForBLoC.loading());
    try {
      final v = await task();
      emit(AsyncValueForBLoC<T>.data(v));
    } on Object catch (e, st) {
      // 🛡️ IMPORTANT: 'on Object catch (...)' to capture everything
      emit(AsyncValueForBLoC<T>.error(mapError(e, st)));
    }
  }

  /// ♻️ Helper for [Either<Failure, T>] sources
  void emitFromEither(Either<Failure, T> result) {
    result.fold(
      (f) => emit(AsyncValueForBLoC<T>.error(f)),
      (v) => emit(AsyncValueForBLoC<T>.data(v)),
    );
  }

  //
}
