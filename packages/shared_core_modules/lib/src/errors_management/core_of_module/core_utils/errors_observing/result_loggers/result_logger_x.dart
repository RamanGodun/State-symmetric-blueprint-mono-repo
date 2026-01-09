import 'package:flutter/foundation.dart' show debugPrint;
import 'package:shared_core_modules/src/errors_management/core_of_module/core_utils/errors_observing/loggers/errors_log_util.dart'
    show ErrorsLogger;
import 'package:shared_core_modules/src/errors_management/core_of_module/core_utils/extensions_on_either/either_getters_x.dart'
    show EitherGetters;
import 'package:shared_core_modules/src/errors_management/core_of_module/either.dart'
    show Either;
import 'package:shared_core_modules/src/errors_management/core_of_module/failure_entity.dart'
    show Failure;

part 'async_result_logger.dart';

/// 📦 [ResultLoggerExt<T>] — Unified logging extensions for Either and [Future<Either>]
/// ✅ Supports logging, tracking, and success/failure diagnostics
//
extension ResultLoggerExt<T> on Either<Failure, T> {
  ///--------------------------------------------

  /// 🪵 Logs failure if result is Left
  Either<Failure, T> log([StackTrace? stack]) {
    if (isLeft) ErrorsLogger.failure(leftOrNull!, stack);
    return this;
  }

  /// 📈 Logs success value to console if result is Right
  Either<Failure, T> logSuccess([String? label]) {
    if (isRight) {
      final tag = label ?? 'Success';
      debugPrint('[SUCCESS][$tag] $rightOrNull');
    }
    return this;
  }

  /// 📊 Tracks event name (analytics hook)
  Either<Failure, T> track(String eventName) {
    if (isRight) debugPrint('[TRACK] $eventName');
    return this;
  }

  //
}
