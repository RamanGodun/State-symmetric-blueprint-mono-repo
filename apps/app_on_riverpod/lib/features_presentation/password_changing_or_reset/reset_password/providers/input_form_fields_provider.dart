import 'package:app_on_riverpod/features_presentation/password_changing_or_reset/reset_password/providers/input_form_fields_state.dart';
import 'package:core/base_modules/forms.dart' show EmailInputValidation;
import 'package:flutter_riverpod/flutter_riverpod.dart' show Ref, StateNotifier;
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'input_form_fields_provider.g.dart';

/// 🧩 [ResetPasswordForm] — Manages the state of the reset password form using [StateNotifier].
/// Handles input updates, validation, and future extensibility.
//
@riverpod
final class ResetPasswordForm extends _$ResetPasswordForm {
  ///--------------------------------

  /// Initializes the form state with default (pure) values.
  @override
  ResetPasswordFormState build() => const ResetPasswordFormState();

  /// Updates the email field with a new value and triggers validation.
  void emailChanged(String value) {
    final email = EmailInputValidation.dirty(value);
    state = state.copyWith(email: email).validate();
  }

  /// Resets the form state to initial pure values.
  void reset() => state = const ResetPasswordFormState();

  //
}

////
////

/// ✅ Returns form validity as primitive bool (minimal rebuilds)
//
@riverpod
bool resetPasswordFormIsValid(Ref ref) =>
    ref.watch(resetPasswordFormProvider.select((f) => f.isValid));
