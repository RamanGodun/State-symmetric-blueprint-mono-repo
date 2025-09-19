//
// ignore_for_file: public_member_api_docs

part of 'input_fields_cubit.dart';

/// 📄 [SignUpFormState] — Holds fields + visibility + isValid
/// ✅ Centralized state object for validation
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
  });

  final NameInputValidation name;
  final EmailInputValidation email;
  final PasswordInputValidation password;
  final ConfirmPasswordInputValidation confirmPassword;
  final bool isValid;
  final bool isPasswordObscure;
  final bool isConfirmPasswordObscure;

  /// 🧱 Clones current state with optional overrides
  SignUpFormState _copyWith({
    NameInputValidation? name,
    EmailInputValidation? email,
    PasswordInputValidation? password,
    ConfirmPasswordInputValidation? confirmPassword,
    bool? isValid,
    bool? isPasswordObscure,
    bool? isConfirmPasswordObscure,
  }) {
    return SignUpFormState(
      name: name ?? this.name,
      email: email ?? this.email,
      password: password ?? this.password,
      confirmPassword: confirmPassword ?? this.confirmPassword,
      isValid: isValid ?? this.isValid,
      isPasswordObscure: isPasswordObscure ?? this.isPasswordObscure,
      isConfirmPasswordObscure:
          isConfirmPasswordObscure ?? this.isConfirmPasswordObscure,
    );
  }

  /// ✅ Validate all fields via Formz
  SignUpFormState validate() {
    final valid = Formz.validate([name, email, password, confirmPassword]);
    return _copyWith(isValid: valid);
  }

  ///
  @override
  List<Object?> get props => [
    name,
    email,
    password,
    confirmPassword,
    isValid,
    isPasswordObscure,
    isConfirmPasswordObscure,
  ];
  //
}
