import 'package:core/public_api/core.dart';
import 'package:features/features.dart' show SignInUseCase;
import 'package:riverpod_adapter/riverpod_adapter.dart'
    show signInUseCaseProvider;
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'sign_in__provider.g.dart';

/// 🔐 [signInProvider] — Handles sign-in submission & side-effects.
/// 🧰 Uses shared [SubmissionFlowStateModel].
/// 🔁 Symmetric to BLoC 'SignInCubit' (Initial → Loading → Success/Error).
//
@riverpod
final class SignIn extends _$SignIn {
  ///-----------------------------
  //
  /// For anti double-tap protection for the submit action.
  final _submitDebouncer = Debouncer(AppDurations.ms600);

  ////

  @override
  SubmissionFlowStateModel build() {
    ref.onDispose(
      _submitDebouncer.cancel,
    ); // 🧼 Cleanup memory leaks on dispose
    /// 🧱 Initial state (idle)
    return const SubmissionFlowInitialState();
  }

  /// 🚀 Triggers sign-in with the provided credentials.
  ///    Delegates domain logic to [SignInUseCase] and updates ButtonSubmission state.
  Future<void> signin({required String email, required String password}) async {
    if (state is ButtonSubmissionLoadingState) return;
    //
    _submitDebouncer.run(() async {
      state = const ButtonSubmissionLoadingState();
      //
      final useCase = ref.watch(signInUseCaseProvider);
      //
      final result = await useCase(email: email, password: password);
      result.fold(
        // ❌ Failure branch → emit error with Consumable<Failure>
        (failure) {
          state = ButtonSubmissionErrorState(failure.asConsumable());
          failure.log();
        },
        // ✅ Success branch
        (_) => state = const ButtonSubmissionSuccessState(),
      );
    });
  }

  ////

  /// ♻️ Reset to initial (e.g., after dialogs/navigation)
  void reset() => state = const SubmissionFlowInitialState();

  //
}
