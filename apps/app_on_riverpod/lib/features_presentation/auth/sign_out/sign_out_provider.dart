import 'package:core/base_modules/errors_handling/core_of_module/failure_entity.dart'
    show Failure;
import 'package:features/features.dart' show SignOutUseCase;
import 'package:riverpod_adapter/features_providers/auth/domain_layer_providers/use_cases_providers.dart'
    show signOutUseCaseProvider;
import 'package:riverpod_adapter/features_providers/profile/data_layers_providers/data_layer_providers.dart'
    show profileRepoProvider;
import 'package:riverpod_adapter/utils/safe_async_state.dart';
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
