import 'package:flutter/foundation.dart' show debugPrint;
import 'package:shared_core_modules/src/errors_management/core_of_module/failure_entity.dart'
    show Failure;
import 'package:shared_core_modules/src/errors_management/extensible_part/failure_extensions/failure_diagnostics_x.dart'
    show FailureX;

/// 🧭 [ErrorsLogger] — Centralized logger for all application-level telemetry.
/// 🔍 Supports runtime exceptions and domain-level failures
//
abstract final class ErrorsLogger {
  ///---------------------------
  const ErrorsLogger._();

  /// ❗ Logs any raw [Exception] or [Error].
  static void exception(Object error, [StackTrace? stackTrace]) {
    debugPrint('[Exception] ${error.runtimeType}: $error');
    if (stackTrace case final trace?) debugPrint(trace.toString());
  }

  /// 🧱 Logs a domain-level [Failure].
  static void failure(Failure failure, [StackTrace? stackTrace]) {
    debugPrint('[Failure] ${failure.label}');
    if (stackTrace case final trace?) debugPrint(trace.toString());
  }

  ///
  static void log(Object error, [StackTrace? stackTrace]) {
    ErrorsLogger.exception(error, stackTrace);
  }

  //
}
