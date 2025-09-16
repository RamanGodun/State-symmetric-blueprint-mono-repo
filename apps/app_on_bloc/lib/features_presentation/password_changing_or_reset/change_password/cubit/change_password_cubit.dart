import 'package:core/core.dart';
import 'package:equatable/equatable.dart';
import 'package:features/features.dart' show PasswordRelatedUseCases;
import 'package:flutter/foundation.dart' show debugPrint;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';

part 'change_password_state.dart';

/// 🔐 [ChangePasswordCubit] — Manages reset password logic, validation, submission.
/// ✅ Leverages [PasswordRelatedUseCases] injected via DI and uses declarative state updates.
//
final class ChangePasswordCubit extends Cubit<ChangePasswordState> {
  ///-----------------------------------------------------------
  ChangePasswordCubit(this._useCases, this._validation)
    : super(const ChangePasswordState());
  //
  final PasswordRelatedUseCases _useCases;
  final FormValidationService _validation;
  final _debouncer = Debouncer(AppDurations.ms180);
  final _submitDebouncer = Debouncer(AppDurations.ms600);

  /// 🔒 Handles password input and updates confirm sync
  void onPasswordChanged(String value) {
    final password = _validation.validatePassword(value.trim());
    final confirm = state.confirmPassword.updatePassword(password.value);
    emit(state.updateWith(password: password, confirmPassword: confirm));
  }

  /// 🔐 Handles confirm password input and validates match
  void onConfirmPasswordChanged(String value) {
    final input = _validation.validateConfirmPassword(
      password: state.password.value,
      value: value,
    );
    emit(state.updateWith(confirmPassword: input));
  }

  ///

  /// 🚀 Submits reset password request if form is valid
  Future<void> submit() async {
    if (!state.isValid || isClosed || state.status.isSubmissionInProgress) {
      return;
    }
    //
    _submitDebouncer.run(() async {
      emit(state._copyWith(status: FormzSubmissionStatus.inProgress));
      //
      final result = await _useCases.callChangePassword(
        state.password.value,
      );
      if (isClosed) return;
      //
      ResultHandler(result)
        ..onSuccess((_) {
          debugPrint('✅ Password changed successfully');
          emit(state._copyWith(status: FormzSubmissionStatus.success));
        })
        ..onFailure((f) {
          debugPrint('❌ Password change failed: ${f.runtimeType}');
          (f is RequiresRecentLoginFirebaseFailureType)
              ? emit(ChangePasswordRequiresReauth(f.asConsumable()))
              : emit(
                  state._copyWith(
                    status: FormzSubmissionStatus.failure,
                    failure: f.asConsumable(),
                  ),
                );
          f.log();
        })
        ..log();
    });
  }

  /// 👁️ Toggles password field visibility
  void togglePasswordVisibility() {
    emit(state._copyWith(isPasswordObscure: !state.isPasswordObscure));
  }

  /// 👁️🔁 Toggles confirm password visibility
  void toggleConfirmPasswordVisibility() {
    emit(
      state._copyWith(
        isConfirmPasswordObscure: !state.isConfirmPasswordObscure,
      ),
    );
  }

  ///

  /// 🧽 Resets the failure after it’s been consumed
  void clearFailure() => emit(state._copyWith());

  /// 🔄 Resets only the submission status (used after dialogs)
  void resetStatus() {
    emit(state._copyWith(status: FormzSubmissionStatus.initial));
  }

  /// 🧼 Cancels all pending debounce operations
  void _cancelDebouncers() {
    _debouncer.cancel(); // 🧯 prevent delayed emit from old email input
    _submitDebouncer.cancel(); // 🧯 prevent accidental double submit
  }

  /// 🧼 Resets the entire form to initial state
  void resetState() {
    _cancelDebouncers();
    emit(const ChangePasswordState());
  }

  /// 🧼 Cleans up resources on close
  @override
  Future<void> close() {
    _cancelDebouncers();
    return super.close();
  }

  //
}
