import 'package:core/utils_shared/auth/auth_snapshot.dart';
import 'package:flutter/material.dart' show ValueNotifier;
import 'package:flutter_riverpod/flutter_riverpod.dart' show AsyncValueX, Ref;
import 'package:riverpod_adapter/utils/auth/auth_stream_adapter.dart'
    show authSnapshotsProvider;

/// 🔒 [AuthRedirectState] — local redirect state holder
/// - Caches latest auth snapshot & “resolved once” flag
/// - Attaches to Riverpod lifecycle (listen + dispose) without rebuilding GoRouter
//
final class AuthRedirectState {
  ///------------------------
  AuthRedirectState();

  /// 🧠 Latest normalized auth snapshot (null until first emission)
  final ValueNotifier<AuthSnapshot?> authSnapshotVN =
      ValueNotifier<AuthSnapshot?>(null);

  /// ⏳ Becomes true after first non-loading snapshot (Ready/Failure)
  final ValueNotifier<bool> resolvedOnceVN = ValueNotifier<bool>(false);

  /// 🔌 Wire listeners to Riverpod without triggering rebuilds of GoRouter
  void attach(Ref ref) {
    ref
      ..listen(authSnapshotsProvider, (prev, next) {
        final s = next.valueOrNull;
        if (s != null) authSnapshotVN.value = s;

        if (s case AuthFailure() || AuthReady()) {
          resolvedOnceVN.value = true;
        }
      })
      // ♻️ Dispose with provider lifecycle
      ..onDispose(() {
        authSnapshotVN.dispose();
        resolvedOnceVN.dispose();
      });
  }

  /// 👁️ Returns the latest cached [AuthSnapshot],
  /// or `null` if the auth state has not yet been emitted.
  AuthSnapshot? get current => authSnapshotVN.value;

  /// ⏳ Returns `true` once at least one [AuthFailure] or [AuthReady] snapshot
  /// has been observed, ensuring redirect logic won’t bounce back to `/splash`.
  bool get resolvedOnce => resolvedOnceVN.value;

  //
}
