// 📌 No need for public API docs.
// ignore_for_file: public_member_api_docs

/// 🧾 [FailureCodes] — centralized string constants for all known failure codes
/// ✅ Single source of truth for diagnostics, icons, factories, conditions
/// ✅ Reuses [FirebaseCodes] to avoid duplication
//
sealed class FailureCodes {
  ///-------------------
  //
  // ---
  /// ⚙️ Platform / plugin errors
  // ---
  static const platform = 'PLATFORM';
  static const missingPlugin = 'MISSING_PLUGIN';
  //
  // ---
  /// 🌐 Network
  // ---
  static const network = 'NETWORK';
  static const jsonError = 'JSON_ERROR';
  static const timeout = 'TIMEOUT';
  //
  /// 🔥 Firebase / Firestore / Auth (delegated to [FirebaseCodes])
  //
  static const firebase = 'FIREBASE';
  //
  /// Direct mappings to FirebaseCodes
  static const String invalidCredential = FirebaseCodes.invalidCredential;
  static const String wrongPassword = FirebaseCodes.wrongPassword;
  static const String invalidEmail = FirebaseCodes.invalidEmail;
  static const String emailAlreadyInUse = FirebaseCodes.emailAlreadyInUse;
  static const String operationNotAllowed = FirebaseCodes.operationNotAllowed;
  static const String requiresRecentLogin = FirebaseCodes.requiresRecentLogin;
  static const String tooManyRequests = FirebaseCodes.tooManyRequests;
  static const String userDisabled = FirebaseCodes.userDisabled;
  static const String userNotFound = FirebaseCodes.userNotFound;
  static const String accountExistsWithDifferentCredential =
      FirebaseCodes.accountExistsWithDifferentCredential;
  //
  /// Firestore/internal
  static const String firebaseUserMissing = FirebaseCodes.userMissing;
  static const String firestoreDocMissing = FirebaseCodes.docMissing;
  //
  /// Network / timeout
  static const String networkRequestFailed = FirebaseCodes.networkRequestFailed;
  static const String deadlineExceeded = FirebaseCodes.deadlineExceeded;
  //
  // ---
  // 🕒 Email verification (custom app-level codes)
  // ---
  static const emailVerificationTimeout = 'EMAIL_VERIFICATION_TIMEOUT';
  static const emailVerification = 'EMAIL_VERIFICATION';
  //
  // ---
  /// 🧊 SQLite / local DBs (custom)
  // ---
  static const sqlite = 'SQLITE';
  //
  // ---
  /// 📦 App-specific (domain / fallback)
  // ---
  static const useCase = 'USE_CASE';
  static const cache = 'CACHE';
  static const formatError = 'FORMAT_ERROR';
  static const api = 'API';
  static const noStatus = 'NO_STATUS';
  static const unknown = 'UNKNOWN';
  static const unauthorized = 'UNAUTHORIZED';
  static const unknownCode = 'UNKNOWN_CODE';
}

////
////

/// 🔒 [FirebaseCodes] — official Firebase error codes (Auth / Firestore / Network)
/// ✅ Single source of truth for all SDK codes
/// ✅ Prevents string duplication and typos across layers
//
sealed class FirebaseCodes {
  ///--------------------
  //
  // ---
  // 🔐 Auth codes
  // ---
  //
  /// Invalid or expired credential
  static const invalidCredential = 'invalid-credential';
  //
  /// Wrong password (platform-dependent, often Android/Web)
  static const wrongPassword = 'wrong-password';
  //
  /// Invalid email format
  static const invalidEmail = 'invalid-email';
  //
  /// Email already in use by another account
  static const emailAlreadyInUse = 'email-already-in-use';
  //
  /// Operation not allowed (disabled in Firebase console)
  static const operationNotAllowed = 'operation-not-allowed';
  //
  /// Requires recent login for sensitive operations
  static const requiresRecentLogin = 'requires-recent-login';
  //
  /// Too many requests (rate limited by Firebase)
  static const tooManyRequests = 'too-many-requests';
  //
  /// User account disabled
  static const userDisabled = 'user-disabled';
  //
  /// User not found (email not registered)
  static const userNotFound = 'user-not-found';
  //
  /// Account exists with a different sign-in method
  static const accountExistsWithDifferentCredential =
      'account-exists-with-different-credential';
  //
  // ---
  // 🗄️ Firestore / internal codes
  // ---
  //
  /// Internal: user missing
  static const userMissing = 'firebase-user-missing';
  //
  /// Firestore: document missing or malformed
  static const docMissing = 'firestore-doc-missing';
  //
  // ---
  // 🌐 Network / timeout codes
  // ---
  //
  /// Network request failed
  static const networkRequestFailed = 'network-request-failed';
  //
  /// Deadline exceeded (Firestore / Functions)
  static const deadlineExceeded = 'deadline-exceeded';
  //
  /// Generic timeout
  static const timeout = 'timeout';
  //
}
