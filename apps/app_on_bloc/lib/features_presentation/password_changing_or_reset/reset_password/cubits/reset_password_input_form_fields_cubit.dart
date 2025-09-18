import 'package:core/core.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';

part 'reset_password_state.dart';

/// 🔐 [ResetPasswordFormCubit] — Owns email field & validation (Form only)
final class ResetPasswordFormCubit extends Cubit<ResetPasswordFormState> {
  ///----------------------------------------------------------
  ResetPasswordFormCubit(this._validation)
    : super(const ResetPasswordFormState());
  //
  final FormValidationService _validation;
  final _debouncer = Debouncer(AppDurations.ms180);

  ////

  /// 📧 Handles email input change (debounced)
  void onEmailChanged(String value) {
    _debouncer.run(() {
      final email = _validation.validateEmail(value.trim());
      emit(state._copyWith(email: email).validate());
    });
  }

  /// 🧼 Reset form to initial
  void resetState() => emit(const ResetPasswordFormState());

  /// 🧼 Cleanup
  @override
  Future<void> close() {
    _debouncer.cancel();
    return super.close();
  }

  //
}
