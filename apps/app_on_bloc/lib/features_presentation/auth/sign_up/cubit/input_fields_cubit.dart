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
  SignUpFormFieldCubit(this._validation) : super(const SignUpFormState());
  //
  final FormValidationService _validation;
  final _debouncer = Debouncer(AppDurations.ms180);

  /// 👤 Handles (with trimming&debounce) name input
  void onNameChanged(String value) {
    _debouncer.run(() {
      final name = _validation.validateName(value.trim());
      emit(state._copyWith(name: name).validate());
    });
  }

  /// 📧  Handles (with trimming&debounce)  email input
  void onEmailChanged(String value) {
    _debouncer.run(() {
      final email = _validation.validateEmail(value.trim());
      emit(state._copyWith(email: email).validate());
    });
  }

  /// 🔒  Handles (with trimming&debounce)  password input + sync confirm
  void onPasswordChanged(String value) {
    _debouncer.run(() {
      final password = _validation.validatePassword(value.trim());
      final nextState = state
          ._copyWith(password: password)
          .updateConfirmPasswordValidation();
      emit(nextState);
    });
  }

  /// 🔐  Handles (with trimming&debounce) confirm password input and validates match
  void onConfirmPasswordChanged(String value) {
    _debouncer.run(() {
      final confirm = _validation.validateConfirmPassword(
        password: state.password.value,
        value: value.trim(),
      );
      emit(state._copyWith(confirmPassword: confirm).validate());
    });
  }

  /// 👁️ Toggles password field visibility
  void togglePasswordVisibility() =>
      emit(state._copyWith(isPasswordObscure: !state.isPasswordObscure));

  /// 👁️🔁 Toggles confirm password visibility
  void toggleConfirmPasswordVisibility() => emit(
    state._copyWith(isConfirmPasswordObscure: !state.isConfirmPasswordObscure),
  );

  /// 🧼 Full reset
  void resetState() => emit(SignUpFormState(epoch: state.epoch + 1));

  /// 🧼 Cleans up resources on close
  @override
  Future<void> close() {
    _debouncer.cancel();
    return super.close();
  }

  //
}
