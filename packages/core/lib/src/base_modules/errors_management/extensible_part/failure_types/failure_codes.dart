// 📌 No need for public API docs.
// ignore_for_file: public_member_api_docs

/// 🧾 [FailureCodes] — centralized string constants for all known failure codes
/// ✅ Used to avoid magic strings across diagnostics, icons, factories, conditions
//
sealed class FailureCodes {
  // ⚙️ Platform/plugin errors
  static const platform = 'PLATFORM';

  // 🌐 Network
  static const network = 'NETWORK';
  static const jsonError = 'JSON_ERROR';
  static const timeout = 'TIMEOUT';

  // 🔥 Firebase/Firestore/Auth (OFFICIAL CODES!)
  static const firebase = 'FIREBASE';
  static const firebaseUserMissing =
      'user-missing'; // офіційний код: 'user-missing'
  static const firestoreDocMissing =
      'doc-missing'; // твій домен, або firestore internal

  // Firebase/Auth-specific codes (ALL in kebab-case as in SDK)
  static const invalidCredential = 'invalid-credential';
  static const accountExistsWithDifferentCredential =
      'account-exists-with-different-credential';
  static const emailAlreadyInUse = 'email-already-in-use';
  static const operationNotAllowed = 'operation-not-allowed';
  static const userDisabled = 'user-disabled';
  static const userNotFound = 'user-not-found';
  static const requiresRecentLogin = 'requires-recent-login';
  static const tooManyRequests = 'too-many-requests';

  // 🕒 Email verification (можеш лишити свої custom)
  static const emailVerificationTimeout = 'EMAIL_VERIFICATION_TIMEOUT';
  static const emailVerification = 'EMAIL_VERIFICATION';

  // 🧊 SQLite / local DBs (not used yet)
  static const sqlite = 'SQLITE';

  // App-specific
  static const useCase = 'USE_CASE';
  static const cache = 'CACHE';
  static const formatError = 'FORMAT_ERROR';
  static const missingPlugin = 'MISSING_PLUGIN';
  static const api = 'API';
  static const noStatus = 'NO_STATUS';
  static const unknown = 'UNKNOWN';
  static const unauthorized = 'UNAUTHORIZED';
  static const unknownCode = 'UNKNOWN_CODE';

  //
}
