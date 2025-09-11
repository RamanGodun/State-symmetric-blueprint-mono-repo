import 'dart:async';

import 'package:bloc_adapter/bloc_adapter.dart';
import 'package:core/core.dart';
import 'package:features/features.dart' show FetchProfileUseCase;

/// 👤 [ProfileCubit] — Thin orchestrator over use case (no business logic here)
///     ✅ Auto-loads profile on auth changes
///     ✅ Seeds initial load via microtask to catch pre-ready auth state
///     ✅ Emits [CoreAsync<UserEntity>] so UI stays state-agnostic
//
final class ProfileCubit extends AsyncStateCubit<UserEntity> {
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
        .listen((uid) {
          // ⛔️ Logged out / no UID — keep idle UI (like Riverpod guard)
          if (uid == null) {
            _lastUid = null;
            emit(
              const AsyncState<UserEntity>.error(
                Failure(type: UserMissingFirebaseFailureType()),
              ),
            );
            return;
          }
          // ✅ Logged in — auto-load profile
          _lastUid = uid;
          load(uid);
        });
    //
    // 2) Seed initial state (synchronous snapshot) after listeners attach
    //    - covers case when AuthCubit is already Ready and stream is quiet
    scheduleMicrotask(() => _seedFrom(authCubit.state));
  }

  //
  final FetchProfileUseCase _fetchProfileUsecase;
  late final StreamSubscription<String?> _authSub;
  String? _lastUid;
  //

  /// ▶️ One-shot seeding from current auth state
  void _seedFrom(AuthViewState s) {
    final uid = switch (s) {
      AuthViewReady(:final session) => session.uid,
      _ => null,
    };
    if (uid == null) {
      _lastUid = null;
      emit(
        const AsyncState<UserEntity>.error(
          Failure(type: UserMissingFirebaseFailureType()),
        ),
      );
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
