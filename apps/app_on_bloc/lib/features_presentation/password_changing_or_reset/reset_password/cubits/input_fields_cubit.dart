import 'package:core/core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// 🔐 [ResetPasswordFormCubit] — Owns email field & validation (Form only)
//
final class ResetPasswordFormCubit extends Cubit<ResetPasswordFormState> {
  ///----------------------------------------------------------
  ResetPasswordFormCubit() : super(const ResetPasswordFormState());
  //
  final _debouncer = Debouncer(AppDurations.ms20);

  ////

  /// 📧  Handles email input with validation, trimming and debounce
  void onEmailChanged(String value) {
    _debouncer.run(() => emit(state.updateState(email: value)));
  }

  /// 🧼 Reset form to initial
  void resetState() => emit(ResetPasswordFormState(epoch: state.epoch + 1));

  /// 🧼 Cleanup
  @override
  Future<void> close() {
    _debouncer.cancel();
    return super.close();
  }

  //
}
