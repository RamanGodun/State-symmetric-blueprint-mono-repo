//
// ignore_for_file: public_member_api_docs

part of 'input_fields_cubit.dart';

/// 📄 [SignInFormState] — Holds email/password + isValid/obscure flags
//
final class SignInFormState extends Equatable {
  ///---------------------------------------
  const SignInFormState({
    this.email = const EmailInputValidation.pure(),
    this.password = const PasswordInputValidation.pure(),
    this.isValid = false,
    this.isPasswordObscure = true,
  });

  final EmailInputValidation email;
  final PasswordInputValidation password;
  final bool isValid;
  final bool isPasswordObscure;

  SignInFormState _copyWith({
    EmailInputValidation? email,
    PasswordInputValidation? password,
    bool? isValid,
    bool? isPasswordObscure,
  }) {
    return SignInFormState(
      email: email ?? this.email,
      password: password ?? this.password,
      isValid: isValid ?? this.isValid,
      isPasswordObscure: isPasswordObscure ?? this.isPasswordObscure,
    );
  }

  /// ✅ Validate both fields via Formz
  SignInFormState validate() {
    final valid = Formz.validate([email, password]);
    return _copyWith(isValid: valid);
  }

  @override
  List<Object?> get props => [email, password, isValid, isPasswordObscure];

  //
}
