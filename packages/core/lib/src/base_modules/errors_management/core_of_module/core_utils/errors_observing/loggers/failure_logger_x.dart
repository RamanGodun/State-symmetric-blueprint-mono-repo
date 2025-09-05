import 'package:core/src/base_modules/errors_management/core_of_module/core_utils/errors_observing/loggers/errors_log_util.dart';
import 'package:core/src/base_modules/errors_management/core_of_module/failure_entity.dart';
import 'package:core/src/base_modules/errors_management/extensible_part/failure_extensions/failure_diagnostics_x.dart';
import 'package:flutter/foundation.dart' show debugPrint;

/// 🧩 [Failure] extensions — logging, diagnostics, analytics hooks
/// ✅ Track, debug, and log failures in structured way
//
extension FailureLogger on Failure {
  ///----------------------------

  /// 🐞 Logs failure to logger (e.g. Crashlytics)
  void log([StackTrace? stackTrace]) {
    ErrorsLogger.failure(this, stackTrace);
  }

  /// 🐛 Prints debug info with optional label
  Failure debugLog([String? label]) {
    final tag = label ?? 'Failure';
    debugPrint('[DEBUG][$tag] => $label — $message | status=$safeStatus');
    return this;
  }

  /// 📝 Summary string for quick diagnostics (stable: uses [safeCode]).
  String get debugSummary => '[$safeCode] $label';

  /// 📊 Tracks failure event using analytics callback
  Failure track(void Function(String eventName) trackCallback) {
    trackCallback('failure_${safeCode.toLowerCase()}');
    return this;
  }

  //
}
