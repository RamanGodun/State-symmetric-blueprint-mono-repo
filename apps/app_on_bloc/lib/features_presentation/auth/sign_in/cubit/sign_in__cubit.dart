import 'package:core/core.dart';
import 'package:features/features.dart';
import 'package:flutter/foundation.dart' show debugPrint;
import 'package:flutter_bloc/flutter_bloc.dart';

/// 🔐 [SignInCubit] — Handles sign-in submission & side-effects
//
final class SignInCubit extends Cubit<ButtonSubmissionState> {
  ///-----------------------------------------------
  SignInCubit(this._signInUseCase) : super(const ButtonSubmissionInitial());
  //
  final SignInUseCase _signInUseCase;
  final _submitDebouncer = Debouncer(AppDurations.ms600);

  ////

  /// 🚀 Submits credentials (expects pre-validated email/password)
  Future<void> submit({required String email, required String password}) async {
    if (state is ButtonSubmissionLoading) return;
    //
    _submitDebouncer.run(() async {
      emit(const ButtonSubmissionLoading());
      //
      final result = await _signInUseCase.call(
        email: email,
        password: password,
      );
      ResultHandler(result)
        ..onSuccess((_) {
          debugPrint('✅ Signed in successfully');
          emit(const ButtonSubmissionSuccess());
        })
        ..onFailure((failure) {
          debugPrint('❌ Sign in failed: ${failure.runtimeType}');
          emit(ButtonSubmissionError(failure.asConsumable()));
          failure.log();
        })
        ..log();
    });
  }
  /*
  ? Alternative syntax: classic fold version for direct mapping:
  result.fold(
      (f) =>  emit(SubmissionError(f))),
      (_) =>  emit(const SubmissionSuccess()),
    );
  }

 */

  /// ♻️ Reset to initial (e.g., after dialogs/navigation)
  void resetState() => emit(const ButtonSubmissionInitial());

  /// 🧼 Cleanup
  @override
  Future<void> close() {
    _submitDebouncer.cancel(); // 🧯 prevent accidental double submit
    return super.close();
  }

  //
}
