import 'package:core/base_modules/errors_handling/core_of_module/core_utils/result_handler.dart'
    show ResultHandler;
import 'package:core/base_modules/errors_handling/core_of_module/core_utils/specific_for_bloc/consumable.dart'
    show Consumable;
import 'package:core/base_modules/errors_handling/core_of_module/core_utils/specific_for_bloc/consumable_extensions.dart';
import 'package:core/base_modules/errors_handling/core_of_module/failure_entity.dart'
    show Failure;
import 'package:equatable/equatable.dart';
import 'package:features/auth/domain/use_cases/sign_out.dart';
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
