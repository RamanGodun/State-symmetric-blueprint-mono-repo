import 'package:core/core.dart' show Failure, UserEntity;
import 'package:riverpod_adapter/riverpod_adapter.dart'
    show SafeAsyncState, fetchProfileUseCaseProvider;
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'profile_provider.g.dart';

/// 👤 [profileProvider] — async notifier that fetches user profile
/// 🧼 Declarative-only approach, throws [Failure] and is handled in `.listenFailure(...)`
/// 🧼 Compatible with `.family` and avoids breaking [SafeAsyncState] limitations
//
@riverpod
final class Profile extends _$Profile {
  //--------------------------------

  @override
  Future<UserEntity> build(String uid) async {
    final useCase = ref.watch(fetchProfileUseCaseProvider);
    final result = await useCase(uid);
    return result.fold((f) => throw f, (user) => user);
  }

  /// ♻️ Refetch user manually (e.g. pull-to-refresh)
  Future<void> refresh() async {
    state = const AsyncLoading();
    final useCase = ref.read(fetchProfileUseCaseProvider);

    state = await AsyncValue.guard(() async {
      final result = await useCase(uid);
      return result.fold((f) => throw f, (user) => user);
    });
  }

  /// 🧼 Optional reset (usually after logout)
  void reset() => ref.invalidateSelf();

  //
}
