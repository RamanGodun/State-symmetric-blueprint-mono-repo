import 'package:core/core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart' show Ref, StateNotifier;
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'input_fields_provider.g.dart';

/// 🧩 [ResetPasswordForm] — Manages the state of the reset password form using [StateNotifier].
/// Handles input updates, validation, and future extensibility.
//
@riverpod
final class ResetPasswordForm extends _$ResetPasswordForm {
  ///---------------------------------------------------
  //
  final _debouncer = Debouncer(AppDurations.ms180);

  /// Initializes the form state with default (pure) values.
  @override
  ResetPasswordFormState build() => const ResetPasswordFormState();

  ////

  /// 📧  Handles email input with validation, trimming and debounce
  void onEmailChanged(String value) {
    _debouncer.run(() => state = state.updateState(email: value));
  }

  /// 🧼 Reset form to initial
  void resetState() => state = ResetPasswordFormState(epoch: state.epoch + 1);

  //
}

////
////

/// ✅ Returns form validity as primitive bool (minimal rebuilds)
//
@riverpod
bool resetPasswordFormIsValid(Ref ref) =>
    ref.watch(resetPasswordFormProvider.select((f) => f.isValid));
