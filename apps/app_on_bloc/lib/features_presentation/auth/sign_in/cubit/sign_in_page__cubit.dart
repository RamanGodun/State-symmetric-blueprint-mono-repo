import 'package:core/core.dart';
import 'package:equatable/equatable.dart';
import 'package:features/features.dart';
import 'package:flutter/foundation.dart' show debugPrint;
import 'package:flutter_bloc/flutter_bloc.dart';

part 'sign_in_page__state.dart';

/// 🔐 [SignInCubit] — Handles sign-in submission & side-effects
//
final class SignInCubit extends Cubit<SignInPageState> {
  ///-----------------------------------------------
  SignInCubit(this._signInUseCase) : super(const SignInInitial());
  //
  final SignInUseCase _signInUseCase;
  final _submitDebouncer = Debouncer(AppDurations.ms600);

  ////

  /// 🚀 Submits credentials (expects pre-validated email/password)
  Future<void> submit({required String email, required String password}) async {
    if (state is SignInLoading) return;
    //
    _submitDebouncer.run(() async {
      emit(const SignInLoading());
      //
      final result = await _signInUseCase.call(
        email: email,
        password: password,
      );
      ResultHandler(result)
        ..onSuccess((_) {
          debugPrint('✅ Signed in successfully');
          emit(const SignInSuccess());
        })
        ..onFailure((f) {
          debugPrint('❌ Sign in failed: ${f.runtimeType}');
          emit(SignInError(f));
          f.log();
        })
        ..log();
    });
  }
  /*
  ? Alternative syntax: classic fold version for direct mapping:

  result.fold(
      (f) =>  emit(SignInError(f))),
      (_) =>  emit(const SignInSuccess()),
    );
  }

 */

  /// ♻️ Reset to initial (e.g., after dialogs/navigation)
  void resetState() => emit(const SignInInitial());

  /// 🧼 Cleanup
  @override
  Future<void> close() {
    _submitDebouncer.cancel(); // 🧯 prevent accidental double submit
    return super.close();
  }

  //
}
