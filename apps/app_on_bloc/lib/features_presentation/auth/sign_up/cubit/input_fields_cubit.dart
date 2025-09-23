//
// ignore_for_file: public_member_api_docs

import 'package:core/core.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';

part 'input_fields_state.dart';

/// 📝 [SignUpFormFieldCubit] — Owns name/email/password/confirm fields & validation
/// ✅ UI-only state: values, errors, visibility, isValid
//
final class SignUpFormFieldCubit extends Cubit<SignUpFormState> {
  ///----------------------------------------------------------
  SignUpFormFieldCubit() : super(const SignUpFormState());
  //
  final _debouncer = Debouncer(AppDurations.ms180);

  /// 👤 Handles name input with validation, trimming and debounce
  void onNameChanged(String value) => _debouncer.run(() {
    final name = NameInputValidation.dirty(value.trim());
    emit(state._copyWith(name: name).validate());
  });

  /// 📧  Handles email input with validation, trimming and debounce
  void onEmailChanged(String value) => _debouncer.run(() {
    final email = EmailInputValidation.dirty(value.trim());
    emit(state._copyWith(email: email).validate());
  });

  /// 🔒  Handles password input + sync password confirm (with validation, trimming and debounce)
  void onPasswordChanged(String value) => _debouncer.run(() {
    final password = PasswordInputValidation.dirty(value.trim());
    final confirmPassword = state.confirmPassword.updatePassword(value);
    emit(
      state
          ._copyWith(password: password, confirmPassword: confirmPassword)
          .validate(),
    );
  });

  /// 🔐  Handles confirm password input with validation, trimming and debounce
  void onConfirmPasswordChanged(String value) => _debouncer.run(() {
    final confirmPassword = ConfirmPasswordInputValidation.dirty(
      value: value.trim(),
      password: state.password.value,
    );
    emit(state._copyWith(confirmPassword: confirmPassword).validate());
  });

  /// 👁️ Toggles password field visibility
  void togglePasswordVisibility() =>
      emit(state._copyWith(isPasswordObscure: !state.isPasswordObscure));

  /// 👁️🔁 Toggles confirm password visibility
  void toggleConfirmPasswordVisibility() => emit(
    state._copyWith(isConfirmPasswordObscure: !state.isConfirmPasswordObscure),
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
