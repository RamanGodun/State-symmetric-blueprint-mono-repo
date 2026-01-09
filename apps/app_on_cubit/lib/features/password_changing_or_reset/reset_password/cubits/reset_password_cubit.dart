import 'package:features_dd_layers/public_api/password_changing_or_reset/password_changing_or_reset.dart'
    show PasswordRelatedUseCases;
import 'package:flutter_bloc/flutter_bloc.dart' show Cubit;
import 'package:shared_core_modules/public_api/base_modules/errors_management.dart'
    show ConsumableX, FailureLogger;
import 'package:shared_layers/public_api/presentation_layer_shared.dart'
    show
        ButtonSubmissionErrorState,
        ButtonSubmissionLoadingState,
        ButtonSubmissionSuccessState,
        SubmissionFlowInitialState,
        SubmissionFlowStateModel;
import 'package:shared_utils/public_api/general_utils.dart'
    show AppDurations, Debouncer;

/// 🔐 [ResetPasswordCubit] — Handles reset-password submission & side-effects.
/// 🧰 Uses shared [SubmissionFlowStateModel].
/// 🔁 Symmetric to Riverpod 'resetPasswordProvider' (Initial → Loading → Success/Error).
//
final class ResetPasswordCubit extends Cubit<SubmissionFlowStateModel> {
  ///------------------------------------------------------------
  /// Creates a cubit bound to the domain [PasswordRelatedUseCases].
  ResetPasswordCubit(this._useCases)
    : super(const SubmissionFlowInitialState());
  //
  final PasswordRelatedUseCases _useCases;
  //
  /// For anti double-tap protection on submit action.
  final _submitDebouncer = Debouncer(AppDurations.ms600);

  ////

  /// 📩 Sends reset link to provided email.
  /// ✅ Delegates domain logic to [PasswordRelatedUseCases] and emits ButtonSubmission states.
  Future<void> resetPassword(String email) async {
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
  void resetState() => emit(const SubmissionFlowInitialState());

  /// 🧼 Cleans up
  @override
  Future<void> close() {
    _submitDebouncer.cancel();
    return super.close();
  }

  //
}
