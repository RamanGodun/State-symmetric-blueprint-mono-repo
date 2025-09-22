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
    this.epoch = 0,
  });

  final NameInputValidation name;
  final EmailInputValidation email;
  final PasswordInputValidation password;
  final ConfirmPasswordInputValidation confirmPassword;
  final bool isValid;
  final bool isPasswordObscure;
  final bool isConfirmPasswordObscure;
  final int epoch;

  /// 🧱 Clones current state with optional overrides
  SignUpFormState _copyWith({
    NameInputValidation? name,
    EmailInputValidation? email,
    PasswordInputValidation? password,
    ConfirmPasswordInputValidation? confirmPassword,
    bool? isValid,
    bool? isPasswordObscure,
    bool? isConfirmPasswordObscure,
    int? epoch,
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
      epoch: epoch ?? this.epoch,
    );
  }

  /// ✅ Validate all fields via Formz
  SignUpFormState validate() {
    final valid = Formz.validate([name, email, password, confirmPassword]);
    return _copyWith(isValid: valid);
  }

  /// ➞ Returns a new state with updated values and revalidated form
  /// 📦 Supports field updates and UI controls like visibility or submission status
  SignUpFormState updateConfirmPasswordValidation() {
    final updatedConfirm = confirmPassword.updatePassword(password.value);
    final valid = Formz.validate([password, updatedConfirm]);
    return _copyWith(confirmPassword: updatedConfirm, isValid: valid);
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
    epoch,
  ];
  //
}
