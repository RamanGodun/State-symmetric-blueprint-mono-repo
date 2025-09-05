import 'package:app_on_riverpod/features_presentation/password_changing_or_reset/reset_password/providers/reset_password_form_state.dart';
import 'package:core/base_modules/forms.dart' show EmailInputValidation;
import 'package:flutter_riverpod/flutter_riverpod.dart' show StateNotifier;
import 'package:hooks_riverpod/hooks_riverpod.dart' show StateNotifier;
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'reset_password_form_provider.g.dart';

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
