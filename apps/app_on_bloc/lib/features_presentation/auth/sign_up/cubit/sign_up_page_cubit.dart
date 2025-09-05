import 'dart:async';
import 'package:core/base_modules/errors_handling/core_of_module/core_utils/errors_observing/loggers/failure_logger_x.dart';
import 'package:core/base_modules/errors_handling/core_of_module/core_utils/result_handler.dart'
    show ResultHandler;
import 'package:core/base_modules/errors_handling/core_of_module/core_utils/specific_for_bloc/consumable.dart'
    show Consumable;
import 'package:core/base_modules/errors_handling/core_of_module/core_utils/specific_for_bloc/consumable_extensions.dart';
import 'package:core/base_modules/errors_handling/core_of_module/failure_entity.dart'
    show Failure;
import 'package:core/base_modules/form_fields/input_validation/validation_enums.dart'
    show
        ConfirmPasswordInputValidation,
        EmailInputValidation,
        NameInputValidation,
        PasswordInputValidation;
import 'package:core/base_modules/form_fields/input_validation/x_on_forms_submission_status.dart';
import 'package:core/base_modules/form_fields/utils/form_validation_service.dart';
import 'package:core/utils_shared/timing_control/debouncer.dart' show Debouncer;
import 'package:core/utils_shared/timing_control/timing_config.dart'
    show AppDurations;
import 'package:equatable/equatable.dart';
import 'package:features/features.dart' show SignUpUseCase;
import 'package:flutter/foundation.dart' show debugPrint;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';

part 'sign_up_page_state.dart';

/// 🧠 [SignUpCubit] — Handles logic for sign-up form: validation, debouncing, and submission.
/// ✅ Delegates actual sign-up to [SignUpUseCase]
//
final class SignUpCubit extends Cubit<SignUpState> {
  ///-------------------------------------------
  SignUpCubit(this._signUpUseCase, this._validation)
    : super(const SignUpState());
  //
  final SignUpUseCase _signUpUseCase;
  final FormValidationService _validation;
  final _debouncer = Debouncer(AppDurations.ms180);
  final _submitDebouncer = Debouncer(AppDurations.ms600);

  ///

  /// 👤 Handles name input with trimming & debounce
  void onNameChanged(String value) {
    _debouncer.run(() {
      final input = _validation.validateName(value.trim());
      emit(state.updateWith(name: input));
    });
  }

  /// 📧 Handles email input with debounce
  void onEmailChanged(String value) {
    _debouncer.run(() {
      final email = _validation.validateEmail(value.trim());
      emit(state.updateWith(email: email));
    });
  }

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

  /// 🚀/// ✅ Delegates actual sign-up to [SignUpUseCase], if form is valid
  Future<void> submit() async {
    if (!state.isValid || isClosed || state.status.isSubmissionInProgress) {
      return;
    }

    _submitDebouncer.run(() async {
      emit(state._copyWith(status: FormzSubmissionStatus.inProgress));

      final result = await _signUpUseCase(
        name: state.name.value,
        email: state.email.value,
        password: state.password.value,
      );

      if (isClosed) return;

      ResultHandler(result)
        ..onFailure((f) {
          emit(
            state._copyWith(
              status: FormzSubmissionStatus.failure,
              failure: f.asConsumable(),
            ),
          );
          f.log();
        })
        ..onSuccess((_) {
          emit(state._copyWith(status: FormzSubmissionStatus.success));
        })
        ..log();
    });

    /*
  ? Alternative syntax: classic fold version for direct mapping:
  result.fold(
    (f) => emit(
      state.copyWith(
        status: FormzSubmissionStatus.failure,
        failure: f.asConsumableUIModel(),
      ),
    ),
    (_) => emit(state.copyWith(status: FormzSubmissionStatus.success)),
  );
  */

    ///
  }

  /// 🧽 Resets the failure after it’s been consumed
  void clearFailure() => emit(state._copyWith());

  /// ♻️ Resets only submission status (e.g. after dialog)
  void resetStatus() {
    emit(state._copyWith(status: FormzSubmissionStatus.initial));
  }

  /// 🧼 Cancels all pending debounce operations
  void _cancelDebouncers() {
    _debouncer.cancel(); // 🧯 prevent delayed emit from old email input
    _submitDebouncer.cancel(); // 🧯 prevent accidental double submit
  }

  /// 🧼 Fully resets form fields & validation
  void resetState() {
    _cancelDebouncers();
    debugPrint('🧼 SignUpcubit → resetState()');
    emit(const SignUpState());
  }

  /// 🧼 Cleans up resources on close
  @override
  Future<void> close() {
    _cancelDebouncers();
    return super.close();
  }

  //
}
