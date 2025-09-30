import 'package:core/public_api/core.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'input_fields_provider.g.dart';

/// 📝 [ChangePasswordForm] — Handles change-password form fields & validation.
/// 🧰 Uses shared [ChangePasswordFormState].
/// 🔁 Symmetric to BLoC 'ChangePasswordFormFieldsCubit' (Form only).
//
@riverpod
final class ChangePasswordForm extends _$ChangePasswordForm {
  ///-----------------------------------------------------
  //
  // For anti double-tap protection on input updates.
  final _debouncer = Debouncer(AppDurations.ms100);

  /// 🧱 Initializes the form with pure input values
  @override
  ChangePasswordFormState build() => const ChangePasswordFormState();

  ////

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

  ////

  /// ♻️🧼 Resets the entire form to initial state
  void resetState() => state = ChangePasswordFormState(epoch: state.epoch + 1);

  //
}
