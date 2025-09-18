import 'package:core/core.dart';
import 'package:equatable/equatable.dart';
import 'package:features/features_barrels/auth/auth.dart';
import 'package:flutter/foundation.dart' show debugPrint;
import 'package:flutter_bloc/flutter_bloc.dart';

part 'sign_up_page__state.dart';

/// 🔐 [SignUpCubit] — Handles sign-up submission & side-effects
//
final class SignUpCubit extends Cubit<SignUpState> {
  ///-------------------------------------------
  SignUpCubit(this._signUpUseCase) : super(const SignUpInitial());
  //
  final SignUpUseCase _signUpUseCase;
  final _submitDebouncer = Debouncer(AppDurations.ms180);

  ////

  /// 🚀/// ✅ Delegates actual sign-up to [SignUpUseCase], if form is valid
  Future<void> submit({
    required String name,
    required String email,
    required String password,
  }) async {
    if (state is SignUpLoading) return;
    //
    _submitDebouncer.run(() async {
      emit(const SignUpLoading());
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
          emit(const SignUpSuccess());
        })
        ..onFailure((failure) {
          debugPrint('❌ Sign up failed: ${failure.runtimeType}');
          emit(SignUpError(failure.asConsumable()));
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
  void resetState() => emit(const SignUpInitial());

  /// 🧼 Cleanup
  @override
  Future<void> close() {
    _submitDebouncer.cancel(); // 🧯 prevent accidental double submit
    return super.close();
  }

  //
}
