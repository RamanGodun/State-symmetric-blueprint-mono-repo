import 'dart:async' show FutureOr;

import 'package:shared_core_modules/src/errors_management/core_of_module/core_utils/errors_observing/loggers/failure_logger_x.dart'
    show FailureLogger;
import 'package:shared_core_modules/src/errors_management/core_of_module/core_utils/extensions_on_either/either_getters_x.dart'
    show EitherGetters;
import 'package:shared_core_modules/src/errors_management/core_of_module/either.dart'
    show Either;
import 'package:shared_core_modules/src/errors_management/core_of_module/failure_entity.dart'
    show Failure;

/// 🧩 [ResultHandlerAsync<T>] — async wrapper around `Either<Failure, T>`
/// ✅ Provides clean async result handling with chainable syntax.
/// Useful for services, use-cases, and UI layers (e.g. after API calls).
//
final class ResultHandlerAsync<T> {
  ///---------------------------
  const ResultHandlerAsync(this.result);

  ///
  final Either<Failure, T> result;

  /// ───────────────────────────────
  // 🔹 Async Callbacks
  // ───────────────────────────────

  /// 🔹 Runs [handler] if result is Right (success)
  Future<ResultHandlerAsync<T>> onSuccessAsync(
    FutureOr<void> Function(T value) handler,
  ) async {
    if (result.isRight) await handler(result.rightOrNull as T);
    return this;
  }

  /// 🔹 Runs [handler] if result is Left (failure)
  Future<ResultHandlerAsync<T>> onFailureAsync(
    FutureOr<void> Function(Failure failure) handler,
  ) async {
    if (result.isLeft) await handler(result.leftOrNull!);
    return this;
  }

  /// ───────────────────────────────
  // 🔁 Fold
  // ───────────────────────────────

  /// 🔁 Fold logic for async success/failure handling
  Future<void> foldAsync({
    required FutureOr<void> Function(Failure failure) onFailure,
    required FutureOr<void> Function(T value) onSuccess,
  }) async {
    await result.fold(onFailure, onSuccess);
  }

  /// ───────────────────────────────
  // 🎯 Value Accessors
  // ───────────────────────────────

  /// ✅ Returns success value or fallback
  T getOrElse(T fallback) => result.fold((_) => fallback, (r) => r);

  /// 📥 Gets success value (nullable)
  T? get valueOrNull => result.rightOrNull;

  /// ❌ Gets failure (nullable)
  Failure? get failureOrNull => result.leftOrNull;

  /// ───────────────────────────────
  // 🧪 Logging
  // ───────────────────────────────

  /// 🐞 Logs failure (Crashlytics or debugPrint)
  Future<ResultHandlerAsync<T>> logAsync() async {
    result.leftOrNull?.log();
    return this;
  }

  //
}
