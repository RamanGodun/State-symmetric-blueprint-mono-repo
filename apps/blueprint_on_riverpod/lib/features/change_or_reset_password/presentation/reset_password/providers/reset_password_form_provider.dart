import 'package:blueprint_on_riverpod/features/change_or_reset_password/presentation/reset_password/providers/reset_password_form_state.dart';
import 'package:core/base_modules/form_fields/input_validation/validation_enums.dart'
    show EmailInputValidation;
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
