import 'package:core/core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// 🧩 [CoreAsyncCubit] — base cubit for [CoreAsync<T>] state
/// ✅ Has unified loader and Either helper
//
abstract class CoreAsyncCubit<T> extends Cubit<CoreAsync<T>> {
  ///------------------------------------------------------
  CoreAsyncCubit() : super(const CoreAsync.loading());

  /// 🧭 Centralized mapping (errors_management)
  Failure mapError(Object e, StackTrace st) => e.mapToFailure(st);

  /// 🔁 Universal loader: loading → task → data/error
  Future<void> loadTask(Future<T> Function() task) async {
    emit(const CoreAsync.loading());
    try {
      final v = await task();
      emit(CoreAsync<T>.data(v));
    } on Object catch (e, st) {
      // <- IMPORTANT: 'on Object catch (...)' to capture everything
      emit(CoreAsync<T>.error(mapError(e, st)));
    }
  }

  /// ♻️ Helper for [Either<Failure, T>]
  void emitFromEither(Either<Failure, T> result) {
    result.fold(
      (f) => emit(CoreAsync<T>.error(f)),
      (v) => emit(CoreAsync<T>.data(v)),
    );
  }

  //
}
