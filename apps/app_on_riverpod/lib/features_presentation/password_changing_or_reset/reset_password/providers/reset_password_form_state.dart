import 'package:core/base_modules/forms.dart' show EmailInputValidation;
import 'package:equatable/equatable.dart' show Equatable;
import 'package:formz/formz.dart';

/// 📦 [ResetPasswordFormState] — immutable state of the reset password form
/// 🧠 Tracks the email input and overall form validity
//
final class ResetPasswordFormState extends Equatable {
  /// ----------------------------------------------
  /// Constructor with default pure input
  const ResetPasswordFormState({
    this.email = const EmailInputValidation.pure(),
    this.isValid = false,
  });

  ///
  final EmailInputValidation email;

  ///
  final bool isValid;

  /// Copy method for updating fields and validity
  ResetPasswordFormState copyWith({
    EmailInputValidation? email,
    bool? isValid,
  }) {
    return ResetPasswordFormState(
      email: email ?? this.email,
      isValid: isValid ?? this.isValid,
    );
  }

  /// Validates the email input
  ResetPasswordFormState validate() {
    final valid = Formz.validate([email]);
    return copyWith(isValid: valid);
  }

  ///
  @override
  List<Object> get props => [email, isValid];

  //
}
