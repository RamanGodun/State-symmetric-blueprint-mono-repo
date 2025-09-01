import 'dart:async' show StreamSubscription;

import 'package:bloc_adapter/utils/user_auth_cubit/auth_stream_cubit.dart';

/// 🗝️ [ResolvedOnceCache] — one-shot flag tracker for auth resolution
/// ✅ Becomes `true` after first [AuthViewError] or [AuthViewReady]
/// ✅ Prevents GoRouter from bouncing back to `/splash` after initial load
//
final class ResolvedOnceCache {
  ///-----------------------
  /// Subscribes to [AuthViewState] stream and flips `_resolvedOnce` once stable
  ResolvedOnceCache(Stream<AuthViewState> stream) {
    _sub = stream.listen((s) {
      if (s is AuthViewError || s is AuthViewReady) _resolvedOnce = true;
    });
  }

  /// 🔗 Active subscription to auth state stream
  late final StreamSubscription<AuthViewState> _sub;

  /// ⏳ Flag set after first non-loading state
  bool _resolvedOnce = false;

  /// 👁️ Exposed read-only flag
  bool get value => _resolvedOnce;

  /// 🧹 Cancel subscription when cache is disposed
  void dispose() => _sub.cancel();

  //
}
