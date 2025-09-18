//
// ignore_for_file: public_member_api_docs

part of 'sign_in_page__cubit.dart';

// 🧾 [SignInPageState] — Sealed states for sign-in flow
sealed class SignInPageState extends Equatable {
  ///----------------------------------------
  const SignInPageState();
  @override
  List<Object?> get props => [];
}

////

/// ⏳ Idle
final class SignInInitial extends SignInPageState {
  ///-------------------------------------------
  const SignInInitial();
}

/// 🕓 In progress
final class SignInLoading extends SignInPageState {
  ///-------------------------------------------
  const SignInLoading();
}

/// ✅ Done
final class SignInSuccess extends SignInPageState {
  ///-------------------------------------------
  const SignInSuccess();
}

/// ❌ Failed
final class SignInError extends SignInPageState {
  ///-----------------------------------------
  const SignInError(this.failure);
  //
  final Consumable<Failure>? failure;
  //
  @override
  List<Object?> get props => [failure];
}

////

/// 🧰 [SignInStateX] — convenience flags
//
extension SignInStateX on SignInPageState {
  ///-----------------------------------
  bool get isLoading => this is SignInLoading;
  bool get isSuccess => this is SignInSuccess;
  bool get isError => this is SignInError;
}
