import 'package:blueprint_on_riverpod/features/auth/domain/use_cases/sign_out.dart'
    show SignOutUseCase;
import 'package:blueprint_on_riverpod/features/auth/domain/use_cases/use_cases_providers.dart';
import 'package:core/base_modules/errors_handling/core_of_module/failure_entity.dart'
    show Failure;
import 'package:core/utils_shared/riverpod_specific/safe_async_state.dart'
    show SafeAsyncState;
import 'package:features/profile/data/providers/data_layer_providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'sign_out_provider.g.dart';

/// 🔓 [signOutProvider] — async notifier for user sign-out
/// 🧼 Uses [SafeAsyncState] for lifecycle safety and cache cleanup
/// 🧼 Wraps result in [AsyncValue.guard]-like error propagation
//
@riverpod
final class SignOut extends _$SignOut with SafeAsyncState<void> {
  ///---------------------------------------------------------

  @override
  Future<void> build() async {
    initSafe();
  }

  /// 🚪 Performs user sign-out via [SignOutUseCase]
  /// 💥 Throws [Failure] on error and clears cached profile on success
  Future<void> signOut() async {
    state = const AsyncLoading();

    final useCase = ref.watch(signOutUseCaseProvider);
    final result = await useCase();

    if (result.isRight) {
      ref.read(profileRepoProvider).clearCache();
    }

    state = result.fold((f) => throw f, (_) => const AsyncData(null));
  }

  /// 🧼 Resets state to idle (null)
  void reset() => state = const AsyncData(null);

  //
}
