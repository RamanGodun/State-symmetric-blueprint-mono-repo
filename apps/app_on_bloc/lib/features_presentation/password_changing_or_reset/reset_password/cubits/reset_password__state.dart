//
// ignore_for_file: public_member_api_docs

part of 'reset_password__cubit.dart';

/// 🧾 [ResetPasswordState] — Sealed states for reset password flow
//
sealed class ResetPasswordState extends Equatable {
  ///-------------------------------------------
  const ResetPasswordState();
  @override
  List<Object?> get props => [];
}

////

/// ⏳ Initial idle state
final class ResetPasswordInitial extends ResetPasswordState {
  ///-------------------------------------------------------
  const ResetPasswordInitial();
}

/// 🕓 Submission in progress
final class ResetPasswordLoading extends ResetPasswordState {
  ///-------------------------------------------------------
  const ResetPasswordLoading();
}

/// ✅ Email sent successfully
final class ResetPasswordSuccess extends ResetPasswordState {
  ///-------------------------------------------------------
  const ResetPasswordSuccess();
}

/// ❌ Submission failed
final class ResetPasswordError extends ResetPasswordState {
  ///-------------------------------------------------------
  const ResetPasswordError(this.failure);
  final Failure failure;
  //
  @override
  List<Object?> get props => [failure];
}

////
////

/// 🧰 [ResetPasswordStateX] — convenience flags
//
extension ResetPasswordStateX on ResetPasswordState {
  ///--------------------------------------------
  bool get isLoading => this is ResetPasswordLoading;
  bool get isSuccess => this is ResetPasswordSuccess;
  bool get isError => this is ResetPasswordError;
}
