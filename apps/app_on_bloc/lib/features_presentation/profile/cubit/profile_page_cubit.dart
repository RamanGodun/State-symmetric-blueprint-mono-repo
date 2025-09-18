import 'dart:async';

import 'package:bloc_adapter/bloc_adapter.dart';
import 'package:core/core.dart';
import 'package:features/features.dart' show FetchProfileUseCase;

/// 👤 [ProfileCubit] — Thin orchestrator over use case (no business logic here)
///     ✅ Auto-loads profile on auth changes
///     ✅ Seeds initial load via microtask to catch pre-ready auth state
///     ✅ Emits [CoreAsync<UserEntity>] so UI stays state-agnostic
//
final class ProfileCubit extends CubitWithAsyncState<UserEntity> {
  ///-----------------------------------------------------
  ProfileCubit(
    this._fetchProfileUsecase, {
    required AuthCubit authCubit, // ← subscribe to auth changes
  }) : super() {
    // 1) Subscribe to auth changes (reactive path)
    emit(const AsyncState<UserEntity>.loading());
    _authSub = authCubit.stream
        .map(
          (s) => switch (s) {
            AuthViewReady(:final session) => session.uid,
            _ => null,
          },
        )
        .distinct()
        .listen(_onUidChanged);
    // 2) Seed initial state (synchronous snapshot) after listeners attach (covers edge case when AuthCubit is already ready and stream is quiet)
    scheduleMicrotask(() => _seedFrom(authCubit.state));
  }

  //
  final FetchProfileUseCase _fetchProfileUsecase;
  late final StreamSubscription<String?> _authSub;
  String? _lastUid;
  //

  /// 🔄 Handles auth state changes (UID updates)
  /// - `null` → user signed out → reset to loading (quiet state, not error)
  /// - non-null → load profile for that UID
  void _onUidChanged(String? uid) {
    if (uid == null) {
      _lastUid = null;
      // 🔑 User signed out — emit loading to keep UI idle instead of error
      emit(const AsyncState<UserEntity>.loading());
      return;
    }
    _lastUid = uid;
    load(uid);
  }

  /// ▶️ One-shot seeding from current auth state
  void _seedFrom(AuthViewState s) {
    final uid = switch (s) {
      AuthViewReady(:final session) => session.uid,
      _ => null,
    };
    if (uid == null) {
      _lastUid = null;
      emit(const AsyncState<UserEntity>.loading());
      return;
    }
    _lastUid = uid;
    load(uid);
  }

  /// 🚀 Public API — manual explicit load (used by auth listener above)
  Future<void> load(String uid) async {
    await loadTask(() async {
      final result = await _fetchProfileUsecase(uid);
      // Throw Failure to hit CoreAsyncCubit's catcher (unified mapping)
      return result.fold((f) => throw f, (u) => u);
    });
  }

  /// ♻️ Pull-to-refresh (uses last known UID)
  Future<void> refresh() async {
    final uid = _lastUid;
    if (uid != null) {
      await load(uid);
    }
  }

  /// 🧹 Dispose subscription to avoid leaks
  @override
  Future<void> close() async {
    await _authSub.cancel();
    return super.close();
  }

  //
}
