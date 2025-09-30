import 'package:core/public_api/core.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'input_form_fields_provider.g.dart';

/// 📝 [signUpFormProvider] — Handles sign-up form fields & validation (StateNotifier).
/// 🧰 Uses shared [SignUpFormState].
/// 🔁 Symmetric to BLoC 'SignUpFormFieldCubit' (Form only).
//
@riverpod
final class SignUpForm extends _$SignUpForm {
  ///-------------------------------------
  //
  /// For anti input-spam / micro debouncing of validation (smooth UX, fewer rebuilds).
  final _debouncer = Debouncer(AppDurations.ms100);

  /// Initializes the form state with default (pure) values.
  @override
  SignUpFormState build() => const SignUpFormState();

  ////

  /// 👤 Handles name input with validation, trimming and debounce
  void onNameChanged(String value) {
    _debouncer.run(() => state = state.updateState(name: value));
  }

  /// 📧  Handles email input with validation, trimming and debounce
  void onEmailChanged(String value) {
    _debouncer.run(() => state = state.updateState(email: value));
  }

  /// 🔒  Handles password input + sync password confirm (with validation, trimming and debounce)
  void onPasswordChanged(String value) {
    _debouncer.run(() => state = state.updateState(password: value));
  }

  /// 🔐  Handles confirm password input with validation, trimming and debounce
  void onConfirmPasswordChanged(String value) {
    _debouncer.run(() => state = state.updateState(confirmPassword: value));
  }

  /// 👁️ Toggles password field visibility
  void togglePasswordVisibility() => state = state.updateState(
    isPasswordObscure: !state.isPasswordObscure,
    revalidate: false,
  );

  /// 👁️🔁 Toggles confirm-password field visibility
  void toggleConfirmPasswordVisibility() => state = state.updateState(
    isConfirmPasswordObscure: !state.isConfirmPasswordObscure,
    revalidate: false,
  );

  ////

  /// ♻️ Full state reset (bump epoch to force field rebuilds)
  void resetState() => state = SignUpFormState(epoch: state.epoch + 1);

  //
}
