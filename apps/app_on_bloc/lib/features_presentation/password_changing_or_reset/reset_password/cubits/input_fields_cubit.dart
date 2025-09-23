import 'package:core/core.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';

part 'input_fields_state.dart';

/// 🔐 [ResetPasswordFormCubit] — Owns email field & validation (Form only)
final class ResetPasswordFormCubit extends Cubit<ResetPasswordFormState> {
  ///----------------------------------------------------------
  ResetPasswordFormCubit() : super(const ResetPasswordFormState());
  //

  final _debouncer = Debouncer(AppDurations.ms180);

  ////

  /// 📧 Handles email input change (debounced)
  void onEmailChanged(String value) {
    _debouncer.run(() {
      final email = EmailInputValidation.dirty(value.trim());
      emit(state._copyWith(email: email).validate());
    });
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
