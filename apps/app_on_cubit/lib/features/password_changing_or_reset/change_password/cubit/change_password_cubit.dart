import 'package:features_dd_layers/features_dd_layers.dart'
    show PasswordRelatedUseCases, SignOutUseCase;
import 'package:flutter/foundation.dart' show debugPrint;
import 'package:flutter_bloc/flutter_bloc.dart' show Cubit;
import 'package:shared_core_modules/public_api/base_modules/errors_management.dart'
    show
        ConsumableX,
        FailureLogger,
        RequiresRecentLoginFirebaseFailureType,
        ResultHandler;
import 'package:shared_layers/public_api/presentation_layer_shared.dart'
    show
        ButtonSubmissionErrorState,
        ButtonSubmissionLoadingState,
        ButtonSubmissionRequiresReauthState,
        ButtonSubmissionSuccessState,
        SubmissionFlowInitialState,
        SubmissionFlowStateModel;
import 'package:shared_utils/public_api/general_utils.dart'
    show AppDurations, Debouncer;

/// 🔐 [ChangePasswordCubit] — Handles password-change submission & side-effects.
/// 🧰 Uses shared [SubmissionFlowStateModel].
/// 🔁 Symmetric to Riverpod 'changePasswordProvider' (Initial → Loading → Success/Error/RequiresReauth).
//
final class ChangePasswordCubit extends Cubit<SubmissionFlowStateModel> {
  ///-------------------------------------------------------------
  /// Creates a cubit bound to domain [PasswordRelatedUseCases] & [SignOutUseCase].
  ChangePasswordCubit(this._useCases, this._signOutUseCase)
    : super(const SubmissionFlowInitialState());
  //
  final PasswordRelatedUseCases _useCases;
  final SignOutUseCase _signOutUseCase;
  //
  /// For anti double-tap protection for the submit action.
  final _submitDebouncer = Debouncer(AppDurations.ms600);

  ////

  /// 🚀 Triggers password update with the provided `newPassword`.
  /// ✅ Delegates domain logic to [_useCases] and emits ButtonSubmission states.
  Future<void> changePassword(String newPassword) async {
    if (state is ButtonSubmissionLoadingState) return;
    //
    _submitDebouncer.run(() async {
      emit(const ButtonSubmissionLoadingState());
      //
      final result = await _useCases.callChangePassword(newPassword);
      ResultHandler(result)
        ..onSuccess((_) {
          debugPrint('✅ Password changed successfully');
          emit(const ButtonSubmissionSuccessState());
        })
        ..onFailure((failure) async {
          debugPrint('❌ Password change failed: ${failure.runtimeType}');
          (failure.type is RequiresRecentLoginFirebaseFailureType)
              ? emit(
                  ButtonSubmissionRequiresReauthState(failure.asConsumable()),
                )
              : emit(ButtonSubmissionErrorState(failure.asConsumable()));
          failure.log();
        })
        ..log();
    });
  }

  /// 🔑 Confirms reauthentication by signing the user out.
  /// 🚪 Triggers auth guard → automatic redirect to SignIn.
  Future<void> confirmReauth() async {
    await _signOutUseCase();
  }

  ////

  /// ♻️ Reset to initial (e.g., after dialogs/navigation)
  void resetState() => emit(const SubmissionFlowInitialState());

  /// 🧼 Cleans up resources on close
  @override
  Future<void> close() {
    _submitDebouncer.cancel();
    return super.close();
  }

  //
}
