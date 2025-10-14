part of '../../core_of_module/failure_type.dart';

/// 💥 [UnknownFailureType] — For truly unexpected, unclassified errors.
/// ❗️If you see this in production, something is wrong!
//
final class UnknownFailureType extends FailureType {
  ///
  const UnknownFailureType()
    : super(
        code: FailureCodes.unknown,
        translationKey: LocaleKeys.failures_unknown,
      );
}

////

/// 💾 [CacheFailureType] — Something went wrong with app cache.
/// 🚨 Usually recoverable after clearing storage.
//
final class CacheFailureType extends FailureType {
  ///
  const CacheFailureType()
    : super(
        code: FailureCodes.cache,
        translationKey: LocaleKeys.failures_cache_error,
      );
}

////

/// 🕒 [EmailVerificationTimeoutFailureType] — Verification link expired or user didn't confirm in time.
//
final class EmailVerificationTimeoutFailureType extends FailureType {
  ///
  const EmailVerificationTimeoutFailureType()
    : super(
        code: FailureCodes.emailVerificationTimeout,
        translationKey: LocaleKeys.failures_firebase_email_verification_timeout,
      );
}

////

/// 📄 [FormatFailureType] — Received malformed or unprocessable data.
/// 🛑 Usually indicates backend/data contract mismatch.
//
final class FormatFailureType extends FailureType {
  ///
  const FormatFailureType()
    : super(
        code: FailureCodes.formatError,
        translationKey: LocaleKeys.failures_format_error,
      );
}

////

/// 🧩 [MissingPluginFailureType] — Required plugin not installed or linked.
/// 🔧 Usually a dev/config issue.
//
final class MissingPluginFailureType extends FailureType {
  ///
  const MissingPluginFailureType()
    : super(
        code: FailureCodes.missingPlugin,
        translationKey: LocaleKeys.failures_plugin_missing,
      );
}
