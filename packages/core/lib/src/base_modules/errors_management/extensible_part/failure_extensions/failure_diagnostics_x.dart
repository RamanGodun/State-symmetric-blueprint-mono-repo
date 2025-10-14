import 'package:core/src/base_modules/errors_management/core_of_module/failure_entity.dart';
import 'package:core/src/base_modules/errors_management/extensible_part/failure_types/failure_codes.dart';

/// 🧭 [FailureX] — Unified extensions for [Failure]
/// ✅ Includes semantic type-checkers, diagnostics, casting, and safe metadata access
/// ✅ Used in conditional logic, logging, Crashlytics, result handlers, and UI mapping
//
extension FailureX on Failure {
  ///
  // ---
  /// 🔍 SEMANTIC TYPE CHECKERS
  // ---
  //
  /// 🌐 True if [Failure] is caused by network issues
  bool get isNetworkFailure => type.code == FailureCodes.network;
  //
  /// 🔑 True if [Failure] is unauthorized (401)
  bool get isUnauthorizedFailure => type.code == FailureCodes.unauthorized;
  //
  /// 📡 True if [Failure] comes from API response
  bool get isApiFailure => type.code == FailureCodes.api;
  //
  /// ❓ True if [Failure] type is unknown
  bool get isUnknownFailure => type.code == FailureCodes.unknown;
  //
  /// 🧩 True if [Failure] occurred inside domain/use-case layer
  bool get isUseCaseFailure => type.code == FailureCodes.useCase;
  //
  /// ⏱️ True if caused by timeout (network/operation)
  bool get isTimeoutFailure => type.code == FailureCodes.timeout;
  //
  /// 📧 True if related to email verification
  bool get isEmailVerificationFailure =>
      type.code == FailureCodes.emailVerification ||
      type.code == FailureCodes.emailVerificationTimeout;
  //
  /// 📄 True if Firestore document is missing
  bool get isFirestoreDocMissingFailure =>
      type.code == FailureCodes.firestoreDocMissing;
  //
  /// 🧑‍💻 True if Firebase user is missing
  bool get isFirebaseUserMissingFailure =>
      type.code == FailureCodes.firebaseUserMissing;
  //
  /// 💾 True if related to local cache/storage
  bool get isCacheFailure => type.code == FailureCodes.cache;
  //
  /// 🔥 True if general Firebase failure
  bool get isFirebaseFailure => type.code == FailureCodes.firebase;
  //
  /// 🧾 True if caused by format/parsing errors
  bool get isFormatErrorFailure => type.code == FailureCodes.formatError;
  //
  /// 🧩 True if plugin is missing
  bool get isMissingPluginFailure => type.code == FailureCodes.missingPlugin;
  //
  /// 🔢 True if JSON serialization/deserialization failed
  bool get isJsonErrorFailure => type.code == FailureCodes.jsonError;
  //
  /// 🔑 True if login credentials are invalid
  bool get isInvalidCredential => type.code == FailureCodes.invalidCredential;
  //
  // ---
  /// 🔁 Casting & Metadata access
  // ---
  //
  /// Safe type-cast of the current failure to a specific subtype
  T? as<T extends Failure>() => this is T ? this as T : null;
  //
  /// Non-null error code (e.g., for display, logs)
  String get safeCode => statusCode?.toString() ?? type.code;
  //
  /// Optional numeric status (e.g. HTTP, plugin, etc.)
  String get safeStatus => statusCode?.toString() ?? 'NO_STATUS';
  //
  /// Developer-friendly diagnostic label
  String get label => '$safeCode — ${message ?? "No message"}';
  //
}
