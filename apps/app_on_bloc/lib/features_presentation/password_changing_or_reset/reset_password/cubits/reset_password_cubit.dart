import 'package:core/core.dart';
import 'package:equatable/equatable.dart';
import 'package:features/features.dart' show PasswordRelatedUseCases;
import 'package:flutter/foundation.dart' show debugPrint;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';

part 'reset_password_state.dart';

/// 🔐 [ResetPasswordCubit] — Manages reset password logic, validation, submission.
/// ✅ Leverages [PasswordRelatedUseCases] injected via DI and uses declarative state updates.
//
final class ResetPasswordCubit extends Cubit<ResetPasswordState> {
  ///----------------------------------------------------------
  ResetPasswordCubit(this._useCases, this._validation)
    : super(const ResetPasswordState());
  //
  final PasswordRelatedUseCases _useCases;
  final FormValidationService _validation;
  final _debouncer = Debouncer(AppDurations.ms180);
  final _submitDebouncer = Debouncer(AppDurations.ms600);

  /// 📧 Handles email field changes with debounce and validation
  void onEmailChanged(String value) {
    _debouncer.run(() {
      final email = _validation.validateEmail(value.trim());
      emit(state.updateWith(email: email));
    });
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
      final result = await _useCases.callResetPassword(state.email.value);
      if (isClosed) return;
      //
      ResultHandler(result)
        ..onSuccess((_) {
          debugPrint('✅ Reset password link sent');
          emit(state._copyWith(status: FormzSubmissionStatus.success));
        })
        ..onFailure((f) {
          debugPrint('❌ Reset password failed: ${f.runtimeType}');
          emit(
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

  /// ♻️ Resets the full state to initial
  void resetState() {
    _cancelDebouncers();
    emit(const ResetPasswordState());
  }

  /// 🧼 Cleans up resources on close
  @override
  Future<void> close() {
    _cancelDebouncers();
    return super.close();
  }

  //
}
