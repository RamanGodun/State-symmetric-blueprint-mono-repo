import 'package:core/base_modules/errors_management.dart'
    show Consumable, ConsumableX, Failure, ResultHandler;
import 'package:equatable/equatable.dart';
import 'package:features/features.dart' show SignOutUseCase;
import 'package:flutter_bloc/flutter_bloc.dart';

part 'sign_out_state.dart';

/// 🚪 [SignOutCubit] — Handles the user sign out logic
/// ✅ Emits failure/success status (if needed)
//
final class SignOutCubit extends Cubit<SignOutState> {
  ///---------------------------------------------
  SignOutCubit(this._signOutUseCase) : super(const SignOutState());
  //
  final SignOutUseCase _signOutUseCase;

  ///
  Future<void> signOut() async {
    emit(state.copyWith(status: SignOutStatus.loading));

    final result = await _signOutUseCase();

    if (isClosed) return;

    ResultHandler(result)
      ..onFailure((f) {
        emit(
          state.copyWith(
            status: SignOutStatus.failure,
            failure: f.asConsumable(),
          ),
        );
      })
      ..onSuccess((_) {
        emit(state.copyWith(status: SignOutStatus.success));
      })
      ..log();
  }
}
