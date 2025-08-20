import 'dart:async';
import 'package:blueprint_on_qubit/features/auth/domain/use_cases/sign_in.dart';
import 'package:core/base_modules/errors_handling/core_of_module/core_utils/errors_observing/loggers/failure_logger_x.dart';
import 'package:core/base_modules/errors_handling/core_of_module/core_utils/result_handler.dart'
    show ResultHandler;
import 'package:core/base_modules/errors_handling/core_of_module/core_utils/specific_for_bloc/consumable.dart'
    show Consumable;
import 'package:core/base_modules/errors_handling/core_of_module/core_utils/specific_for_bloc/consumable_extensions.dart';
import 'package:core/base_modules/errors_handling/core_of_module/failure_entity.dart'
    show Failure;
import 'package:core/base_modules/form_fields/input_validation/validation_enums.dart'
    show EmailInputValidation, PasswordInputValidation;
import 'package:core/base_modules/form_fields/utils/form_validation_service.dart'
    show FormValidationService;
import 'package:core/utils_shared/timing_control/debouncer.dart' show Debouncer;
import 'package:core/utils_shared/timing_control/timing_config.dart'
    show AppDurations;
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';

part 'sign_in_page_state.dart';

/// 🔐 [SignInCubit] — Manages Sign In logic, validation, submission.
/// ✅ Leverages via DI [FormValidationService] and uses DSL-like result handler.
//
final class SignInCubit extends Cubit<SignInPageState> {
  ///-----------------------------------------------
  SignInCubit(this._signInUseCase, this._validationService)
    : super(const SignInPageState());
  //
  final SignInUseCase _signInUseCase;
  final FormValidationService _validationService;
  final _debouncer = Debouncer(AppDurations.ms180);
  final _submitDebouncer = Debouncer(AppDurations.ms600);

  ///

  /// 📧 Handles email field changes with debounce and validation
  void emailChanged(String value) {
    _debouncer.run(() {
      final email = _validationService.validateEmail(value.trim());
      emit(state.updateWith(email: email));
    });
  }

  /// 🔒 Handles password field changes and form revalidation
  void passwordChanged(String value) {
    final password = _validationService.validatePassword(value.trim());
    emit(state.updateWith(password: password));
  }

  /// 👁️ Toggles password visibility flag
  void togglePasswordVisibility() {
    emit(state._copyWith(isPasswordObscure: !state.isPasswordObscure));
  }

  /// 🚀 Triggers form submission
  Future<void> submit() async {
    if (!state.isValid || isClosed) return;

    _submitDebouncer.run(() async {
      emit(state._copyWith(status: FormzSubmissionStatus.inProgress));

      final result = await _signInUseCase.call(
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
  }
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
  }
 */

  /// 🧽 Resets failure after consumption
  void clearFailure() => emit(state._copyWith());

  /// 🔄 Resets only the submission status (used after dialogs)
  void resetStatus() =>
      emit(state._copyWith(status: FormzSubmissionStatus.initial));

  /// 🧼 Cancels all pending debounce operations
  void _cancelDebouncers() {
    _debouncer.cancel(); // 🧯 prevent delayed emit from old email input
    _submitDebouncer.cancel(); // 🧯 prevent accidental double submit
  }

  /// 🧼 Resets the entire form to initial state
  void resetForm() {
    _cancelDebouncers();
    emit(const SignInPageState());
  }

  /// 🧼 Cleans up resources on close
  @override
  Future<void> close() {
    _cancelDebouncers();
    return super.close();
  }

  //
}
