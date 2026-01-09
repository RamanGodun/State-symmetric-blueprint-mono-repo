import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_core_modules/public_api/base_modules/forms.dart'
    show ChangePasswordFormState;
import 'package:shared_core_modules/shared_core_modules.dart'
    show ChangePasswordFormState;
import 'package:shared_utils/public_api/general_utils.dart'
    show AppDurations, Debouncer;

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

  @override
  ChangePasswordFormState build() {
    ref.onDispose(_debouncer.cancel); // 🧼 Cleanup memory leaks on dispose
    /// 🧱 Initializes the form with pure input values
    return const ChangePasswordFormState();
  }

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
