import 'package:core/public_api/core.dart';
import 'package:features/features.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// 🔐 [SignInCubit] — Handles sign-in submission & side-effects.
/// 🧰 Uses shared [ButtonSubmissionState].
/// 🔁 Symmetric to Riverpod 'signInProvider' (Initial → Loading → Success/Error).
//
final class SignInCubit extends Cubit<ButtonSubmissionState> {
  ///-----------------------------------------------------
  /// Creates a cubit bound to the domain [SignInUseCase].
  SignInCubit(this._signInUseCase)
    : super(const ButtonSubmissionInitialState());
  //
  final SignInUseCase _signInUseCase;
  // For anti double-tap protection for the submit action.
  final _submitDebouncer = Debouncer(AppDurations.ms600);

  ////

  /// 🚀 Triggers sign-in with the provided credentials.
  ///    Delegates domain logic to [SignInUseCase] and emits ButtonSubmission states.
  Future<void> submit({required String email, required String password}) async {
    if (state is ButtonSubmissionLoadingState) return;
    //
    _submitDebouncer.run(() async {
      emit(const ButtonSubmissionLoadingState());
      //
      final result = await _signInUseCase.call(
        email: email,
        password: password,
      );
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
  void resetState() => emit(const ButtonSubmissionInitialState());

  /// 🧼 Cleanup
  @override
  Future<void> close() {
    _submitDebouncer.cancel();
    return super.close();
  }

  //
}
