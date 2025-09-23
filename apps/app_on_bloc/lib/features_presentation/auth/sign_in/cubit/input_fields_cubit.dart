import 'package:core/core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// 📝 [SignInFormCubit] — Owns email/password fields & validation (Form only)
final class SignInFormCubit extends Cubit<SignInFormState> {
  ///----------------------------------------------------------
  SignInFormCubit() : super(const SignInFormState());
  //
  final _debouncer = Debouncer(AppDurations.ms20);

  ////

  /// 📧  Handles email input with validation, trimming and debounce
  void onEmailChanged(String value) {
    _debouncer.run(() => emit(state.updateState(email: value)));
  }

  /// 🔒  Handles password input with validation, trimming and debounce
  void onPasswordChanged(String value) {
    _debouncer.run(() => emit(state.updateState(password: value)));
  }

  /// 👁️ Toggle password field visibility
  void togglePasswordVisibility() {
    emit(
      state.updateState(
        isPasswordObscure: !state.isPasswordObscure,
        revalidate: false,
      ),
    );
  }

  /// Resets the form state to its initial (pure) values.
  void resetState() => emit(SignInFormState(epoch: state.epoch + 1));

  /// 🧼 Cleans up resources on close
  @override
  Future<void> close() {
    _debouncer.cancel();
    return super.close();
  }

  //
}
