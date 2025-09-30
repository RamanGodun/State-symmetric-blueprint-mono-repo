//
// ignore_for_file: public_member_api_docs
import 'package:core/public_api/base_modules/forms.dart';
import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';

/// 📦 [SignInFormState] — immutable state of the sign-in form.
///    Tracks each input field and overall form validity.
//
final class SignInFormState extends Equatable {
  ///---------------------------------------
  const SignInFormState({
    this.email = const EmailInputValidation.pure(),
    this.password = const PasswordInputValidation.pure(),
    this.isPasswordObscure = true,
    this.isValid = false,
    this.epoch = 0,
  });
  //
  final EmailInputValidation email;
  final PasswordInputValidation password;
  final bool isPasswordObscure;
  final bool isValid;
  final int epoch;

  /// 🧱 Updates current state  (raw Strings → Formz inputs)
  SignInFormState updateState({
    String? email,
    String? password,
    bool? isPasswordObscure,
    int? epoch,
    bool revalidate = true,
  }) {
    //
    /// 🔍🧪 Input fields and validation
    final inputs = _nextInputs(email: email, password: password);
    //
    final nextIsValid = revalidate
        ? Formz.validate([inputs.email, inputs.password])
        : isValid;
    //
    /// 🆕 Get new state
    return SignInFormState(
      email: inputs.email,
      password: inputs.password,
      isPasswordObscure: isPasswordObscure ?? this.isPasswordObscure,
      isValid: nextIsValid,
      epoch: epoch ?? this.epoch,
    );
  }

  /// 💠 Forms next inputs
  ({EmailInputValidation email, PasswordInputValidation password}) _nextInputs({
    String? email,
    String? password,
  }) {
    final nextEmail = (email != null)
        ? EmailInputValidation.dirty(email.trim())
        : this.email;

    final nextPassword = (password != null)
        ? PasswordInputValidation.dirty(password.trim())
        : this.password;

    return (email: nextEmail, password: nextPassword);
  }

  ////

  @override
  List<Object> get props => [
    email,
    password,
    isPasswordObscure,
    isValid,
    epoch,
  ];
  //
}
