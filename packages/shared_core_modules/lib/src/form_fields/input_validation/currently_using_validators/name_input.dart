part of '../validation_enums.dart';

/// 👤 [NameInputValidation] — Formz input for validating user's full name.
/// Ensures non-empty input and minimum character length.
//
final class NameInputValidation
    extends FormzInput<String, NameValidationError> {
  ///---------------------------------------------------
  //
  const NameInputValidation.pure() : super.pure('');
  //
  ///
  const NameInputValidation.dirty([super.value = '']) : super.dirty();
  //

  /// 🧪 [validator] — core validation logic for name input.
  ///    Called internally by Formz every time the input changes,
  @override
  NameValidationError? validator(String value) {
    final trimmed = value.trim();
    if (trimmed.isEmpty) return NameValidationError.empty;
    if (trimmed.length < 3) return NameValidationError.tooShort;
    return null;
  }

  /// 🧼 [errorKey] — Converts enum error to user-friendly message
  String? get errorKey => switch (error) {
    NameValidationError.empty => CoreLocaleKeys.form_name_is_empty,
    NameValidationError.tooShort => CoreLocaleKeys.form_name_is_too_short,
    _ => null,
  };

  /// 🔁 [uiErrorKey] — Used by widgets to show validation message or nothing
  String? get uiErrorKey => isPure || isValid ? null : errorKey;

  //
}
