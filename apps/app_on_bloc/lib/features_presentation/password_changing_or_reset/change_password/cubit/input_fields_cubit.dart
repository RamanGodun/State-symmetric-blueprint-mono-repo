//
// ignore_for_file: public_member_api_docs

import 'package:core/core.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';

part 'input_fields_state.dart';

/// 🔐 [ChangePasswordFormFieldsCubit] —
//
final class ChangePasswordFormFieldsCubit
    extends Cubit<ChangePasswordFormState> {
  ///-----------------------------------------------------------
  ChangePasswordFormFieldsCubit() : super(const ChangePasswordFormState());
  //
  final _debouncer = Debouncer(AppDurations.ms150);

  ////

  /// 🔒 Handles password input and updates confirm sync
  void onPasswordChanged(String value) {
    _debouncer.run(() {
      final password = PasswordInputValidation.dirty(value.trim());
      final confirmPassword = state.confirmPassword.updatePassword(value);
      emit(
        state
            ._copyWith(password: password, confirmPassword: confirmPassword)
            .validate(),
      );
    });
  }

  /// 🔐 Handles confirm password input and validates match
  void onConfirmPasswordChanged(String value) {
    _debouncer.run(() {
      final confirmPassword = ConfirmPasswordInputValidation.dirty(
        value: value.trim(),
        password: state.password.value,
      );
      emit(state._copyWith(confirmPassword: confirmPassword).validate());
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
  void resetState() => emit(ChangePasswordFormState(epoch: state.epoch + 1));

  /// 🧼 Cleanup
  @override
  Future<void> close() {
    _cancelDebouncers();
    return super.close();
  }

  //
}
