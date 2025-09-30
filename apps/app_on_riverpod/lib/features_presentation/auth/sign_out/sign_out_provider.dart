import 'package:core/public_api/core.dart';
import 'package:features/features.dart';
import 'package:riverpod_adapter/riverpod_adapter.dart';
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
    if (state is AsyncLoading) return;
    state = const AsyncLoading();
    //
    final useCase = ref.watch(signOutUseCaseProvider);
    final result = await useCase();
    //
    if (result.isRight) {
      ref.read(profileRepoProvider).clearCache();
    }
    //
    state = result.fold((f) => throw f, (_) => const AsyncData(null));
  }

  /// 🧼 Resets state to idle (null)
  void reset() => state = const AsyncData(null);

  //
}
