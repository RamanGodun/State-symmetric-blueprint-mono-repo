import 'package:app_on_riverpod/features_presentation/auth/sign_in/providers/input_form_fields_state.dart';
import 'package:core/base_modules/forms.dart'
    show EmailInputValidation, PasswordInputValidation;
import 'package:core/utils.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart' show Ref, StateNotifier;
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'input_form_fields_provider.g.dart';

/// 🧩 [SignInForm] — Manages the state of the sign-in form using [StateNotifier].
/// Handles input updates, validation, and visibility toggling for password field.
//
@riverpod
final class SignInForm extends _$SignInForm {
  ///-------------------------------------

  final _inputDebouncer = Debouncer(AppDurations.ms20);

  /// Initializes the form state with default (pure) values.
  @override
  SignInFormState build() => const SignInFormState();

  /// Updates the email field with a new value and triggers validation.
  void emailChanged(String value) {
    _inputDebouncer.run(() {
      final email = EmailInputValidation.dirty(value);
      state = state.copyWith(email: email).validate();
    });
  }

  /// Updates the password field with a new value and triggers validation.
  void passwordChanged(String value) {
    _inputDebouncer.run(() {
      final password = PasswordInputValidation.dirty(value);
      state = state.copyWith(password: password).validate();
    });
  }

  /// Toggles the visibility of the password field (obscure text).
  void togglePasswordVisibility() {
    state = state.copyWith(isPasswordObscure: !state.isPasswordObscure);
  }

  /// Resets the form state to its initial (pure) values.
  void resetState() => state = SignInFormState(epoch: state.epoch + 1);

  //
}

////
////

////
////

/// ✅ Returns form validity as primitive bool (minimal rebuilds)
//
@riverpod
bool signInFormIsValid(Ref ref) =>
    ref.watch(signInFormProvider.select((f) => f.isValid));
