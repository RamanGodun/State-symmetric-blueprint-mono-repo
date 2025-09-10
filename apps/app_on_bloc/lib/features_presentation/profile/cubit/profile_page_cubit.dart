import 'dart:async';

import 'package:bloc_adapter/bloc_adapter.dart';
import 'package:core/core.dart';
import 'package:features/features.dart' show FetchProfileUseCase;

/// 👤 [ProfileCubit] — Thin orchestrator over use case (no business logic here)
/// ✅ Auto-loads profile on auth changes (UI-driven)
/// ✅ Emits [CoreAsync<UserEntity>] so UI stays state-agnostic
//
final class ProfileCubit extends AsyncStateCubit<UserEntity> {
  ///-----------------------------------------------
  ProfileCubit(
    this._fetchProfileUsecase, {
    required AuthCubit authCubit, // ← subscribe to auth changes
  }) : super() {
    _authSub = authCubit.stream
        .map(
          (s) => switch (s) {
            AuthViewReady(:final session) => session.uid,
            _ => null,
          },
        )
        .distinct()
        .listen((uid) {
          // ⛔️ Logged out / no UID — keep idle UI (like Riverpod guard)
          if (uid == null) {
            // optional: reset to loading/initial depending on UX expectations
            emit(const AsyncState.loading());
            _lastUid = null;
            return;
          }

          // ✅ Logged in — auto-load profile
          _lastUid = uid;
          load(uid);
        });
  }

  //
  final FetchProfileUseCase _fetchProfileUsecase;
  late final StreamSubscription<String?> _authSub;
  String? _lastUid;

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
