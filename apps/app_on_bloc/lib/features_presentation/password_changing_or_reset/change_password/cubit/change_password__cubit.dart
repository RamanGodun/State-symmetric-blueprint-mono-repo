import 'package:core/core.dart';
import 'package:equatable/equatable.dart';
import 'package:features/features.dart' show PasswordRelatedUseCases;
import 'package:features/features_barrels/auth/auth.dart' show SignOutUseCase;
import 'package:flutter/foundation.dart' show debugPrint;
import 'package:flutter_bloc/flutter_bloc.dart';

part 'change_password__state.dart';

/// 🔐 [ChangePasswordCubit] — Manages reset password logic, validation, submission.
/// ✅ Leverages [PasswordRelatedUseCases] injected via DI and uses declarative state updates.
//
final class ChangePasswordCubit extends Cubit<ChangePasswordState> {
  ///-----------------------------------------------------------
  ChangePasswordCubit(this._useCases, this._signOutUseCase)
    : super(const ChangePasswordInitial());
  //
  final PasswordRelatedUseCases _useCases;
  final SignOutUseCase _signOutUseCase;
  final _submitDebouncer = Debouncer(AppDurations.ms600);

  ///

  /// 🚀 Submits reset password request if form is valid
  Future<void> submit(String newPassword) async {
    if (state is ChangePasswordLoading) return;
    //
    _submitDebouncer.run(() async {
      emit(const ChangePasswordLoading());
      //
      final result = await _useCases.callChangePassword(newPassword);
      //
      ResultHandler(result)
        ..onSuccess((_) {
          debugPrint('✅ Password changed successfully');
          emit(const ChangePasswordSuccess());
        })
        ..onFailure((failure) async {
          debugPrint('❌ Password change failed: ${failure.runtimeType}');
          (failure.type is RequiresRecentLoginFirebaseFailureType)
              ? emit(ChangePasswordRequiresReauth(failure.asConsumable()))
              : emit(ChangePasswordError(failure.asConsumable()));
          failure.log();
        })
        ..log();
    });
  }

  /// 🔑 Confirms reauthentication by signing the user out.
  /// 🚪 Triggers auth guard → automatic redirect to SignIn.
  Future<void> confirmReauth() async {
    await _signOutUseCase();
  }

  ///

  /// ♻️ Returns to initial state (eg, after dialog/redirect)
  void resetState() => emit(const ChangePasswordInitial());

  /// 🧼 Cleans up resources on close
  @override
  Future<void> close() {
    _submitDebouncer.cancel(); // 🧯 prevent accidental double submit
    return super.close();
  }

  //
}
