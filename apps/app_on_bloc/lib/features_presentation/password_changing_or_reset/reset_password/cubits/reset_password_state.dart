part of 'reset_password_input_form_fields_cubit.dart';

/// 📄 [ResetPasswordFormState] — Stores email field + isValid
final class ResetPasswordFormState extends Equatable {
  ///------------------------------------------
  const ResetPasswordFormState({
    this.email = const EmailInputValidation.pure(),
    this.isValid = false,
  });

  ///
  final EmailInputValidation email;

  ///
  final bool isValid;

  ResetPasswordFormState _copyWith({
    EmailInputValidation? email,
    bool? isValid,
  }) {
    return ResetPasswordFormState(
      email: email ?? this.email,
      isValid: isValid ?? this.isValid,
    );
  }

  /// ✅ Validates email via Formz
  ResetPasswordFormState validate() {
    final valid = Formz.validate([email]);
    return _copyWith(isValid: valid);
  }

  ///
  @override
  List<Object?> get props => [email, isValid];
  //
}
