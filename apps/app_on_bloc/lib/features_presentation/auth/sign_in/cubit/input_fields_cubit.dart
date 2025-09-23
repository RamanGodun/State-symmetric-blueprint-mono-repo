import 'package:core/core.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';

part 'input_fields_state.dart';

/// 📝 [SignInFormCubit] — Owns email/password fields & validation (Form only)
final class SignInFormCubit extends Cubit<SignInFormState> {
  ///----------------------------------------------------------
  SignInFormCubit() : super(const SignInFormState());
  //
  final _inputDebouncer = Debouncer(AppDurations.ms20);

  ////

  /// 📧 Handles email field changes with debounce and validation
  void onEmailChanged(String value) {
    _inputDebouncer.run(() {
      final email = EmailInputValidation.dirty(value.trim());
      emit(state._copyWith(email: email).validate());
    });
  }

  /// 🔒 Handles password field changes and form revalidation
  void onPasswordChanged(String value) {
    _inputDebouncer.run(() {
      final password = PasswordInputValidation.dirty(value.trim());
      emit(state._copyWith(password: password).validate());
    });
  }

  /// 👁️ Toggle password visibility
  void togglePasswordVisibility() =>
      emit(state._copyWith(isPasswordObscure: !state.isPasswordObscure));

  /// 🧼 Reset form
  void resetState() => emit(SignInFormState(epoch: state.epoch + 1));

  /// 🧼 Cleans up resources on close
  @override
  Future<void> close() {
    _inputDebouncer.cancel();
    return super.close();
  }

  //
}
