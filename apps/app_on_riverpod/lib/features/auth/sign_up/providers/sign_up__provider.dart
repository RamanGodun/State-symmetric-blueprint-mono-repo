import 'package:core/public_api/core.dart';
import 'package:features/features.dart' show SignUpUseCase;
import 'package:features/features_barrels/auth/auth.dart' show SignUpUseCase;
import 'package:riverpod_adapter/riverpod_adapter.dart'
    show signUpUseCaseProvider;
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'sign_up__provider.g.dart';

/// 🔐 [signUpProvider] — Handles sign-up submission & side-effects.
/// 🧰 Uses shared [SubmissionFlowState].
/// 🔁 Symmetric to BLoC 'SignUpCubit' (Initial → Loading → Success/Error).
//
@riverpod
final class SignUp extends _$SignUp {
  ///-----------------------------
  //
  // For anti double-tap protection for the submit action.
  final _submitDebouncer = Debouncer(AppDurations.ms600);

  @override
  SubmissionFlowState build() {
    ref.onDispose(
      _submitDebouncer.cancel,
    ); // 🧼 Cleanup memory leaks on dispose
    /// 🧱 Initial state (idle)
    return const SubmissionFlowInitialState();
  }

  ////

  /// 🚀 Triggers sign-up with the provided credentials.
  ///    Delegates domain logic to [SignUpUseCase] and updates ButtonSubmission state.
  Future<void> signUp({
    required String name,
    required String email,
    required String password,
  }) async {
    if (state is ButtonSubmissionLoadingState) return;
    //
    _submitDebouncer.run(() async {
      state = const ButtonSubmissionLoadingState();

      final useCase = ref.read(signUpUseCaseProvider);
      final result = await useCase(
        name: name,
        email: email,
        password: password,
      );

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

  /// ♻️ Reset to initial (e.g., after dialogs/navigation)
  void reset() => state = const SubmissionFlowInitialState();

  //
}
