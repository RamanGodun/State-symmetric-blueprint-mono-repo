import 'package:core/core.dart';
import 'package:features/features_barrels/auth/auth.dart';
import 'package:flutter/foundation.dart' show debugPrint;
import 'package:flutter_bloc/flutter_bloc.dart';

// part 'sign_up_page__state.dart';

/// 🔐 [SignUpCubit] — Handles sign-up submission & side-effects
//
final class SignUpCubit extends Cubit<ButtonSubmissionState> {
  ///------------------------------------------------
  SignUpCubit(this._signUpUseCase)
    : super(const ButtonSubmissionInitialState());
  //
  final SignUpUseCase _signUpUseCase;
  final _submitDebouncer = Debouncer(AppDurations.ms600);

  ////

  /// 🚀/// ✅ Delegates actual sign-up to [SignUpUseCase], if form is valid
  Future<void> submit({
    required String name,
    required String email,
    required String password,
  }) async {
    if (state is ButtonSubmissionLoadingState) return;
    //
    _submitDebouncer.run(() async {
      emit(const ButtonSubmissionLoadingState());
      //
      final result = await _signUpUseCase(
        name: name,
        email: email,
        password: password,
      );
      //
      ResultHandler(result)
        ..onSuccess((_) {
          debugPrint('✅ Signed up successfully');
          emit(const ButtonSubmissionSuccessState());
        })
        ..onFailure((failure) {
          debugPrint('❌ Sign up failed: ${failure.runtimeType}');
          emit(ButtonSubmissionErrorState(failure.asConsumable()));
          failure.log();
        })
        ..log();
    });
    /*
  ? Alternative syntax: classic fold version for direct mapping:
  result.fold(
    (f) => emit(SignUpError(f))),
    (_) => emit(const SignUpSuccess()),
  );
  */
  }

  ////

  /// ♻️ Reset to initial (e.g., after dialogs/navigation)
  void resetState() => emit(const ButtonSubmissionInitialState());

  /// 🧼 Cleanup
  @override
  Future<void> close() {
    _submitDebouncer.cancel(); // 🧯 prevent accidental double submit
    return super.close();
  }

  //
}
