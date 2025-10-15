import 'dart:async';
import 'package:app_on_bloc/features/profile/cubit/profile_page_cubit.dart';
import 'package:bloc_adapter/bloc_adapter.dart';

/// 🚀 [WarmupController] — app-scope “pre-heater” for the BLoC app.
/// ✅ Keeps critical cubits hot and synchronized from the very start
/// 🎯 Curently used only for [ProfileCubit] => avoids cold-start flicker as soon as UID is known.
//
final class WarmupController {
  ///-----------------------
  /// Binds [AuthCubit] → [ProfileCubit]:
  ///  - Seeds once from the synchronous snapshot
  ///  - Reacts continuously to auth stream
  WarmupController({
    required AuthCubit authCubit,
    required ProfileCubit profileCubit,
  }) : _profileCubit = profileCubit {
    // ▶️ Seed from current state (no delay)
    _seedFrom(authCubit.state);
    // 🔁 Then reactively listen to auth changes
    _sub = authCubit.stream.listen(_onAuth);
  }
  //
  final ProfileCubit _profileCubit;
  //
  late final StreamSubscription<AuthViewState> _sub;

  ////

  /// 👤 Initial seeding from synchronous [AuthCubit.state].
  void _seedFrom(AuthViewState s) {
    final uid = switch (s) {
      AuthViewReady(:final session) => session.uid,
      _ => null,
    };
    uid != null ? _profileCubit.prime(uid) : _profileCubit.resetState();
  }

  /// 🔁 React to subsequent auth state changes.
  void _onAuth(AuthViewState s) {
    final uid = switch (s) {
      AuthViewReady(:final session) => session.uid,
      _ => null,
    };
    uid != null ? _profileCubit.prime(uid) : _profileCubit.resetState();
  }

  ////

  /// ♻️ Dispose subscription when shutting down.
  Future<void> dispose() => _sub.cancel();
  //
}
