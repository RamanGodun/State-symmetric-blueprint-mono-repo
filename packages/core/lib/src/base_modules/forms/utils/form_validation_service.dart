import 'package:core/src/base_modules/forms/input_validation/validation_enums.dart';

/// 🧠 [FormValidationService] — Handles input field validation logic.
/// ✅ Keeps cubit clean (only state orchestration)
/// ✅ Centralizes and reuses validation logic across features
//
final class FormValidationService {
  ///----------------------------
  const FormValidationService();
  //

  /// 📧 Validates and returns updated [EmailInputValidation]
  EmailInputValidation validateEmail(String rawValue) {
    return EmailInputValidation.dirty(rawValue.trim());
  }

  /// 🔐 Validates and returns updated [PasswordInputValidation]
  PasswordInputValidation validatePassword(String rawValue) {
    return PasswordInputValidation.dirty(rawValue.trim());
  }

  /// 👤 Validates and returns updated [NameInputValidation]
  NameInputValidation validateName(String rawValue) {
    return NameInputValidation.dirty(rawValue.trim());
  }

  /// 🔁 Validates and returns [ConfirmPasswordInputValidation] based on [password]
  ConfirmPasswordInputValidation validateConfirmPassword({
    required String password,
    required String value,
  }) {
    return ConfirmPasswordInputValidation.dirty(
      password: password,
      value: value.trim(),
    );
  }

  /// 🔁 Syncs confirm password with updated 'password field'
  ConfirmPasswordInputValidation syncConfirmWithPassword({
    required ConfirmPasswordInputValidation currentConfirm,
    required String newPassword,
  }) {
    return currentConfirm.updatePassword(newPassword.trim());
  }

  //
}
