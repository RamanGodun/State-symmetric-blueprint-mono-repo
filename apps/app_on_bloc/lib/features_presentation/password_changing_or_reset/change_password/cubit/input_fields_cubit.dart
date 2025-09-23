//
// ignore_for_file: public_member_api_docs
import 'package:core/core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// 🔐 [ChangePasswordFormFieldsCubit] —
//
final class ChangePasswordFormFieldsCubit
    extends Cubit<ChangePasswordFormState> {
  ///-----------------------------------------------------------
  ChangePasswordFormFieldsCubit() : super(const ChangePasswordFormState());
  //
  final _debouncer = Debouncer(AppDurations.ms150);

  ////

  /// 🔒  Handles password input + sync password confirm (with validation, trimming and debounce)
  void onPasswordChanged(String value) {
    _debouncer.run(() => emit(state.updateState(password: value)));
  }

  /// 🔐  Handles confirm password input with validation, trimming and debounce
  void onConfirmPasswordChanged(String value) {
    _debouncer.run(() => emit(state.updateState(confirmPassword: value)));
  }

  /// 👁️ Toggles password field visibility
  void togglePasswordVisibility() => emit(
    state.updateState(
      isPasswordObscure: !state.isPasswordObscure,
      revalidate: false,
    ),
  );

  /// 👁️🔁 Toggles confirm password visibility
  void toggleConfirmPasswordVisibility() => emit(
    state.updateState(
      isConfirmPasswordObscure: !state.isConfirmPasswordObscure,
      revalidate: false,
    ),
  );

  ////

  /// ♻️🧼 Resets the entire form to initial state
  void resetState() => emit(ChangePasswordFormState(epoch: state.epoch + 1));

  /// 🧼 Cleanup
  @override
  Future<void> close() {
    _debouncer.cancel();
    return super.close();
  }

  //
}
