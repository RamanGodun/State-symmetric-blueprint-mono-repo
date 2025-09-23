//
// ignore_for_file: public_member_api_docs

import 'package:core/base_modules/forms.dart';
import 'package:equatable/equatable.dart' show Equatable;
import 'package:formz/formz.dart';

/// 📦 [SignUpFormState] — immutable state of the sign-up form.
/// Tracks each input field and overall form validity.
//
final class SignUpFormState extends Equatable {
  /// --------------------------------------
  /// Constructor with default pure inputs and flags
  const SignUpFormState({
    this.name = const NameInputValidation.pure(),
    this.email = const EmailInputValidation.pure(),
    this.password = const PasswordInputValidation.pure(),
    this.confirmPassword = const ConfirmPasswordInputValidation.pure(),
    this.isPasswordObscure = true,
    this.isConfirmPasswordObscure = true,
    this.isValid = false,
    this.epoch = 0,
  });
  //
  final NameInputValidation name;
  final EmailInputValidation email;
  final PasswordInputValidation password;
  final ConfirmPasswordInputValidation confirmPassword;
  final bool isPasswordObscure;
  final bool isConfirmPasswordObscure;
  final bool isValid;
  final int epoch;

  /// Copy method for updating fields and flags
  SignUpFormState copyWith({
    NameInputValidation? name,
    EmailInputValidation? email,
    PasswordInputValidation? password,
    ConfirmPasswordInputValidation? confirmPassword,
    bool? isPasswordObscure,
    bool? isConfirmPasswordObscure,
    bool? isValid,
    int? epoch,
  }) {
    return SignUpFormState(
      name: name ?? this.name,
      email: email ?? this.email,
      password: password ?? this.password,
      confirmPassword: confirmPassword ?? this.confirmPassword,
      isPasswordObscure: isPasswordObscure ?? this.isPasswordObscure,
      isConfirmPasswordObscure:
          isConfirmPasswordObscure ?? this.isConfirmPasswordObscure,
      isValid: isValid ?? this.isValid,
      epoch: epoch ?? this.epoch,
    );
  }

  /// Validates all fields and recalculates overall form validity
  SignUpFormState validate() {
    final valid = Formz.validate([name, email, password, confirmPassword]);
    return copyWith(isValid: valid);
  }

  /// 🔁 Revalidates confirmPassword if password changes
  SignUpFormState updateConfirmPasswordValidation() {
    final updatedConfirm = confirmPassword.updatePassword(password.value);
    final valid = Formz.validate([name, email, password, updatedConfirm]);
    return copyWith(confirmPassword: updatedConfirm, isValid: valid);
  }

  ///
  @override
  List<Object> get props => [
    name,
    email,
    password,
    confirmPassword,
    isPasswordObscure,
    isConfirmPasswordObscure,
    isValid,
    epoch,
  ];

  //
}
