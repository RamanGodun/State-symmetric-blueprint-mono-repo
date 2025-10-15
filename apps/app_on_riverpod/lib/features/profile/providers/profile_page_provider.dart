import 'package:core/public_api/core.dart' show AuthReady, UserEntity;
import 'package:riverpod_adapter/riverpod_adapter.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'profile_page_provider.g.dart';

/// 👤 [profileProvider] — keeps the authenticated user's profile.
/// ✅ Mirrors the BLoC counterpart ['ProfileCubit'] API (prime / refresh / reset).
/// 🎯 UX: preserves existing UI on background updates (no full-screen loader).
//
@Riverpod(keepAlive: true)
final class Profile extends _$Profile {
  ///-------------------------------
  //
  /// ▶️ Warmup provider triggers the first _load; we just expose the future.
  @override
  Future<UserEntity> build() => future;

  ////

  /// 👤 Pre-fetch profile (used by warmup).
  /// 🧩 Keeps previous UI content (no full-screen loader).
  Future<void> prime(String uid) async => _load(uid, preserveUi: true);

  /// 🔄 Manual refresh from UI (e.g., pull-to-refresh).
  Future<void> refresh() async {
    final snap = ref.read(authGatewayProvider).currentSnapshot;
    final uid = (snap is AuthReady) ? snap.session.uid : null;
    if (uid != null) await _load(uid, preserveUi: true);
  }

  /// 🚀 Internal loader with optional UI preservation.
  Future<void> _load(String uid, {required bool preserveUi}) async {
    final useCase = ref.read(fetchProfileUseCaseProvider);
    preserveUi
        ?
          // 🔑 Keep previous data visible while refreshing.
          state = const AsyncLoading<UserEntity>().copyWithPrevious(state)
        :
          // ⏳ Clear UI before loading new data.
          state = const AsyncLoading<UserEntity>();
    //
    // 🛡️ Guard errors and map to AsyncValue.
    state = await AsyncValue.guard(() async {
      final res = await useCase(uid);
      return res.fold((f) => throw f, (u) => u);
    });
  }

  ////

  /// ♻️ Reset provider state (usually after logout).
  void resetState() => ref.invalidateSelf();
  //
}
