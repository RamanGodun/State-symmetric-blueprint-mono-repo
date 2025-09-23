//
// ignore_for_file: public_member_api_docs
import 'package:core/core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// 📝 [SignUpFormFieldCubit] — Owns name/email/password/confirm fields & validation
/// ✅ UI-only state: values, errors, visibility, isValid
//
final class SignUpFormFieldCubit extends Cubit<SignUpFormState> {
  ///----------------------------------------------------------
  SignUpFormFieldCubit() : super(const SignUpFormState());
  //
  final _debouncer = Debouncer(AppDurations.ms180);

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

  /// 🧼 Full state reset
  void resetState() => emit(SignUpFormState(epoch: state.epoch + 1));

  /// 🧼 Cleans up resources on close
  @override
  Future<void> close() {
    _debouncer.cancel();
    return super.close();
  }

  //
}
