part of '../validation_enums.dart';

/// 📧 [EmailInputValidation] — Formz input for validating user email.
/// Checks for non-empty input and valid email format.
//
final class EmailInputValidation
    extends FormzInput<String, EmailValidationError> {
  ///--------------------------------------------------------------------------
  const EmailInputValidation.pure() : super.pure('');

  ///
  const EmailInputValidation.dirty([super.value = '']) : super.dirty();

  /// 🧪 [validator] — core validation logic for email input.
  ///    Called internally by Formz every time the input changes,
  @override
  EmailValidationError? validator(String value) {
    final trimmed = value.trim();
    if (trimmed.isEmpty) return EmailValidationError.empty;
    if (!isEmail(trimmed)) return EmailValidationError.invalid;
    return null;
  }

  /// 🧼 Converts enum to a localizable message key
  String? get errorKey => switch (error) {
    EmailValidationError.empty => CoreLocaleKeys.form_email_is_empty,
    EmailValidationError.invalid => CoreLocaleKeys.form_email_is_invalid,
    _ => null,
  };

  /// 🔁 [uiErrorKey] — Used by widgets to show validation message or nothing
  String? get uiErrorKey => isPure || isValid ? null : errorKey;

  //
}
