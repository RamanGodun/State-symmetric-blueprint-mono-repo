//
// ignore_for_file: public_member_api_docs

part of 'input_fields_cubit.dart';

/// 📄 [ChangePasswordFormState] — Stores reset form values and validation status
/// ✅ Centralized state object for validation, UI, and submission status
//
final class ChangePasswordFormState extends Equatable {
  ///-------------------------------------------
  const ChangePasswordFormState({
    this.password = const PasswordInputValidation.pure(),
    this.confirmPassword = const ConfirmPasswordInputValidation.pure(),
    this.isValid = false,
    this.isPasswordObscure = true,
    this.isConfirmPasswordObscure = true,
    this.epoch = 0,
  });
  //
  final PasswordInputValidation password;
  final ConfirmPasswordInputValidation confirmPassword;
  final bool isValid;
  final bool isPasswordObscure;
  final bool isConfirmPasswordObscure;
  final int epoch;

  /// 🔁 Returns new state with updated fields
  ChangePasswordFormState _copyWith({
    PasswordInputValidation? password,
    ConfirmPasswordInputValidation? confirmPassword,
    bool? isValid,
    bool? isPasswordObscure,
    bool? isConfirmPasswordObscure,
    int? epoch,
  }) {
    return ChangePasswordFormState(
      password: password ?? this.password,
      confirmPassword: confirmPassword ?? this.confirmPassword,
      isValid: isValid ?? this.isValid,
      isPasswordObscure: isPasswordObscure ?? this.isPasswordObscure,
      isConfirmPasswordObscure:
          isConfirmPasswordObscure ?? this.isConfirmPasswordObscure,
      epoch: epoch ?? this.epoch,
    );
  }

  /// ✅ Validates form fields using Formz
  ChangePasswordFormState validate() {
    final valid = Formz.validate([password, confirmPassword]);
    return _copyWith(isValid: valid);
  }

  /// ➞ Returns a new state with updated values and revalidated form
  /// 📦 Supports field updates and UI controls like visibility or submission status
  ChangePasswordFormState updateConfirmPasswordValidation() {
    final updatedConfirm = confirmPassword.updatePassword(password.value);
    final valid = Formz.validate([password, updatedConfirm]);
    return _copyWith(confirmPassword: updatedConfirm, isValid: valid);
  }

  @override
  List<Object?> get props => [
    password,
    confirmPassword,
    isValid,
    isPasswordObscure,
    isConfirmPasswordObscure,
    epoch,
  ];

  //
}
