import 'package:core/core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// 📝 [SignUpFormFieldCubit] — Handles sign-up form fields & validation (UI-only).
/// 🧰 Uses shared [SignUpFormState].
/// 🔁 Symmetric to Riverpod 'signUpFormProvider' (Form only).
//
final class SignUpFormFieldCubit extends Cubit<SignUpFormState> {
  ///--------------------------------------------------------
  SignUpFormFieldCubit() : super(const SignUpFormState());
  //
  // For anti input-spam / micro debouncing of validation (smooth UX, fewer rebuilds).
  final _debouncer = Debouncer(AppDurations.ms100);

  ////

  /// 👤 Handles name input with validation, trimming and debounce
  void onNameChanged(String value) {
    _debouncer.run(() => emit(state.updateState(name: value)));
  }

  /// 📧  Handles email input with validation, trimming and debounce
  void onEmailChanged(String value) {
    _debouncer.run(() => emit(state.updateState(email: value)));
  }

  /// 🔒  Handles password input + sync password confirm (with validation, trimming and debounce)
  void onPasswordChanged(String value) {
    _debouncer.run(() => emit(state.updateState(password: value)));
  }

  /// 🔐  Handles confirm password input with validation, trimming and debounce
  void onConfirmPasswordChanged(String value) {
    _debouncer.run(() => emit(state.updateState(confirmPassword: value)));
  }

  /// 👁️ Toggles password field visibility
  void togglePasswordVisibility() => emit(
    state.updateState(
      isPasswordObscure: !state.isPasswordObscure,
      revalidate: false,
    ),
  );

  /// 👁️🔁 Toggles confirm password visibility
  void toggleConfirmPasswordVisibility() => emit(
    state.updateState(
      isConfirmPasswordObscure: !state.isConfirmPasswordObscure,
      revalidate: false,
    ),
  );

  ////

  /// ♻️ Full state reset (bump epoch to force field rebuilds)
  void resetState() => emit(SignUpFormState(epoch: state.epoch + 1));

  /// 🧼 Cleans up resources on close
  @override
  Future<void> close() {
    _debouncer.cancel();
    return super.close();
  }

  //
}
