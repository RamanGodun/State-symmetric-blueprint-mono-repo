import 'package:core/core.dart';
import 'package:equatable/equatable.dart';
import 'package:features/features.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_adapter/riverpod_adapter.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'change_password__provider.g.dart';
part 'change_password__state.dart';

/// 🧩 [changePasswordProvider] — Manages the state and logic for password change flow.
/// Handles password update process, error mapping, and reauthentication scenarios.
//
final changePasswordProvider =
    StateNotifierProvider<ChangePasswordNotifier, ChangePasswordState>((ref) {
      final signOutUseCase = ref.read(signOutUseCaseProvider);
      return ChangePasswordNotifier(ref, signOutUseCase);
    });

////
////

/// ⏳ Returns loading state for submission (primitive bool)
//
@riverpod
bool changePasswordSubmitIsLoading(Ref ref) =>
    ref.watch(changePasswordProvider.select((state) => state.isLoading));

////
////

/// 🛡️ [ChangePasswordNotifier] — StateNotifier handling password change process.
/// Updates state for loading, success, error, and reauth cases.
//
final class ChangePasswordNotifier extends StateNotifier<ChangePasswordState> {
  ///----------------------------------------------------------------------
  /// 🧱 Initializes with [ChangePasswordInitial] state
  ChangePasswordNotifier(this.ref, this._signOutUseCase)
    : super(const ChangePasswordInitial());

  ///
  final Ref ref;
  final SignOutUseCase _signOutUseCase;

  /// 🔁 Attempts to update the user password via [PasswordRelatedUseCases].
  /// Emits [ChangePasswordLoading], then [ChangePasswordSuccess], [ChangePasswordError], or [ChangePasswordRequiresReauth].
  Future<void> changePassword(String newPassword) async {
    if (state is ChangePasswordLoading) return;
    state = const ChangePasswordLoading();
    //
    final useCase = ref.read(passwordUseCasesProvider);
    final result = await useCase.callChangePassword(newPassword);
    //
    result.fold(
      (failure) {
        (failure.type is RequiresRecentLoginFirebaseFailureType)
            ? state = ChangePasswordRequiresReauth(failure)
            : state = ChangePasswordError(failure);
      },
      (_) {
        state = const ChangePasswordSuccess();
      },
    );
  }

  /// 🔑 Confirms reauthentication by signing the user out.
  /// 🚪 Triggers auth guard → automatic redirect to SignIn.
  Future<void> confirmReauth() async {
    await _signOutUseCase();
  }

  //
}
