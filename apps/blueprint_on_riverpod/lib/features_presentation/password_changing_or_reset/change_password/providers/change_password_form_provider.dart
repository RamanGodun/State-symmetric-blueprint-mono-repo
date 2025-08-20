import 'package:blueprint_on_riverpod/features_presentation/password_changing_or_reset/change_password/providers/change_password_form_state.dart';
import 'package:core/base_modules/form_fields/input_validation/validation_enums.dart'
    show ConfirmPasswordInputValidation, PasswordInputValidation;
import 'package:flutter_riverpod/flutter_riverpod.dart' show StateNotifier;
import 'package:hooks_riverpod/hooks_riverpod.dart' show StateNotifier;
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'change_password_form_provider.g.dart';

/// 🧩 [ChangePasswordForm] — Manages the state of the change password form using [StateNotifier].
/// Handles input updates, validation, and visibility toggling for password field.
//
@riverpod
final class ChangePasswordForm extends _$ChangePasswordForm {
  ///----------------------------------------------------

  /// 🧱 Initializes the form with pure input values
  @override
  ChangePasswordFormState build() => const ChangePasswordFormState();

  /// 📝 Updates 'password' field and revalidates 'confirmPassword' field
  void passwordChanged(String value) {
    final pwd = PasswordInputValidation.dirty(value);
    state = state.copyWith(password: pwd).updateConfirmPasswordValidation();
  }

  /// 📝 Updates 'confirmPassword' field and recalculates 'isValid'
  void confirmPasswordChanged(String value) {
    final confirm = ConfirmPasswordInputValidation.dirty(
      value: value,
      password: state.password.value,
    );
    state = state.copyWith(confirmPassword: confirm).validate();
  }

  /// 👁️ Toggles password field visibility
  void togglePasswordVisibility() =>
      state = state.copyWith(isPasswordObscure: !state.isPasswordObscure);

  /// 👁️ Toggles confirm password field visibility
  void toggleConfirmPasswordVisibility() => state = state.copyWith(
    isConfirmPasswordObscure: !state.isConfirmPasswordObscure,
  );

  /// ✅ Triggers validation manually (e.g., before submit)
  void validate() {
    state = state.validate();
  }

  /// ♻️ Resets the form to initial state
  void reset() => state = const ChangePasswordFormState();

  //
}
