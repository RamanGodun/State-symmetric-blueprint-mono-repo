import 'package:adapters_for_riverpod/adapters_for_riverpod.dart'
    show signUpUseCaseProvider;
import 'package:features_dd_layers/features_dd_layers.dart' show SignUpUseCase;
import 'package:features_dd_layers/public_api/auth/auth.dart'
    show SignUpUseCase;
import 'package:riverpod_annotation/riverpod_annotation.dart';
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

part 'sign_up__provider.g.dart';

/// 🔐 [signUpProvider] — Handles sign-up submission & side-effects.
/// 🧰 Uses shared [SubmissionFlowStateModel].
/// 🔁 Symmetric to BLoC 'SignUpCubit' (Initial → Loading → Success/Error).
//
@riverpod
final class SignUp extends _$SignUp {
  ///-----------------------------
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
