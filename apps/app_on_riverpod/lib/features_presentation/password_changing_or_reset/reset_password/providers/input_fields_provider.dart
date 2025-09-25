import 'package:core/core.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'input_fields_provider.g.dart';

/// 📝 [ResetPasswordForm] — Handles reset-password form field & validation.
/// 🧰 Uses shared [ResetPasswordFormState].
/// 🔁 Symmetric to BLoC 'ResetPasswordFormCubit' (Form only).
//
@riverpod
final class ResetPasswordForm extends _$ResetPasswordForm {
  ///---------------------------------------------------
  //
  /// For anti double-tap protection on input updates.
  final _debouncer = Debouncer(AppDurations.ms100);

  /// Initializes the form state with default (pure) values.
  @override
  ResetPasswordFormState build() => const ResetPasswordFormState();

  ////

  /// 📧  Handles email input with validation, trimming and debounce
  void onEmailChanged(String value) {
    _debouncer.run(() => state = state.updateState(email: value));
  }

  ////

  /// ♻️ Resets the form to its initial state.
  void resetState() => state = ResetPasswordFormState(epoch: state.epoch + 1);

  //
}
