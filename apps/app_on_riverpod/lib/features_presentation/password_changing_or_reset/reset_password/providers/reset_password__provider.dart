import 'package:core/base_modules/errors_management.dart' show Failure;
import 'package:features/features.dart' show PasswordRelatedUseCases;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_adapter/riverpod_adapter.dart'
    show SafeAsyncState, passwordUseCasesProvider;
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'reset_password__provider.g.dart';

/// 🧩 [resetPasswordProvider] — async notifier that handles password reset
/// 🧼 Uses [SafeAsyncState] to prevent post-dispose state updates
/// 🧼 Wraps logic in [AsyncValue.guard] for robust error handling
//
@riverpod
final class ResetPassword extends _$ResetPassword with SafeAsyncState<void> {
  ///--------------------------------------------------------------------

  /// 🧱 Initializes safe lifecycle tracking
  @override
  FutureOr<void> build() {
    initSafe();
  }

  /// 📩 Sends reset link to provided email via [PasswordRelatedUseCases]
  /// 🧼 Watches [passwordUseCasesProvider] to access domain logic
  /// ❗ Throws [Failure] if sending fails — handled via `.listen(...)` in UI
  Future<void> resetPassword({required String email}) async {
    if (state is AsyncLoading) return;
    state = const AsyncLoading();

    state = await AsyncValue.guard(() async {
      await updateSafely(() async {
        final useCase = ref.watch(passwordUseCasesProvider);
        final result = await useCase.callResetPassword(email);
        return result.fold((f) => throw f, (_) => null);
      });

      return;
    });
  }

  //
}

////
////

/// ⏳ Returns loading state for submission (primitive bool)
//
@riverpod
bool resetPasswordIsLoading(Ref ref) =>
    ref.watch(resetPasswordProvider.select((a) => a.isLoading));
