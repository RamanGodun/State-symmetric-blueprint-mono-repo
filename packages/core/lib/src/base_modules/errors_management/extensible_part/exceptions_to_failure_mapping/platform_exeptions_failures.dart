part of '../../core_of_module/_errors_handling_entry_point.dart';

/// 🗺️ [platformFailureMap] — maps PlatformException codes to domain [Failure].
/// ✅ Single source for host/pigeon/engine-sourced errors (iOS/Android/Web).
/// ✅ Uses [FailureCodes] (which reuses [FirebaseCodes]) to avoid duplication.
//
final platformFailureMap = <String, Failure Function(String?)>{
  ///
  //
  // ───────────────────────────────────────────────
  /// 🔐 Auth (commonly surfaced as PlatformException)
  // ───────────────────────────────────────────────
  FailureCodes.invalidCredential: (m) =>
      Failure(type: const InvalidCredentialFirebaseFailureType(), message: m),
  FailureCodes.wrongPassword: (m) =>
      Failure(type: const InvalidCredentialFirebaseFailureType(), message: m),
  FailureCodes.invalidEmail: (m) =>
      Failure(type: const FormatFailureType(), message: m),
  //
  FailureCodes.userNotFound: (m) =>
      Failure(type: const UserNotFoundFirebaseFailureType(), message: m),
  FailureCodes.userDisabled: (m) =>
      Failure(type: const UserDisabledFirebaseFailureType(), message: m),
  FailureCodes.tooManyRequests: (m) =>
      Failure(type: const TooManyRequestsFirebaseFailureType(), message: m),
  //
  // ───────────────────────────────────────────────
  /// 🌐 Network / timeout (may bubble up as PlatformException)
  // ───────────────────────────────────────────────
  FailureCodes.networkRequestFailed: (m) =>
      Failure(type: const NetworkFailureType(), message: m),
  FirebaseCodes.timeout: (m) =>
      Failure(type: const NetworkTimeoutFailureType(), message: m),
  //
};
