import 'package:app_on_riverpod/features_presentation/auth/sign_up/providers/sign_up_form_state.dart';
import 'package:core/base_modules/forms.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart' show StateNotifier;
import 'package:hooks_riverpod/hooks_riverpod.dart' show StateNotifier;
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'sign_up_form_provider.g.dart';

/// 🧩 [SignUpForm] — Manages the state of the sign-up form using [StateNotifier].
/// Handles input updates, validation, and visibility toggling for password fields.
//
@riverpod
final class SignUpForm extends _$SignUpForm {
  ///------------------------------------

  /// Initializes the form state with default (pure) values.
  @override
  SignUpFormState build() => const SignUpFormState();

  /// Updates the name field with a new value and triggers validation.
  void nameChanged(String value) {
    final name = NameInputValidation.dirty(value);
    state = state.copyWith(name: name).validate();
  }

  /// Updates the email field with a new value and triggers validation.
  void emailChanged(String value) {
    final email = EmailInputValidation.dirty(value);
    state = state.copyWith(email: email).validate();
  }

  /// Updates the password field and triggers revalidation of confirm password.
  void passwordChanged(String value) {
    final password = PasswordInputValidation.dirty(value);
    final confirmPassword = state.confirmPassword.updatePassword(value);
    state = state
        .copyWith(password: password, confirmPassword: confirmPassword)
        .validate();
  }

  /// Updates the confirm password field and revalidates.
  void confirmPasswordChanged(String value) {
    final confirmPassword = ConfirmPasswordInputValidation.dirty(
      value: value,
      password: state.password.value,
    );
    state = state.copyWith(confirmPassword: confirmPassword).validate();
  }

  /// Toggles password visibility.
  void togglePasswordVisibility() {
    state = state.copyWith(isPasswordObscure: !state.isPasswordObscure);
  }

  /// Toggles confirm password visibility.
  void toggleConfirmPasswordVisibility() {
    state = state.copyWith(
      isConfirmPasswordObscure: !state.isConfirmPasswordObscure,
    );
  }

  /// Resets form to initial pure state.
  void reset() => state = const SignUpFormState();

  //
}
