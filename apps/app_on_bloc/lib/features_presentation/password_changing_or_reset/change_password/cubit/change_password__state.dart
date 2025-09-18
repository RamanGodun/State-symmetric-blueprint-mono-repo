//
// ignore_for_file: public_member_api_docs

part of 'change_password__cubit.dart';

/// 🧾 [ChangePasswordState] — Sealed class describing all possible states for password change flow.
//
sealed class ChangePasswordState extends Equatable {
  ///--------------------------
  const ChangePasswordState();
  //
  @override
  List<Object?> get props => [];
  //
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
  const ChangePasswordSuccess();
  //
}

////

/// 🔄 [ChangePasswordRequiresReauth] — User must reauthenticate before updating password
final class ChangePasswordRequiresReauth extends ChangePasswordState {
  ///--------------------------------------------------------------
  const ChangePasswordRequiresReauth(this.failure);
  //
  final Failure failure;
  //
  @override
  List<Object?> get props => [failure];
}

////

/// ❌ [ChangePasswordError] — Error occurred during password update
final class ChangePasswordError extends ChangePasswordState {
  ///-----------------------------------------------------
  const ChangePasswordError(this.failure);
  //
  final Failure failure;
  //
  @override
  List<Object?> get props => [failure];
}

////
////

/// 🧰 [ChangePasswordStateX] — Extension for computed state properties (e.g., loading, success, etc.)
//
extension ChangePasswordStateX on ChangePasswordState {
  bool get isLoading => this is ChangePasswordLoading;
  bool get isSuccess => this is ChangePasswordSuccess;
  bool get isError => this is ChangePasswordError;
  bool get isRequiresReauth => this is ChangePasswordRequiresReauth;
}
