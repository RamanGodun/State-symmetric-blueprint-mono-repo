//
// ignore_for_file: public_member_api_docs
import 'package:core/base_modules/form_fields/input_validation/validation_enums.dart'
    show EmailInputValidation, PasswordInputValidation;
import 'package:equatable/equatable.dart' show Equatable;
import 'package:formz/formz.dart' show Formz;

/// 📦 [SignInFormState] — Immutable model representing the state of the sign-in form.
/// Tracks field values, password visibility, and overall form validity.
//
final class SignInFormState extends Equatable {
  ///---------------------------------------
  /// Creates a new [SignInFormState] instance.
  const SignInFormState({
    this.email = const EmailInputValidation.pure(),
    this.password = const PasswordInputValidation.pure(),
    this.isPasswordObscure = true,
    this.isValid = false,
  });

  final EmailInputValidation email;
  final PasswordInputValidation password;
  final bool isPasswordObscure;
  final bool isValid;

  /// Returns a new copy of this state with updated fields.
  SignInFormState copyWith({
    EmailInputValidation? email,
    PasswordInputValidation? password,
    bool? isPasswordObscure,
    bool? isValid,
  }) {
    return SignInFormState(
      email: email ?? this.email,
      password: password ?? this.password,
      isPasswordObscure: isPasswordObscure ?? this.isPasswordObscure,
      isValid: isValid ?? this.isValid,
    );
  }

  /// Validates all input fields and updates the `isValid` flag accordingly.
  SignInFormState validate() {
    final valid = Formz.validate([email, password]);
    return copyWith(isValid: valid);
  }

  ///
  @override
  List<Object> get props => [email, password, isPasswordObscure, isValid];

  //
}
