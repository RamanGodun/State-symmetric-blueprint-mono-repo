import 'package:core/core.dart';
import 'package:features/features.dart' show PasswordRelatedUseCases;
import 'package:features/features_barrels/auth/auth.dart' show SignOutUseCase;
import 'package:flutter/foundation.dart' show debugPrint;
import 'package:flutter_bloc/flutter_bloc.dart';

/// 🔐 [ChangePasswordCubit] — Handles password-change submission & side-effects.
/// 🧰 Uses shared [ButtonSubmissionState].
/// 🔁 Symmetric to Riverpod 'changePasswordProvider' (Initial → Loading → Success/Error/RequiresReauth).
//
final class ChangePasswordCubit extends Cubit<ButtonSubmissionState> {
  ///-------------------------------------------------------------
  /// Creates a cubit bound to domain [PasswordRelatedUseCases] & [SignOutUseCase].
  ChangePasswordCubit(this._useCases, this._signOutUseCase)
    : super(const ButtonSubmissionInitialState());
  //
  final PasswordRelatedUseCases _useCases;
  final SignOutUseCase _signOutUseCase;
  //
  /// For anti double-tap protection for the submit action.
  final _submitDebouncer = Debouncer(AppDurations.ms600);

  ////

  /// 🚀 Triggers password update with the provided `newPassword`.
  /// ✅ Delegates domain logic to [_useCases] and emits ButtonSubmission states.
  Future<void> submit(String newPassword) async {
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
  void resetState() => emit(const ButtonSubmissionInitialState());

  /// 🧼 Cleans up resources on close
  @override
  Future<void> close() {
    _submitDebouncer.cancel();
    return super.close();
  }

  //
}
