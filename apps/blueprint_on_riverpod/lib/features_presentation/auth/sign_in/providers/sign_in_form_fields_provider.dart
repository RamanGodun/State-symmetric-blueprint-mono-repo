import 'package:blueprint_on_riverpod/features_presentation/auth/sign_in/providers/sign_in_form_fields_state.dart';
import 'package:core/base_modules/form_fields/input_validation/validation_enums.dart'
    show EmailInputValidation, PasswordInputValidation;
import 'package:flutter_riverpod/flutter_riverpod.dart' show StateNotifier;
import 'package:hooks_riverpod/hooks_riverpod.dart' show StateNotifier;
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'sign_in_form_fields_provider.g.dart';

/// 🧩 [SignInForm] — Manages the state of the sign-in form using [StateNotifier].
/// Handles input updates, validation, and visibility toggling for password field.
//
@riverpod
final class SignInForm extends _$SignInForm {
  ///-------------------------------------

  /// Initializes the form state with default (pure) values.
  @override
  SignInFormState build() => const SignInFormState();

  /// Updates the email field with a new value and triggers validation.
  void emailChanged(String value) {
    final email = EmailInputValidation.dirty(value);
    state = state.copyWith(email: email).validate();
  }

  /// Updates the password field with a new value and triggers validation.
  void passwordChanged(String value) {
    final password = PasswordInputValidation.dirty(value);
    state = state.copyWith(password: password).validate();
  }

  /// Toggles the visibility of the password field (obscure text).
  void togglePasswordVisibility() {
    state = state.copyWith(isPasswordObscure: !state.isPasswordObscure);
  }

  /// Resets the form state to its initial (pure) values.
  void reset() {
    state = const SignInFormState();
  }

  //
}
