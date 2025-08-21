import 'dart:async' show FutureOr;

import 'package:core/base_modules/errors_handling/core_of_module/core_utils/errors_observing/loggers/errors_log_util.dart';
import 'package:core/base_modules/errors_handling/core_of_module/core_utils/extensions_on_either/either_getters_x.dart';
import 'package:core/base_modules/errors_handling/core_of_module/core_utils/result_handler_async.dart';
import 'package:core/base_modules/errors_handling/core_of_module/either.dart';
import 'package:core/base_modules/errors_handling/core_of_module/failure_entity.dart';
import 'package:core/utils_shared/timing_control/timing_config.dart'
    show AppDurations;
import 'package:flutter/foundation.dart' show debugPrint;

/// 🧩 [ResultFutureX<T>] — Async sugar for `Future<Either<Failure, T>>`
/// ✅ Unified access to async chaining, fallback and message handling
//
extension ResultFutureX<T> on Future<Either<Failure, T>> {
  ///--------------------------------------------------

  /// 🔁 Match with async callbacks — auto-logs failure and tracks success
  Future<void> matchAsync({
    required Future<void> Function(Failure) onFailure,
    required Future<void> Function(T) onSuccess,
    String? successTag,
    StackTrace? stack,
  }) async {
    final result = await this;
    return result.fold(
      (f) async {
        ErrorsLogger.failure(f, stack);
        await onFailure(f);
      },
      (r) async {
        final tag = successTag ?? 'Success';
        debugPrint('[SUCCESS][$tag] $r');
        await onSuccess(r);
      },
    );
  }

  /// 🎯 Get value or fallback
  Future<T> getOrElse(T fallback) async => (await this).rightOrNull ?? fallback;

  /// 🧼 Extract failure message or null
  Future<String?> failureMessageOrNull() async =>
      (await this).fold((f) => f.message, (_) => null);

  /// 🔹 Runs failure handler if result is Left
  Future<ResultHandlerAsync<T>> onFailure(
    FutureOr<void> Function(Failure f) handler,
  ) async {
    final result = await this;
    if (result.isLeft) await handler(result.leftOrNull!);
    return ResultHandlerAsync(result);
  }

  /// 🔁 Maps Right value using async transformation
  Future<Either<Failure, R>> mapRightAsync<R>(
    Future<R> Function(T r) transform,
  ) async {
    final result = await this;
    return switch (result) {
      Left(:final value) => Left(value),
      Right(:final value) => Right(await transform(value)),
    };
  }

  /// 🔁 Chains async transformation producing another Either
  Future<Either<Failure, R>> flatMapAsync<R>(
    Future<Either<Failure, R>> Function(T r) transform,
  ) async {
    final result = await this;
    return switch (result) {
      Left(:final value) => Left(value),
      Right(:final value) => await transform(value),
    };
  }

  /// 🔁 Executes fallback logic if result is Left
  Future<Either<Failure, T>> recover(
    FutureOr<T> Function(Failure f) recoverFn,
  ) async {
    final result = await this;
    return switch (result) {
      Left(:final value) => Right(await recoverFn(value)),
      Right() => result,
    };
  }

  /// 🔁 Retries the Future if result is failure, up to [maxAttempts]
  Future<Either<Failure, T>> retry({
    required Future<Either<Failure, T>> Function() task,
    int maxAttempts = 3,
    Duration delay = AppDurations.ms400,
  }) async {
    var result = await task();
    var attempt = 1;
    while (result.isLeft && attempt < maxAttempts) {
      await Future<void>.delayed(delay, () {});
      result = await task();
      attempt++;
    }
    return result;
  }

  //
}
