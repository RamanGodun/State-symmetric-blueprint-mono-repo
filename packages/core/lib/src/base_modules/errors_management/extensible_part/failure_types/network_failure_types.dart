part of '../../core_of_module/failure_type.dart';

/// 🌐 [NetworkFailureType] — No connection or offline.
/// 🚀 Prompt user to check their internet settings.
//
final class NetworkFailureType extends FailureType {
  ///
  const NetworkFailureType()
    : super(
        code: FailureCodes.network,
        translationKey: LocaleKeys.failures_network_no_connection,
      );
}

////

/// ⏱️ [NetworkTimeoutFailureType] — Request took too long.
/// 🕰️ Ask user to retry or check their connection.
//
final class NetworkTimeoutFailureType extends FailureType {
  ///
  const NetworkTimeoutFailureType()
    : super(
        code: FailureCodes.timeout,
        translationKey: LocaleKeys.failures_network_timeout,
      );
}

////

/// 🧮 [JsonErrorFailureType] — Failed to encode/decode JSON.
/// 🪲 Typically means backend contract mismatch or unexpected response.
//
final class JsonErrorFailureType extends FailureType {
  ///
  const JsonErrorFailureType()
    : super(
        code: FailureCodes.jsonError,
        translationKey: LocaleKeys.failures_format_error,
      );
}

////

/// 🌍 [ApiFailureType] — Generic API-level error, often with HTTP status.
/// 🌩️ Not specific, use HTTP code for context.
//
final class ApiFailureType extends FailureType {
  ///
  const ApiFailureType()
    : super(
        code: FailureCodes.api,
        translationKey: LocaleKeys
            .failures_firebase_generic, // або custom API key, якщо він у тебе є
      );
}

////

/// 🚫 [UnauthorizedFailureType] — User is not authorized for this action.
/// 🔑 Prompt for login or permissions.
//
final class UnauthorizedFailureType extends FailureType {
  ///
  const UnauthorizedFailureType()
    : super(
        code: FailureCodes.unauthorized,
        translationKey: LocaleKeys.failures_firebase_unauthorized,
      );
}
