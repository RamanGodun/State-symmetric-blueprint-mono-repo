import 'dart:async' show StreamSubscription;

import 'package:bloc_adapter/utils/user_auth_cubit/auth_stream_cubit.dart';

/// 🗝️ [ResolvedOnceCache] — caches the "resolved at least once" flag
/// without triggering GoRouter rebuilds.
///
/// ✅ Becomes `true` after first [AuthViewError] or [AuthViewReady].
/// ✅ Useful for hysteresis in routing (avoid bouncing back to `/splash`).
final class ResolvedOnceCache {
  /// Initializes the cache and subscribes to [AuthViewState] stream.
  ResolvedOnceCache(Stream<AuthViewState> stream) {
    _sub = stream.listen((s) {
      if (s is AuthViewError || s is AuthViewReady) _resolvedOnce = true;
    });
  }

  /// 🔗 Active subscription to [AuthViewState] stream.
  late final StreamSubscription<AuthViewState> _sub;

  /// ⏳ Internal flag, becomes `true` after first non-loading state.
  bool _resolvedOnce = false;

  /// 👁️ Read-only access to the resolved flag.
  bool get value => _resolvedOnce;

  /// 🧹 Cancels underlying subscription.
  void dispose() => _sub.cancel();

  //
}
