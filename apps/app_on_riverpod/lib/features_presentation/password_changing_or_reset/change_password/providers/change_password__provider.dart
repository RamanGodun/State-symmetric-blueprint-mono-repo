import 'package:core/core.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_adapter/riverpod_adapter.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'change_password__provider.g.dart';
part 'change_password__state.dart';

/// 🧩 [changePasswordProvider] — Riverpod Notifier with shared ButtonSubmissionState
/// ✅ Mirrors BLoC semantics (Initial → Loading → Success / Error / RequiresReauth)
//
@riverpod
final class ChangePassword extends _$ChangePassword {
  ///-----------------------------------------------
  final _submitDebouncer = Debouncer(AppDurations.ms600);

  /// 🧱 Initial state
  @override
  ButtonSubmissionState build() => const ButtonSubmissionInitialState();

  /// 🚀 Submits change password request
  Future<void> changePassword(String newPassword) async {
    if (state is ButtonSubmissionLoadingState) return;
    //
    _submitDebouncer.run(() async {
      state = const ButtonSubmissionLoadingState();
      //
      final useCases = ref.read(passwordUseCasesProvider);
      final result = await useCases.callChangePassword(newPassword);

      result.fold(
        // ❌ Failure → map to Error / RequiresReauth
        (failure) {
          (failure.type is RequiresRecentLoginFirebaseFailureType)
              ? state = ButtonSubmissionRequiresReauthState(
                  failure.asConsumable(),
                )
              : state = ButtonSubmissionErrorState(failure.asConsumable());
          failure.log();
        },
        // ✅ Success
        (_) => state = const ButtonSubmissionSuccessState(),
      );
    });
  }

  /// 🔑 Confirms reauthentication by signing the user out.
  /// 🚪 Triggers auth guard → automatic redirect to SignIn.
  Future<void> confirmReauth() async {
    final signOut = ref.read(signOutUseCaseProvider);
    await signOut();
  }

  /// ♻️ Reset to initial (e.g., after dialog/nav)
  void reset() => state = const ButtonSubmissionInitialState();
}

// final changePasswordProvider =
//     StateNotifierProvider<ChangePasswordNotifier, ChangePasswordState>((ref) {
//       final signOutUseCase = ref.read(signOutUseCaseProvider);
//       return ChangePasswordNotifier(ref, signOutUseCase);
//     });

////
////

////
////

// /// 🛡️ [ChangePasswordNotifier] — StateNotifier handling password change process.
// /// Updates state for loading, success, error, and reauth cases.
// //
// final class ChangePasswordNotifier extends StateNotifier<ChangePasswordState> {
//   ///----------------------------------------------------------------------
//   /// 🧱 Initializes with [ChangePasswordInitial] state
//   ChangePasswordNotifier(this.ref, this._signOutUseCase) : super(const ChangePasswordInitial());

//   ///
//   final Ref ref;
//   final SignOutUseCase _signOutUseCase;

//   /// 🔁 Attempts to update the user password via [PasswordRelatedUseCases].
//   /// Emits [ChangePasswordLoading], then [ChangePasswordSuccess], [ChangePasswordError], or [ChangePasswordRequiresReauth].
//   Future<void> changePassword(String newPassword) async {
//     if (state is ChangePasswordLoading) return;
//     state = const ChangePasswordLoading();
//     //
//     final useCase = ref.read(passwordUseCasesProvider);
//     final result = await useCase.callChangePassword(newPassword);
//     //
//     result.fold(
//       (failure) {
//         (failure.type is RequiresRecentLoginFirebaseFailureType)
//             ? state = ChangePasswordRequiresReauth(failure)
//             : state = ChangePasswordError(failure);
//       },
//       (_) {
//         state = const ChangePasswordSuccess();
//       },
//     );
//   }

//   /// 🔑 Confirms reauthentication by signing the user out.
//   /// 🚪 Triggers auth guard → automatic redirect to SignIn.
//   Future<void> confirmReauth() async {
//     await _signOutUseCase();
//   }

//   //
// }

/// ⏳ Returns loading state for submission (primitive bool)
//
@riverpod
bool changePasswordSubmitIsLoading(Ref ref) =>
    ref.watch(changePasswordProvider.select((state) => state.isLoading));
