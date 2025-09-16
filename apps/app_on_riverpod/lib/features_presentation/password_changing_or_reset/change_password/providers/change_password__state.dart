part of 'change_password__provider.dart';

/// 🧾 [ChangePasswordState] — Sealed class describing all possible states for password change flow.
//
sealed class ChangePasswordState {
  ///--------------------------
  const ChangePasswordState();
}

////
////

/// ⏳ [ChangePasswordInitial] — Initial state before any action
final class ChangePasswordInitial extends ChangePasswordState {
  ///-------------------------------------------------------
  const ChangePasswordInitial();
}

////

/// 🕓 [ChangePasswordLoading] — Indicates password update is in progress
final class ChangePasswordLoading extends ChangePasswordState {
  ///-------------------------------------------------------
  const ChangePasswordLoading();
}

////

/// ✅ [ChangePasswordSuccess] — Password was changed successfully
final class ChangePasswordSuccess extends ChangePasswordState {
  ///-------------------------------------------------------
  const ChangePasswordSuccess(this.message);
  //
  ///
  final String message;
}

////

/// 🔄 [ChangePasswordRequiresReauth] — User must reauthenticate before updating password
final class ChangePasswordRequiresReauth extends ChangePasswordState {
  ///--------------------------------------------------------------
  const ChangePasswordRequiresReauth(this.failure);
  //
  ///
  final Failure failure;
}

////

/// ❌ [ChangePasswordError] — Error occurred during password update
final class ChangePasswordError extends ChangePasswordState {
  ///-----------------------------------------------------
  const ChangePasswordError(this.failure);
  //
  ///
  final Failure failure;
}

////
////

/// 🧰 [ChangePasswordStateX] — Extension for computed state properties (e.g., loading, success, etc.)
//
extension ChangePasswordStateX on ChangePasswordState {
  ///
  bool get isLoading => this is ChangePasswordLoading;
  //
  ///
  bool get isSuccess => this is ChangePasswordSuccess;
  //
  ///
  bool get isError => this is ChangePasswordError;
  //
  ///
  bool get isRequiresReauth => this is ChangePasswordRequiresReauth;
  //
  ///
  bool get isRequiresRecentLogin =>
      this is ChangePasswordError &&
      (this as ChangePasswordError).failure.type
          is RequiresRecentLoginFirebaseFailureType;
  //
}
