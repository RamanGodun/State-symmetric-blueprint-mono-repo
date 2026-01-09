// 📌 No need for public API docs.

part of '../../core_of_module/_errors_handling_entry_point.dart';

/// 🗺️ [firebaseFailureMap] — Maps Firebase error codes to domain [Failure]s
/// ✅ Injects original message as fallback (used when no localization is available)
/// ✅ Add more codes from [FirebaseCodes] as needed
/// ✅ Covers both FirebaseAuth & Firestore codes
//
final firebaseFailureMap = <String, Failure Function(String?)>{
  ///
  ///
  FirebaseCodes.invalidCredential: (msg) => Failure(
    type: const InvalidCredentialFirebaseFailureType(),
    message: msg,
  ),

  ///
  FirebaseCodes.emailAlreadyInUse: (msg) => Failure(
    type: const EmailAlreadyInUseFirebaseFailureType(),
    message: msg,
  ),

  ///
  FirebaseCodes.accountExistsWithDifferentCredential: (msg) => Failure(
    type: const AccountExistsWithDifferentCredentialFirebaseFailureType(),
    message: msg,
  ),

  ///
  FirebaseCodes.userMissing: (msg) =>
      Failure(type: const UserMissingFirebaseFailureType(), message: msg),

  ///
  FirebaseCodes.operationNotAllowed: (msg) => Failure(
    type: const OperationNotAllowedFirebaseFailureType(),
    message: msg,
  ),

  ///
  FirebaseCodes.requiresRecentLogin: (msg) => Failure(
    type: const RequiresRecentLoginFirebaseFailureType(),
    message: msg,
  ),

  ///
  FirebaseCodes.tooManyRequests: (msg) => Failure(
    type: const TooManyRequestsFirebaseFailureType(),
    message: msg,
  ),

  ///
  FirebaseCodes.userDisabled: (msg) =>
      Failure(type: const UserDisabledFirebaseFailureType(), message: msg),

  ///
  FirebaseCodes.userNotFound: (msg) =>
      Failure(type: const UserNotFoundFirebaseFailureType(), message: msg),

  ///
  FirebaseCodes.docMissing: (msg) =>
      Failure(type: const DocMissingFirebaseFailureType(), message: msg),

  // 🔥 Firebase Auth/Firestore мережеві кейси → RETRYABLE
  FirebaseCodes.networkRequestFailed: (msg) => Failure(
    type: const NetworkFailureType(), // retryable
    message: msg,
  ),
  FirebaseCodes.deadlineExceeded: (msg) => Failure(
    type: const NetworkTimeoutFailureType(), // retryable
    message: msg,
  ),
  // (fallback) іноді SDK може віддати просто "timeout"
  FirebaseCodes.timeout: (msg) => Failure(
    type: const NetworkTimeoutFailureType(), // retryable
    message: msg,
  ),

  //
};
