part of '../../core_of_module/failure_type.dart';

/// 🔥 [GenericFirebaseFailureType] — Generic Firebase error fallback.
/// 🚨 Used when we can’t classify the Firebase error.
//
final class GenericFirebaseFailureType extends FailureType {
  ///
  const GenericFirebaseFailureType()
    : super(
        code: FailureCodes.firebase,
        translationKey: LocaleKeys.failures_firebase_generic,
      );
}

////

/// 🔑 [InvalidCredentialFirebaseFailureType] — Wrong or invalid login credentials.
/// 🔐 Happens often with OAuth/social logins.
//
final class InvalidCredentialFirebaseFailureType extends FailureType {
  ///
  const InvalidCredentialFirebaseFailureType()
    : super(
        code: FailureCodes.invalidCredential,
        translationKey: LocaleKeys.failures_firebase_invalid_credential,
      );
}

////

/// 🪪 [AccountExistsWithDifferentCredentialFirebaseFailureType] — Email already registered with another provider.
/// 🪝 User must login using linked provider.
//
final class AccountExistsWithDifferentCredentialFirebaseFailureType
    extends FailureType {
  ///
  const AccountExistsWithDifferentCredentialFirebaseFailureType()
    : super(
        code: FailureCodes.accountExistsWithDifferentCredential,
        translationKey: LocaleKeys
            .failures_firebase_account_exists_with_different_credential,
      );
}

////

/// 📧 [EmailAlreadyInUseFirebaseFailureType] — Email address already in use.
//
final class EmailAlreadyInUseFirebaseFailureType extends FailureType {
  ///
  const EmailAlreadyInUseFirebaseFailureType()
    : super(
        code: FailureCodes.emailAlreadyInUse,
        translationKey: LocaleKeys.failures_firebase_email_already_in_use,
      );
}

////

/// 🛑 [OperationNotAllowedFirebaseFailureType] — Operation blocked by Firebase settings.
//
final class OperationNotAllowedFirebaseFailureType extends FailureType {
  ///
  const OperationNotAllowedFirebaseFailureType()
    : super(
        code: FailureCodes.operationNotAllowed,
        translationKey: LocaleKeys.failures_firebase_operation_not_allowed,
      );
}

////

/// 🛡️ [UserDisabledFirebaseFailureType] — Account is disabled by admin.
/// ⚠️ User needs to contact support.
//
final class UserDisabledFirebaseFailureType extends FailureType {
  ///
  const UserDisabledFirebaseFailureType()
    : super(
        code: FailureCodes.userDisabled,
        translationKey: LocaleKeys.failures_firebase_user_disabled,
      );
}

////

/// ❓ [UserNotFoundFirebaseFailureType] — User does not exist in database.
//
final class UserNotFoundFirebaseFailureType extends FailureType {
  ///
  const UserNotFoundFirebaseFailureType()
    : super(
        code: FailureCodes.userNotFound,
        translationKey: LocaleKeys.failures_firebase_user_not_found,
      );
}

////

/// 🕐 [RequiresRecentLoginFirebaseFailureType] — Sensitive action, needs re-auth.
//
/// 🔁 Prompt user to re-login.
final class RequiresRecentLoginFirebaseFailureType extends FailureType {
  ///
  const RequiresRecentLoginFirebaseFailureType()
    : super(
        code: FailureCodes.requiresRecentLogin,
        translationKey: LocaleKeys.failures_firebase_requires_recent_login,
      );
}

////

/// 🧑‍💻 [UserMissingFirebaseFailureType] — No current Firebase user signed in.
//
final class UserMissingFirebaseFailureType extends FailureType {
  ///
  const UserMissingFirebaseFailureType()
    : super(
        code: FailureCodes.firebaseUserMissing,
        translationKey: LocaleKeys.failures_firebase_no_current_user,
      );
}

////

/// 🗂️ [DocMissingFirebaseFailureType] — User profile document not found in Firestore.
//
final class DocMissingFirebaseFailureType extends FailureType {
  ///
  const DocMissingFirebaseFailureType()
    : super(
        code: FailureCodes.firestoreDocMissing,
        translationKey: LocaleKeys.failures_firebase_doc_missing,
      );
}

////

/// 🚦 [TooManyRequestsFirebaseFailureType] — User triggered Firebase rate limit.
/// ⏳ Ask user to wait and try again.
//
final class TooManyRequestsFirebaseFailureType extends FailureType {
  ///
  const TooManyRequestsFirebaseFailureType()
    : super(
        code: FailureCodes.tooManyRequests,
        translationKey: LocaleKeys.failures_firebase_too_many_requests,
      );
}
