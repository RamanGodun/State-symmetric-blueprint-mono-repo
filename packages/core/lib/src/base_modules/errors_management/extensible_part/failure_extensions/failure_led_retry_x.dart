import 'package:core/src/base_modules/errors_management/core_of_module/failure_entity.dart';
import 'package:core/src/base_modules/errors_management/core_of_module/failure_type.dart';

/// 🧠 [FailureRetryX] — extension that defines whether [Failure] is retryable
/// ✅ Used by UI logic to decide if "Retry" should be shown to the user
//
extension FailureRetryX on Failure {
  ///
  bool get isRetryable => type.isRetryable;
}

////

/// 🔁 [FailureTypeRetryX] — UI-level retryability metadata for [FailureType]
/// ✅ Allows UI to decide if retry button should be shown
//
extension FailureTypeRetryX on FailureType {
  /// 🔁 True if the failure is transient and can be retried by user
  bool get isRetryable {
    if (this is NetworkFailureType) return true;
    if (this is NetworkTimeoutFailureType) return true;
    return false;
  }
}
