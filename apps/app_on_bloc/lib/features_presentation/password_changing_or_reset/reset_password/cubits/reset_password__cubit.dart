import 'package:core/core.dart';
import 'package:features/features.dart' show PasswordRelatedUseCases;
import 'package:flutter_bloc/flutter_bloc.dart';

/// 🔐 [ResetPasswordCubit] — Handles reset-password submission & side-effects.
/// 🧰 Uses shared [ButtonSubmissionState].
/// 🔁 Symmetric to Riverpod 'resetPasswordProvider' (Initial → Loading → Success/Error).
//
final class ResetPasswordCubit extends Cubit<ButtonSubmissionState> {
  ///-------------------------------------------------------------
  ResetPasswordCubit(this._useCases)
    : super(const ButtonSubmissionInitialState());
  //
  final PasswordRelatedUseCases _useCases;
  // For anti double-tap protection on submit action.
  final _submitDebouncer = Debouncer(AppDurations.ms600);

  ////

  /// 📩 Sends reset link to provided email.
  /// ✅ Delegates domain logic to [PasswordRelatedUseCases] and emits ButtonSubmission states.
  Future<void> submit(String email) async {
    if (state is ButtonSubmissionLoadingState) return;
    //
    _submitDebouncer.run(() async {
      emit(const ButtonSubmissionLoadingState());
      //
      final result = await _useCases.callResetPassword(email);
      result.fold(
        // ❌ Failure → error with Consumable<Failure>
        (failure) {
          emit(ButtonSubmissionErrorState(failure.asConsumable()));
          failure.log();
        },
        // ✅ Success
        (_) => emit(const ButtonSubmissionSuccessState()),
      );
    });
  }

  ////

  /// ♻️ Returns to initial state (eg, after dialog/redirect)
  void resetState() => emit(const ButtonSubmissionInitialState());

  /// 🧼 Cleans up
  @override
  Future<void> close() {
    _submitDebouncer.cancel();
    return super.close();
  }

  //
}
