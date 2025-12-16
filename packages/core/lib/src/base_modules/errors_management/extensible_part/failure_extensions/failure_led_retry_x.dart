import 'package:core/public_api/base_modules/errors_management.dart';

/// 🧠 [FailureRetryX] — extension that defines whether [Failure] is retryable
/// ✅ Used by UI logic to decide if "Retry" should be shown to the user
//
extension FailureRetryX on Failure {
  ///
  /// 🔁 True if failure is transient and safe to retry
  bool get isRetryable => type.isRetryable;
}

////

/// 🔁 [FailureTypeRetryX] — UI-level retryability metadata for [FailureType]
/// ✅ Allows UI to decide if retry button should be shown
//
extension FailureTypeRetryX on FailureType {
  ///
  /// 🔁 True if the failure is transient and can be retried by user
  bool get isRetryable =>
      code == FailureCodes.network || code == FailureCodes.timeout;
}
