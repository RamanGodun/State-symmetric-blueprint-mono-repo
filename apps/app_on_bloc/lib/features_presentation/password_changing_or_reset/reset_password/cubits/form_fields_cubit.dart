import 'package:core/core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// 📝 [ResetPasswordFormFieldsCubit] — Handles reset-password form field & validation.
/// 🧰 Uses shared [ResetPasswordFormState].
/// 🔁 Symmetric to Riverpod 'ResetPasswordForm' notifier (Form only).
//
final class ResetPasswordFormFieldsCubit extends Cubit<ResetPasswordFormState> {
  ///----------------------------------------------------------
  ResetPasswordFormFieldsCubit() : super(const ResetPasswordFormState());
  //
  // For anti double-tap protection on input updates.
  final _debouncer = Debouncer(AppDurations.ms100);

  ////

  /// 📧  Handles email input with validation, trimming and debounce
  void onEmailChanged(String value) {
    _debouncer.run(() => emit(state.updateState(email: value)));
  }

  ////

  /// ♻️ Resets the form to its initial state.
  void resetState() => emit(ResetPasswordFormState(epoch: state.epoch + 1));

  /// 🧼 Cleanup
  @override
  Future<void> close() {
    _debouncer.cancel();
    return super.close();
  }

  //
}
