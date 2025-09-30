//
// ignore_for_file: public_member_api_docs
import 'package:core/public_api/base_modules/forms.dart';
import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';

/// 📦 [SignUpFormState] — immutable state of the sign-up form.
///    Tracks each input field and overall form validity.
//
final class SignUpFormState extends Equatable {
  ///-----------------------------------
  const SignUpFormState({
    this.name = const NameInputValidation.pure(),
    this.email = const EmailInputValidation.pure(),
    this.password = const PasswordInputValidation.pure(),
    this.confirmPassword = const ConfirmPasswordInputValidation.pure(),
    this.isValid = false,
    this.isPasswordObscure = true,
    this.isConfirmPasswordObscure = true,
    this.epoch = 0,
  });
  //
  final NameInputValidation name;
  final EmailInputValidation email;
  final PasswordInputValidation password;
  final ConfirmPasswordInputValidation confirmPassword;
  final bool isValid;
  final bool isPasswordObscure;
  final bool isConfirmPasswordObscure;
  final int epoch;

  /// 🧱 Updates current state  (raw Strings → Formz inputs + password-confirm sync)
  SignUpFormState updateState({
    String? name,
    String? email,
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
      name: name,
      email: email,
      password: password,
      confirmPassword: confirmPassword,
    );
    //
    final nextIsValid = revalidate
        ? Formz.validate([
            inputs.name,
            inputs.email,
            inputs.password,
            inputs.confirmPassword,
          ])
        : isValid;
    //
    /// 🆕 Get new state
    return SignUpFormState(
      name: inputs.name,
      email: inputs.email,
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
    NameInputValidation name,
    EmailInputValidation email,
    PasswordInputValidation password,
    ConfirmPasswordInputValidation confirmPassword,
  })
  _nextInputs({
    String? name,
    String? email,
    String? password,
    String? confirmPassword,
  }) {
    final nextName = (name != null)
        ? NameInputValidation.dirty(name.trim())
        : this.name;
    final nextEmail = (email != null)
        ? EmailInputValidation.dirty(email.trim())
        : this.email;
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
    //
    return (
      name: nextName,
      email: nextEmail,
      password: nextPassword,
      confirmPassword: nextConfirmPassword,
    );
  }

  ////

  @override
  List<Object> get props => [
    name,
    email,
    password,
    confirmPassword,
    isValid,
    isPasswordObscure,
    isConfirmPasswordObscure,
    epoch,
  ];
  //
}
