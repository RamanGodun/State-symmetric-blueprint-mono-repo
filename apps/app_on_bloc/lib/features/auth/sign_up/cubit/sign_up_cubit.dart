import 'package:core/public_api/core.dart';
import 'package:features/features_barrels/auth/auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// 🔐 [SignUpCubit] — Handles sign-up submission & side-effects.
/// 🧰 Uses shared [SubmissionFlowState].
/// 🔁 Symmetric to Riverpod 'signUpProvider' (Initial → Loading → Success/Error).
//
final class SignUpCubit extends Cubit<SubmissionFlowState> {
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
