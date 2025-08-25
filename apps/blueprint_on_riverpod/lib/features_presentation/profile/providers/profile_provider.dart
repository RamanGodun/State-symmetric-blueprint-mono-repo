import 'package:core/base_modules/errors_handling/core_of_module/failure_entity.dart'
    show Failure;
import 'package:core/shared_domain_layer/shared_entities/_user_entity.dart'
    show UserEntity;
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:specific_for_riverpod/features_providers/profile/domain_layer_providers/use_case_provider.dart';
import 'package:specific_for_riverpod/utils/safe_async_state.dart';

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
