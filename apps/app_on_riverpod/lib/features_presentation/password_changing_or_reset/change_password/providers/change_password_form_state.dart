//
// ignore_for_file: public_member_api_docs

import 'package:core/base_modules/forms.dart'
    show ConfirmPasswordInputValidation, PasswordInputValidation;
import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';

/// 📦 [ChangePasswordFormState] — immutable state of the change password form
/// 🧠 Tracks inputs, visibility flags, and overall form validity
//
final class ChangePasswordFormState extends Equatable {
  /// ---------------------------------------------
  /// 🧱 Constructor with default (pure) values
  const ChangePasswordFormState({
    this.password = const PasswordInputValidation.pure(),
    this.confirmPassword = const ConfirmPasswordInputValidation.pure(),
    this.isPasswordObscure = true,
    this.isConfirmPasswordObscure = true,
    this.isValid = false,
  });
  //
  final PasswordInputValidation password;
  final ConfirmPasswordInputValidation confirmPassword;
  final bool isPasswordObscure;
  final bool isConfirmPasswordObscure;
  final bool isValid;

  /// 🔁 Returns new state with updated fields
  ChangePasswordFormState copyWith({
    PasswordInputValidation? password,
    ConfirmPasswordInputValidation? confirmPassword,
    bool? isPasswordObscure,
    bool? isConfirmPasswordObscure,
    bool? isValid,
  }) {
    return ChangePasswordFormState(
      password: password ?? this.password,
      confirmPassword: confirmPassword ?? this.confirmPassword,
      isPasswordObscure: isPasswordObscure ?? this.isPasswordObscure,
      isConfirmPasswordObscure:
          isConfirmPasswordObscure ?? this.isConfirmPasswordObscure,
      isValid: isValid ?? this.isValid,
    );
  }

  /// ✅ Validates inputs and updates [isValid]
  ChangePasswordFormState validate() {
    final valid = Formz.validate([password, confirmPassword]);
    return copyWith(isValid: valid);
  }

  /// 🔁 Revalidates [confirmPassword] after [password] changes
  ChangePasswordFormState updateConfirmPasswordValidation() {
    final updatedConfirm = confirmPassword.updatePassword(password.value);
    final valid = Formz.validate([password, updatedConfirm]);
    return copyWith(confirmPassword: updatedConfirm, isValid: valid);
  }

  @override
  List<Object> get props => [
    password,
    confirmPassword,
    isPasswordObscure,
    isConfirmPasswordObscure,
    isValid,
  ];

  //
}
