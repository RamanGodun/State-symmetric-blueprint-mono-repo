import 'package:core/core.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';

part 'sign_in_page_input_fields_state.dart';

/// 📝 [SignInFormCubit] — Owns email/password fields & validation (Form only)
final class SignInFormCubit extends Cubit<SignInFormState> {
  ///----------------------------------------------------------
  SignInFormCubit(this._validation) : super(const SignInFormState());
  //
  final FormValidationService _validation;
  final _emailDebouncer = Debouncer(AppDurations.ms150);

  ////

  /// 📧 Handles email field changes with debounce and validation
  void onEmailChanged(String value) {
    _emailDebouncer.run(() {
      final email = _validation.validateEmail(value.trim());
      emit(state._copyWith(email: email).validate());
    });
  }

  /// 🔒 Handles password field changes and form revalidation
  void onPasswordChanged(String value) {
    _emailDebouncer.run(() {
      final password = _validation.validatePassword(value.trim());
      emit(state._copyWith(password: password).validate());
    });
  }

  /// 👁️ Toggle password visibility
  void togglePasswordVisibility() =>
      emit(state._copyWith(isPasswordObscure: !state.isPasswordObscure));

  /// 🧼 Reset form
  void resetState() => emit(const SignInFormState());

  /// 🧼 Cleans up resources on close
  @override
  Future<void> close() {
    _emailDebouncer.cancel();
    return super.close();
  }

  //
}
