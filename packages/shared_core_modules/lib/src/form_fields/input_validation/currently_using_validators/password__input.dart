part of '../validation_enums.dart';

/// 🔒 [PasswordInputValidation] — Validates presence and minimum password length.
//
final class PasswordInputValidation
    extends FormzInput<String, PasswordValidationError> {
  ///------------------------------------------------------------------------
  //
  const PasswordInputValidation.pure() : super.pure('');
  //
  ///
  const PasswordInputValidation.dirty([super.value = '']) : super.dirty();
  //

  /// 🧪 [validator] — core validation logic for password input.
  ///    Called internally by Formz every time the input changes,
  @override
  PasswordValidationError? validator(String value) {
    final trimmed = value.trim();
    if (trimmed.isEmpty) return PasswordValidationError.empty;
    if (trimmed.length < 6) return PasswordValidationError.tooShort;
    return null;
  }

  /// 🧼 Converts enum to a localizable message key
  String? get errorKey => switch (error) {
    PasswordValidationError.empty => CoreLocaleKeys.form_password_required,
    PasswordValidationError.tooShort => CoreLocaleKeys.form_password_too_short,
    _ => null,
  };

  /// 🔁 Used by UI widgets (returns key only when invalid & dirty)
  String? get uiErrorKey => isPure || isValid ? null : errorKey;

  //
}
