import 'package:core/public_api/core.dart';
import 'package:flutter/foundation.dart' show debugPrint;
import 'package:riverpod_adapter/riverpod_adapter.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'change_password__provider.g.dart';

/// 🔐 [changePasswordProvider] — Handles password-change submission & side-effects.
/// 🧰 Uses shared [SubmissionFlowStateModel].
/// 🔁 Symmetric to BLoC 'ChangePasswordCubit' (Initial → Loading → Success/Error/RequiresReauth).
//
@riverpod
final class ChangePassword extends _$ChangePassword {
  ///---------------------------------------------
  //
  // For anti double-tap protection for the submit action.
  final _submitDebouncer = Debouncer(AppDurations.ms600);

  @override
  SubmissionFlowStateModel build() {
    ref.onDispose(
      _submitDebouncer.cancel,
    ); // 🧼 Cleanup memory leaks on dispose
    /// 🧱 Initial state (idle)
    return const SubmissionFlowInitialState();
  }

  ////

  /// 🚀 Triggers password update with the provided `newPassword`.
  ///    Delegates domain logic to [passwordUseCasesProvider] and updates ButtonSubmission state.
  Future<void> changePassword(String newPassword) async {
    if (state is ButtonSubmissionLoadingState) return;
    //
    _submitDebouncer.run(() async {
      state = const ButtonSubmissionLoadingState();
      //
      final useCases = ref.read(passwordUseCasesProvider);
      final result = await useCases.callChangePassword(newPassword);
      ResultHandler(result)
        ..onSuccess((_) {
          debugPrint('✅ Password changed successfully');
          state = const ButtonSubmissionSuccessState();
        })
        ..onFailure((failure) async {
          debugPrint('❌ Password change failed: ${failure.runtimeType}');
          (failure.type is RequiresRecentLoginFirebaseFailureType)
              ? state = ButtonSubmissionRequiresReauthState(
                  failure.asConsumable(),
                )
              : state = ButtonSubmissionErrorState(failure.asConsumable());
          failure.log();
        })
        ..log();
    });
  }

  /// 🔑 Confirms reauthentication by signing the user out.
  /// 🚪 Triggers auth guard → automatic redirect to SignIn.
  Future<void> confirmReauth() async {
    final signOut = ref.read(signOutUseCaseProvider);
    await signOut();
  }

  ////

  /// ♻️ Reset to initial (e.g., after dialogs/navigation)
  void resetState() => state = const SubmissionFlowInitialState();

  //
}
