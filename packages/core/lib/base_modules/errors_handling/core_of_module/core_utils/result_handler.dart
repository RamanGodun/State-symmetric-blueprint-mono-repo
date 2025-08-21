import 'package:core/base_modules/errors_handling/core_of_module/core_utils/errors_observing/loggers/failure_logger_x.dart';
import 'package:core/base_modules/errors_handling/core_of_module/core_utils/extensions_on_either/either_getters_x.dart';
import 'package:core/base_modules/errors_handling/core_of_module/either.dart'
    show Either;
import 'package:core/base_modules/errors_handling/core_of_module/failure_entity.dart';
import 'package:flutter/material.dart';

/// 🧩 [ResultHandler<T>] — wrapper around `Either<Failure, T>`
/// ✅ Chainable and readable result API for cubits, Providers, UseCases.
//
@immutable
final class ResultHandler<T> {
  ///------------------------
  const ResultHandler(this.result);

  ///
  final Either<Failure, T> result;

  /// ───────────────────────────────
  // 🔹 Success / Failure Callbacks
  // ───────────────────────────────

  /// 🔹 Executes handler if result is success
  void onSuccess(void Function(T value) handler) {
    if (result.isRight) handler(result.rightOrNull as T);
  }

  /// 🔹 Executes handler if result is failure
  void onFailure(void Function(Failure failure) handler) {
    if (result.isLeft) handler(result.leftOrNull!);
  }

  /// ───────────────────────────────
  // 🎯 Accessors & Info
  // ───────────────────────────────

  /// ✅ Success value or fallback
  T getOrElse(T fallback) => result.fold((_) => fallback, (r) => r);

  /// ✅ Nullable success
  T? get valueOrNull => result.rightOrNull;

  /// ❌ Nullable failure
  Failure? get failureOrNull => result.leftOrNull;

  /// ✅ Indicates if result is failure
  bool get didFail => result.isLeft;

  /// ✅ Indicates if result is success
  bool get didSucceed => result.isRight;

  /// ───────────────────────────────
  // 🔁 Fold Logic
  // ───────────────────────────────

  /// 🔁 Pattern match logic
  void fold({
    required void Function(Failure failure) onFailure,
    required void Function(T value) onSuccess,
  }) {
    result.fold(onFailure, onSuccess);
  }

  /// ───────────────────────────────
  // 🧪 Logging
  // ───────────────────────────────

  /// 🐞 Logs failure (debug or Crashlytics)
  void log() {
    result.leftOrNull?.log();
  }

  //
}
