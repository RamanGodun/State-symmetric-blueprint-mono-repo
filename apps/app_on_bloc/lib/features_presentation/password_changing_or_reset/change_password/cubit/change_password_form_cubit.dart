//
// ignore_for_file: public_member_api_docs

import 'package:core/core.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';

part 'change_password_form_state.dart';

/// 🔐 [ChangePasswordFormCubit] —
//
final class ChangePasswordFormCubit extends Cubit<ChangePasswordFormState> {
  ///-----------------------------------------------------------
  ChangePasswordFormCubit(this._validation)
    : super(const ChangePasswordFormState());

  final FormValidationService _validation;
  final _debouncer = Debouncer(AppDurations.ms150);

  /// 🔒 Handles password input and updates confirm sync
  void onPasswordChanged(String value) {
    _debouncer.run(() {
      final password = _validation.validatePassword(value.trim());
      final next = state
          ._copyWith(password: password)
          .updateConfirmPasswordValidation();
      emit(next);
    });
  }

  /// 🔐 Handles confirm password input and validates match
  void onConfirmPasswordChanged(String value) {
    _debouncer.run(() {
      final confirm = _validation.validateConfirmPassword(
        password: state.password.value,
        value: value,
      );
      emit(state._copyWith(confirmPassword: confirm).validate());
    });
  }

  /// 👁️ Toggles password field visibility
  void togglePasswordVisibility() => emit(
    state._copyWith(isPasswordObscure: !state.isPasswordObscure),
  );

  /// 👁️🔁 Toggles confirm password visibility
  void toggleConfirmPasswordVisibility() => emit(
    state._copyWith(isConfirmPasswordObscure: !state.isConfirmPasswordObscure),
  );

  ////

  /// 🧼 Cancels all pending debounce operations
  void _cancelDebouncers() {
    _debouncer
        .cancel(); // 🧯 prevent delayed emit from old email input // 🧯 prevent accidental double submit
  }

  /// 🧼 Resets the entire form to initial state
  void resetState() => emit(const ChangePasswordFormState());

  ///

  @override
  Future<void> close() {
    _cancelDebouncers();
    return super.close();
  }
}
