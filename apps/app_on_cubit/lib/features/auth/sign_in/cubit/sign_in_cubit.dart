import 'package:core/public_api/core.dart';
import 'package:features/features.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// 🔐 [SignInCubit] — Handles sign-in submission & side-effects.
/// 🧰 Uses shared [SubmissionFlowStateModel].
/// 🔁 Symmetric to Riverpod 'signInProvider' (Initial → Loading → Success/Error).
//
final class SignInCubit extends Cubit<SubmissionFlowStateModel> {
  ///-----------------------------------------------------
  /// Creates a cubit bound to the domain [SignInUseCase].
  SignInCubit(this._signInUseCase) : super(const SubmissionFlowInitialState());
  //
  final SignInUseCase _signInUseCase;
  // For anti double-tap protection for the submit action.
  final _submitDebouncer = Debouncer(AppDurations.ms600);

  /// Checks if cubit is still alive
  bool get _cubitAlive => !isClosed;

  ////

  /// 🚀 Triggers sign-in with the provided credentials.
  ///    Delegates domain logic to [SignInUseCase] and emits ButtonSubmission states.
  Future<void> signin({required String email, required String password}) async {
    if (state is ButtonSubmissionLoadingState || !_cubitAlive) return;
    //
    _submitDebouncer.run(() async {
      emit(const ButtonSubmissionLoadingState());
      //
      final result = await _signInUseCase.call(
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
