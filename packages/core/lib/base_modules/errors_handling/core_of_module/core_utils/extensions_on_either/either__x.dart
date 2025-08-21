import 'package:core/base_modules/errors_handling/core_of_module/core_utils/errors_observing/loggers/errors_log_util.dart';
import 'package:core/base_modules/errors_handling/core_of_module/either.dart'
    show Either, Left, Right;
import 'package:core/base_modules/errors_handling/core_of_module/failure_entity.dart';
import 'package:flutter/foundation.dart' show debugPrint;

/// 🧩 [ResultX<T>] — Sync sugar for `Either<Failure, T>`
/// ✅ Enables fallback values, failure access, and folding logic
//
extension ResultX<T> on Either<Failure, T> {
  ///------------------------------------

  /// 🔁 Match (fold) sync logic — now chainable
  /// ✅ Auto-logs failure and tracks success
  Either<Failure, T> match({
    required void Function(Failure failure) onFailure,
    required void Function(T value) onSuccess,
    String? successTag,
    StackTrace? stack,
  }) {
    fold(
      (f) {
        ErrorsLogger.failure(f, stack);
        onFailure(f);
      },
      (r) {
        final tag = successTag ?? 'Success';
        debugPrint('[SUCCESS][$tag] $r');
        onSuccess(r);
      },
    );
    return this;
  }

  /// 🎯 Returns value or fallback
  T getOrElse(T fallback) => fold((_) => fallback, (r) => r);

  /// 🧼 Returns failure message or null
  String? get failureMessage => fold((f) => f.message, (_) => null);

  /// 🔁 Maps right value
  //  Either<Failure, R> mapRight<R>(R Function(T) f) => this.mapRight(f);
  Either<Failure, R> mapRightX<R>(R Function(T value) transform) =>
      fold(Left.new, (r) => Right(transform(r)));

  /// 🔁 Maps left value
  // Either<Failure, T> mapLeft(Failure Function(Failure) f) => this.mapLeft(f);
  Either<Failure, T> mapLeftX(Failure Function(Failure failure) transform) =>
      fold((l) => Left(transform(l)), Right.new);

  /// 🔍 True if failure is Unauthorized
  bool get isUnauthorizedFailure => switch (this) {
    Left(:final value) => value.safeCode == 'UNAUTHORIZED',
    Right() => false,
  };

  /// 🔁 Emits state changes declaratively
  void emitStates({
    required void Function(Failure) emitFailure,
    required void Function(T) emitSuccess,
    void Function()? emitLoading,
  }) {
    emitLoading?.call();
    fold(emitFailure, emitSuccess);
  }

  //
}
