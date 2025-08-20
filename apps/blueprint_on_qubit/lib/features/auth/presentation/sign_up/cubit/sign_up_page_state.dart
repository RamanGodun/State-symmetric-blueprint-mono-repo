//
// ignore_for_file: public_member_api_docs

part of 'sign_up_page_cubit.dart';

/// 🗞 [SignUpState] — Holds all field values and form status for [SignUpCubit]
/// ✅ Centralized state object for validation, UI, and submission status
//
final class SignUpState extends Equatable {
  ///-----------------------------------
  const SignUpState({
    this.name = const NameInputValidation.pure(),
    this.email = const EmailInputValidation.pure(),
    this.password = const PasswordInputValidation.pure(),
    this.confirmPassword = const ConfirmPasswordInputValidation.pure(),
    this.status = FormzSubmissionStatus.initial,
    this.isValid = false,
    this.failure,
    this.isPasswordObscure = true,
    this.isConfirmPasswordObscure = true,
  });
  //
  final NameInputValidation name;
  final EmailInputValidation email;
  final PasswordInputValidation password;
  final ConfirmPasswordInputValidation confirmPassword;
  final FormzSubmissionStatus status;
  final bool isValid;
  final Consumable<Failure>? failure;
  final bool isPasswordObscure;
  final bool isConfirmPasswordObscure;

  //

  /// 🧱 Clones current state with optional overrides
  // ⚠️ Use only inside `updateWith(...)` to ensure validation is re-applied!
  SignUpState _copyWith({
    NameInputValidation? name,
    EmailInputValidation? email,
    PasswordInputValidation? password,
    ConfirmPasswordInputValidation? confirmPassword,
    FormzSubmissionStatus? status,
    bool? isValid,
    Consumable<Failure>? failure,
    bool? isPasswordObscure,
    bool? isConfirmPasswordObscure,
  }) {
    return SignUpState(
      name: name ?? this.name,
      email: email ?? this.email,
      password: password ?? this.password,
      confirmPassword: confirmPassword ?? this.confirmPassword,
      status: status ?? this.status,
      isValid: isValid ?? this.isValid,
      failure: failure,
      isPasswordObscure: isPasswordObscure ?? this.isPasswordObscure,
      isConfirmPasswordObscure:
          isConfirmPasswordObscure ?? this.isConfirmPasswordObscure,
    );
  }

  @override
  List<Object?> get props => [
    name,
    email,
    password,
    confirmPassword,
    status,
    isValid,
    failure,
    isPasswordObscure,
    isConfirmPasswordObscure,
  ];

  //
}

////
////

/// 🥉 [SignUpStateValidationX] — Adds validation and update utilities to [SignUpState]
/// ✅ Simplifies state mutation and ensures validation is always up-to-date
/// 🔐 Used in `SignUpCubit` for field-level updates with validation
//
extension SignUpStateValidationX on SignUpState {
  ///-----------------------------------------

  /// ✅ Validates form fields using Formz
  /// 📅 Accepts optional overrides; falls back to current state values
  bool validateWith({
    NameInputValidation? name,
    EmailInputValidation? email,
    PasswordInputValidation? password,
    ConfirmPasswordInputValidation? confirmPassword,
  }) {
    return Formz.validate([
      name ?? this.name,
      email ?? this.email,
      password ?? this.password,
      confirmPassword ?? this.confirmPassword,
    ]);
  }

  /// ➞ Returns a new state with updated values and revalidated form
  /// 📦 Supports field updates and UI controls like visibility or submission status
  SignUpState updateWith({
    NameInputValidation? name,
    EmailInputValidation? email,
    PasswordInputValidation? password,
    ConfirmPasswordInputValidation? confirmPassword,
    FormzSubmissionStatus? status,
    Consumable<Failure>? failure,
    bool? isPasswordObscure,
    bool? isConfirmPasswordObscure,
  }) {
    final updated = _copyWith(
      name: name,
      email: email,
      password: password,
      confirmPassword: confirmPassword,
      status: status,
      failure: failure,
      isPasswordObscure: isPasswordObscure,
      isConfirmPasswordObscure: isConfirmPasswordObscure,
    );
    return updated._copyWith(isValid: updated.validateWith());
  }

  //
}
