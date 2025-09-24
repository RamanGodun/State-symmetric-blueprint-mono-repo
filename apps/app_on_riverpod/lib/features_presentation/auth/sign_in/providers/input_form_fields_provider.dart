import 'package:core/base_modules/forms.dart' show SignInFormState;
import 'package:core/utils.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'input_form_fields_provider.g.dart';

/// 📝 [signInFormProvider] — Handles sign-in form fields & validation.
/// 🧰 Uses shared [SignInFormState].
/// 🔁 Symmetric to BLoC ['SignInFormCubit'] (Form only).
//
@riverpod
final class SignInForm extends _$SignInForm {
  ///-------------------------------------
  //
  // For anti double-tap protection for the submit action.
  final _debouncer = Debouncer(AppDurations.ms100);

  ////

  /// Initializes the form state with default (pure) values.
  @override
  SignInFormState build() => const SignInFormState();

  /// 📧  Handles email input with validation, trimming and debounce
  void onEmailChanged(String value) {
    _debouncer.run(() => state = state.updateState(email: value));
  }

  /// 🔒  Handles password input with validation, trimming and debounce
  void onPasswordChanged(String value) {
    _debouncer.run(() => state = state.updateState(password: value));
  }

  /// 👁️ Toggle password field visibility
  void togglePasswordVisibility() {
    state = state.updateState(
      isPasswordObscure: !state.isPasswordObscure,
      revalidate: false,
    );
  }

  /// ♻️  Resets the form state to its initial (pure) values.
  void resetState() => state = SignInFormState(epoch: state.epoch + 1);

  //
}
