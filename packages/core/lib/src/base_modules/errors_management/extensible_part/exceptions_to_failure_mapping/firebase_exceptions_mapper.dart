// 📌 No need for public API docs.
// ignore_for_file: public_member_api_docs

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

  //
};

////

////

/// 🔒 [FirebaseCodes] — Firebase exception codes (used for map lookup)
/// ✅ Centralized registry of Firebase error codes
/// ✅ Prevents string duplication and typos across layers
//
sealed class FirebaseCodes {
  ///--------------------
  //
  static const invalidCredential = 'invalid-credential';
  static const emailAlreadyInUse = 'email-already-in-use';
  static const operationNotAllowed = 'operation-not-allowed';
  static const requiresRecentLogin = 'requires-recent-login';
  static const tooManyRequests = 'too-many-requests';
  static const userDisabled = 'user-disabled';
  static const accountExistsWithDifferentCredential =
      'account-exists-with-different-credential';
  static const userMissing = 'firebase-user-missing';
  static const userNotFound = 'user-not-found';
  static const docMissing = 'firestore-doc-missing';

  //
}
