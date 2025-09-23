import 'package:core/core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart' show Ref, StateNotifier;
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'input_fields_provider.g.dart';

/// 🧩 [ChangePasswordForm] — Manages the state of the change password form using [StateNotifier].
/// Handles input updates, validation, and visibility toggling for password field.
//
@riverpod
final class ChangePasswordForm extends _$ChangePasswordForm {
  ///-----------------------------------------------------
  //
  final _debouncer = Debouncer(AppDurations.ms150);

  /// 🧱 Initializes the form with pure input values
  @override
  ChangePasswordFormState build() => const ChangePasswordFormState();

  /// 🔒  Handles password input + sync password confirm (with validation, trimming and debounce)
  void onPasswordChanged(String value) {
    _debouncer.run(() => state = state.updateState(password: value));
  }

  /// 🔐  Handles confirm password input with validation, trimming and debounce
  void onConfirmPasswordChanged(String value) {
    _debouncer.run(() => state = state.updateState(confirmPassword: value));
  }

  /// 👁️ Toggles password field visibility
  void togglePasswordVisibility() {
    state = state.updateState(
      isPasswordObscure: !state.isPasswordObscure,
      revalidate: false,
    );
  }

  /// 👁️🔁 Toggles confirm password visibility
  void toggleConfirmPasswordVisibility() {
    state = state.updateState(
      isConfirmPasswordObscure: !state.isConfirmPasswordObscure,
      revalidate: false,
    );
  }

  /// ♻️🧼 Resets the entire form to initial state
  void resetState() => state = ChangePasswordFormState(epoch: state.epoch + 1);

  //
}

////
////

/// ✅ Returns form validity as primitive bool (minimal rebuilds)
//
@riverpod
bool changePasswordFormIsValid(Ref ref) =>
    ref.watch(changePasswordFormProvider.select((f) => f.isValid));
