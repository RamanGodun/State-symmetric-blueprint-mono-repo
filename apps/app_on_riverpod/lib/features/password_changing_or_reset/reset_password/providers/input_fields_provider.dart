import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_core_modules/public_api/base_modules/forms.dart'
    show ResetPasswordFormState;
import 'package:shared_core_modules/shared_core_modules.dart'
    show ResetPasswordFormState;
import 'package:shared_utils/public_api/general_utils.dart'
    show AppDurations, Debouncer;

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

  @override
  ResetPasswordFormState build() {
    ref.onDispose(_debouncer.cancel); // 🧼 Cleanup memory leaks on dispose
    /// Initializes the form state with default (pure) values.
    return const ResetPasswordFormState();
  }

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
