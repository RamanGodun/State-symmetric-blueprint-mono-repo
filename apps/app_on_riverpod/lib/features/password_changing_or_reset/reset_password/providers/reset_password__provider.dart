import 'package:core/public_api/core.dart';
import 'package:features/features.dart' show PasswordRelatedUseCases;
import 'package:riverpod_adapter/riverpod_adapter.dart'
    show passwordUseCasesProvider;
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'reset_password__provider.g.dart';

/// 🔐 [resetPasswordProvider] — Handles reset-password submission & side-effects.
/// 🧰 Uses shared [SubmissionFlowStateModel].
/// 🔁 Symmetric to BLoC 'ResetPasswordCubit' (Initial → Loading → Success/Error).
//
@riverpod
final class ResetPassword extends _$ResetPassword {
  ///-------------------------------------------
  //
  /// For anti double-tap protection on submit action.
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

  /// 📩 Sends reset link to provided email.
  /// ✅ Delegates domain logic to [PasswordRelatedUseCases] and updates ButtonSubmission state.
  Future<void> resetPassword({required String email}) async {
    if (state is ButtonSubmissionLoadingState) return;

    _submitDebouncer.run(() async {
      state = const ButtonSubmissionLoadingState();

      final useCase = ref.read(passwordUseCasesProvider);
      final result = await useCase.callResetPassword(email);

      result.fold(
        // ❌ Failure → error with Consumable<Failure>
        (failure) {
          state = ButtonSubmissionErrorState(failure.asConsumable());
          failure.log();
        },
        // ✅ Success
        (_) => state = const ButtonSubmissionSuccessState(),
      );
    });
  }

  ////

  /// ♻️ Returns to initial state (eg, after dialog/redirect)
  void reset() => state = const SubmissionFlowInitialState();

  //
}
