import 'package:app_on_riverpod/features_presentation/auth/sign_up/providers/input_form_fields_state.dart';
import 'package:core/core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'input_form_fields_provider.g.dart';

/// 🧩 [SignUpForm] — Manages the state of the sign-up form using [StateNotifier].
/// Handles input updates, validation, and visibility toggling for password fields.
//
@riverpod
final class SignUpForm extends _$SignUpForm {
  ///------------------------------------
  //
  final _debouncer = Debouncer(AppDurations.ms180);

  /// Initializes the form state with default (pure) values.
  @override
  SignUpFormState build() => const SignUpFormState();

  /// 👤 Handles name input with validation, trimming and debounce
  void nameChanged(String value) => _debouncer.run(() {
    final name = NameInputValidation.dirty(value.trim());
    state = state.copyWith(name: name).validate();
  });

  /// 📧  Handles email input with validation, trimming and debounce
  void emailChanged(String value) => _debouncer.run(() {
    final email = EmailInputValidation.dirty(value.trim());
    state = state.copyWith(email: email).validate();
  });

  /// 🔒  Handles password input + sync password confirm (with validation, trimming and debounce)
  void passwordChanged(String value) => _debouncer.run(() {
    final password = PasswordInputValidation.dirty(value.trim());
    final confirmPassword = state.confirmPassword.updatePassword(value);
    state = state
        .copyWith(password: password, confirmPassword: confirmPassword)
        .validate();
  });

  /// 🔐  Handles confirm password input with validation, trimming and debounce
  void confirmPasswordChanged(String value) => _debouncer.run(() {
    final confirmPassword = ConfirmPasswordInputValidation.dirty(
      value: value.trim(),
      password: state.password.value,
    );
    state = state.copyWith(confirmPassword: confirmPassword).validate();
  });

  /// 👁️ Toggles password field visibility
  void togglePasswordVisibility() {
    state = state.copyWith(isPasswordObscure: !state.isPasswordObscure);
  }

  /// 👁️🔁 Toggles confirm password visibility
  void toggleConfirmPasswordVisibility() {
    state = state.copyWith(
      isConfirmPasswordObscure: !state.isConfirmPasswordObscure,
    );
  }

  /// 🧼 Full state reset
  void resetState() => state = SignUpFormState(epoch: state.epoch + 1);

  //
}

////
////

/// ✅ Returns form validity as primitive bool (minimal rebuilds)
//
@riverpod
bool signUpFormIsValid(Ref ref) =>
    ref.watch(signUpFormProvider.select((f) => f.isValid));
