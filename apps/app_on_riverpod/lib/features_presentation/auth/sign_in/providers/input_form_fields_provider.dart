import 'package:core/base_modules/forms.dart' show SignInFormState;
import 'package:core/utils.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart' show Ref, StateNotifier;
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'input_form_fields_provider.g.dart';

/// 🧩 [SignInForm] — Manages the state of the sign-in form using [StateNotifier].
/// Handles input updates, validation, and visibility toggling for password field.
//
@riverpod
final class SignInForm extends _$SignInForm {
  ///-------------------------------------
  //
  final _debouncer = Debouncer(AppDurations.ms20);

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

  /// Resets the form state to its initial (pure) values.
  void resetState() => state = SignInFormState(epoch: state.epoch + 1);

  //
}

////
////

/// ✅ Returns form validity as primitive bool (minimal rebuilds)
//
@riverpod
bool signInFormIsValid(Ref ref) =>
    ref.watch(signInFormProvider.select((f) => f.isValid));
