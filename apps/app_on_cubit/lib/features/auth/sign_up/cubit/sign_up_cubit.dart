import 'package:features_dd_layers/public_api/auth/auth.dart'
    show SignUpUseCase;
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

/// 🔐 [SignUpCubit] — Handles sign-up submission & side-effects.
/// 🧰 Uses shared [SubmissionFlowStateModel].
/// 🔁 Symmetric to Riverpod 'signUpProvider' (Initial → Loading → Success/Error).
//
final class SignUpCubit extends Cubit<SubmissionFlowStateModel> {
  ///-----------------------------------------------------
  /// Creates a cubit bound to the domain [SignUpCubit].
  SignUpCubit(this._signUpUseCase) : super(const SubmissionFlowInitialState());
  //
  final SignUpUseCase _signUpUseCase;
  // For anti double-tap protection for the submit action.
  final _submitDebouncer = Debouncer(AppDurations.ms600);

  /// Checks if cubit is still alive
  bool get _cubitAlive => !isClosed;

  ////

  /// 🚀 Triggers sign-up with the provided credentials.
  ///    Delegates domain logic to [SignUpUseCase] and emits ButtonSubmission states.
  Future<void> signUp({
    required String name,
    required String email,
    required String password,
  }) async {
    if (state is ButtonSubmissionLoadingState || !_cubitAlive) return;
    //
    _submitDebouncer.run(() async {
      emit(const ButtonSubmissionLoadingState());
      //
      final result = await _signUpUseCase.call(
        name: name,
        email: email,
        password: password,
      );
      if (!_cubitAlive) return;

      result.fold(
        // ❌ Failure branch → emit error with Consumable<Failure>
        (failure) {
          emit(ButtonSubmissionErrorState(failure.asConsumable()));
          failure.log();
        },
        // ✅ Success branch
        (_) => emit(const ButtonSubmissionSuccessState()),
      );
    });
  }

  ////

  /// ♻️ Reset to initial (e.g., after dialogs/navigation)
  void resetState() {
    if (!_cubitAlive) return;
    emit(const SubmissionFlowInitialState());
  }

  /// 🧼 Cleanup
  @override
  Future<void> close() {
    _submitDebouncer.cancel();
    return super.close();
  }

  //
}
