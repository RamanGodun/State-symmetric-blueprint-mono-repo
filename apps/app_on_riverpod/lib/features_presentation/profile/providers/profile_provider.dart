import 'package:core/core.dart' show Failure, UserEntity;
import 'package:firebase_adapter/firebase_adapter.dart'
    show GuardedFirebaseUser;
import 'package:riverpod_adapter/riverpod_adapter.dart'
    show ErrorsListenerForAppOnRiverpod, fetchProfileUseCaseProvider;
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'profile_provider.g.dart';

/// 👤 [profileProvider] — async notifier that fetches user profile
/// 🧼 Declarative-only approach, throws [Failure] and is handled in [ErrorsListenerForAppOnRiverpod]
//
@riverpod
final class Profile extends _$Profile {
  ///--------------------------------

  @override
  Future<UserEntity> build() async {
    //

    final uid = GuardedFirebaseUser.uid;
    /*
          ? if need reactive dependence, then:
      final uid = await ref.watch(authUidProvider.future) ??
                  (throw const Failure(type: UserMissingFirebaseFailureType()));
 */
    //
    final useCase = ref.watch(fetchProfileUseCaseProvider);
    final result = await useCase(uid);
    //
    return result.fold((f) => throw f, (user) => user);
  }

  ////

  /// ♻️ Refetch user manually (e.g. pull-to-refresh)
  Future<void> refresh() async {
    //
    state = const AsyncLoading();

    final uid = GuardedFirebaseUser.uid;
    final useCase = ref.read(fetchProfileUseCaseProvider);
    //
    state = await AsyncValue.guard(() async {
      final result = await useCase(uid);
      return result.fold((f) => throw f, (user) => user);
    });
  }

  /// 🧼 Optional reset (usually after logout)
  void reset() => ref.invalidateSelf();

  //
}
