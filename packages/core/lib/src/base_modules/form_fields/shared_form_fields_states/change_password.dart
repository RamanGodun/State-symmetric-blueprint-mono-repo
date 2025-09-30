//
// ignore_for_file: public_member_api_docs
import 'package:core/public_api/base_modules/forms.dart';
import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';

/// 📦 [ChangePasswordFormState] — immutable state of the reset-password form.
///    Tracks each input field and overall form validity.
//
final class ChangePasswordFormState extends Equatable {
  ///-----------------------------------------------
  const ChangePasswordFormState({
    this.password = const PasswordInputValidation.pure(),
    this.confirmPassword = const ConfirmPasswordInputValidation.pure(),
    this.isPasswordObscure = true,
    this.isConfirmPasswordObscure = true,
    this.isValid = false,
    this.epoch = 0,
  });
  //
  final PasswordInputValidation password;
  final ConfirmPasswordInputValidation confirmPassword;
  final bool isPasswordObscure;
  final bool isConfirmPasswordObscure;
  final bool isValid;
  final int epoch;

  /// 🧱 Updates current state  (raw Strings → Formz inputs + password-confirm sync)
  ChangePasswordFormState updateState({
    String? password,
    String? confirmPassword,
    bool? isPasswordObscure,
    bool? isConfirmPasswordObscure,
    int? epoch,
    bool revalidate = true,
  }) {
    //
    /// 🔍🧪 Input fields and validation
    final inputs = _nextInputs(
      password: password,
      confirmPassword: confirmPassword,
    );
    //
    final nextIsValid = revalidate
        ? Formz.validate([inputs.password, inputs.confirmPassword])
        : isValid;
    //
    /// 🆕 Get new state
    return ChangePasswordFormState(
      password: inputs.password,
      confirmPassword: inputs.confirmPassword,
      isPasswordObscure: isPasswordObscure ?? this.isPasswordObscure,
      isConfirmPasswordObscure:
          isConfirmPasswordObscure ?? this.isConfirmPasswordObscure,
      isValid: nextIsValid,
      epoch: epoch ?? this.epoch,
    );
  }

  /// 💠 Forms next inputs
  ({
    PasswordInputValidation password,
    ConfirmPasswordInputValidation confirmPassword,
  })
  _nextInputs({
    String? password,
    String? confirmPassword,
  }) {
    final nextPassword = (password != null)
        ? PasswordInputValidation.dirty(password.trim())
        : this.password;

    final nextConfirmPassword = (confirmPassword != null)
        ? ConfirmPasswordInputValidation.dirty(
            value: confirmPassword.trim(),
            password: nextPassword.value,
          )
        : (password != null)
        ? this.confirmPassword.updatePassword(nextPassword.value)
        : this.confirmPassword;

    return (password: nextPassword, confirmPassword: nextConfirmPassword);
  }

  ////

  @override
  List<Object> get props => [
    password,
    confirmPassword,
    isPasswordObscure,
    isConfirmPasswordObscure,
    isValid,
    epoch,
  ];
  //
}
