import 'package:core/base_modules/errors_handling/core_of_module/failure_entity.dart'
    show Failure;
import 'package:features/features.dart' show PasswordRelatedUseCases;
import 'package:riverpod_adapter/features_providers/password_changing_or_reset/domain_layer_providers/use_cases_provider.dart'
    show passwordUseCasesProvider;
import 'package:riverpod_adapter/utils/safe_async_state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'reset_password__provider.g.dart';

/// 🧩 [resetPasswordProvider] — async notifier that handles password reset
/// 🧼 Uses [SafeAsyncState] to prevent post-dispose state updates
/// 🧼 Wraps logic in [AsyncValue.guard] for robust error handling
//
@riverpod
final class ResetPassword extends _$ResetPassword with SafeAsyncState<void> {
  //----------------------------------------------------------------

  /// 🧱 Initializes safe lifecycle tracking
  @override
  FutureOr<void> build() {
    initSafe();
  }

  /// 📩 Sends reset link to provided email via [PasswordRelatedUseCases]
  /// 🧼 Watches [passwordUseCasesProvider] to access domain logic
  /// ❗ Throws [Failure] if sending fails — handled via `.listen(...)` in UI
  Future<void> resetPassword({required String email}) async {
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
