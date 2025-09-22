import 'package:core/core.dart';
import 'package:features/features.dart' show PasswordRelatedUseCases;
import 'package:flutter/foundation.dart' show debugPrint;
import 'package:flutter_bloc/flutter_bloc.dart';

// part 'reset_password__state.dart';

/// 🔐 [ResetPasswordCubit] — Manages reset password submission & side-effects
/// ✅ Leverages [PasswordRelatedUseCases] injected via DI and uses declarative state updates.
//
final class ResetPasswordCubit extends Cubit<ButtonSubmissionState> {
  ///----------------------------------------------------------
  ResetPasswordCubit(this._useCases) : super(const ButtonSubmissionInitial());
  //
  final PasswordRelatedUseCases _useCases;
  final _submitDebouncer = Debouncer(AppDurations.ms600);

  ////

  /// 🚀 Submits reset password request if form is valid
  Future<void> submit(String email) async {
    if (state is ButtonSubmissionLoading) return;
    //
    _submitDebouncer.run(() async {
      emit(const ButtonSubmissionLoading());
      //
      final result = await _useCases.callResetPassword(email);
      //
      ResultHandler(result)
        ..onSuccess((_) {
          debugPrint('✅ Reset password link sent');
          emit(const ButtonSubmissionSuccess());
        })
        ..onFailure((f) {
          debugPrint('❌ Reset password failed: ${f.runtimeType}');
          emit(ButtonSubmissionError(f.asConsumable()));
          f.log();
        })
        ..log();
    });
  }

  ////

  /// ♻️ Returns to initial state (eg, after dialog/redirect)
  void resetState() => emit(const ButtonSubmissionInitial());

  /// 🧼 Cleans up
  @override
  Future<void> close() {
    _submitDebouncer.cancel(); // 🧯 prevent accidental double submit
    return super.close();
  }

  //
}
