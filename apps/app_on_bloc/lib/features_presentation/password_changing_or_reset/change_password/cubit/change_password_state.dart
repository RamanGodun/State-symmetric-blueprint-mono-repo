//
// ignore_for_file: public_member_api_docs

part of 'change_password_cubit.dart';

/// 📄 [ChangePasswordState] — Stores reset form values and validation status
/// ✅ Centralized state object for validation, UI, and submission status
//
final class ChangePasswordState extends Equatable {
  ///-------------------------------------------
  const ChangePasswordState({
    this.password = const PasswordInputValidation.pure(),
    this.confirmPassword = const ConfirmPasswordInputValidation.pure(),
    this.status = FormzSubmissionStatus.initial,
    this.isValid = false,
    this.failure,
    this.isPasswordObscure = true,
    this.isConfirmPasswordObscure = true,
  });
  //
  final PasswordInputValidation password;
  final ConfirmPasswordInputValidation confirmPassword;
  final FormzSubmissionStatus status;
  final bool isValid;
  final Consumable<Failure>? failure;
  final bool isPasswordObscure;
  final bool isConfirmPasswordObscure;

  /// 🔁 Returns new state with updated fields
  ChangePasswordState _copyWith({
    PasswordInputValidation? password,
    ConfirmPasswordInputValidation? confirmPassword,
    FormzSubmissionStatus? status,
    bool? isValid,
    Consumable<Failure>? failure,
    bool? isPasswordObscure,
    bool? isConfirmPasswordObscure,
  }) {
    return ChangePasswordState(
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

/// 🧩 [ChangePasswordStateValidationX] — Adds validation/update logic to [ChangePasswordState]
/// ✅ Ensures clean field validation and consistent `isValid` flag management
//
extension ChangePasswordStateValidationX on ChangePasswordState {
  //
  /// ✅ Validates form fields using Formz
  /// 📅 Accepts optional overrides; falls back to current state values
  bool validateWith({
    PasswordInputValidation? password,
    ConfirmPasswordInputValidation? confirmPassword,
  }) {
    return Formz.validate([
      password ?? this.password,
      confirmPassword ?? this.confirmPassword,
    ]);
  }

  /// ➞ Returns a new state with updated values and revalidated form
  /// 📦 Supports field updates and UI controls like visibility or submission status
  ChangePasswordState updateWith({
    PasswordInputValidation? password,
    ConfirmPasswordInputValidation? confirmPassword,
    FormzSubmissionStatus? status,
    Consumable<Failure>? failure,
    bool? isPasswordObscure,
    bool? isConfirmPasswordObscure,
  }) {
    final updated = _copyWith(
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
