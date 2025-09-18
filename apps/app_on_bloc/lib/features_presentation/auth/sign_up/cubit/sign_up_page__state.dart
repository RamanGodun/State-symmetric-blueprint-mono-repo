//
// ignore_for_file: public_member_api_docs

part of 'sign_up_page__cubit.dart';

/// 🧾 [SignUpState] — Sealed states for sign-up flow
//
sealed class SignUpState extends Equatable {
  ///---------------------------------------
  const SignUpState();
  //
  @override
  List<Object?> get props => [];
}

////
////

/// ⏳ Idle
final class SignUpInitial extends SignUpState {
  ///---------------------------------------
  const SignUpInitial();
}

/// 🕓 In progress
final class SignUpLoading extends SignUpState {
  ///---------------------------------------
  const SignUpLoading();
}

////

/// ✅ Done
final class SignUpSuccess extends SignUpState {
  ///---------------------------------------
  const SignUpSuccess();
}

////

/// ❌ Failed
final class SignUpError extends SignUpState {
  ///---------------------------------------
  const SignUpError(this.failure);
  final Consumable<Failure>? failure;
  //
  @override
  List<Object?> get props => [failure];
}

////
////

/// 🧰 [SignUpStateX] — convenience flags
extension SignUpStateX on SignUpState {
  ///---------------------------------
  bool get isLoading => this is SignUpLoading;
  bool get isSuccess => this is SignUpSuccess;
  bool get isError => this is SignUpError;
}
