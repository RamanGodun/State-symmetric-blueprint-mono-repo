part of 'go_router__provider.dart';

/// 🔒 [_AuthRedirectState] — local redirect state holder
/// - Caches latest auth snapshot & “resolved once” flag
/// - Attaches to Riverpod lifecycle (listen + dispose) without rebuilding GoRouter
//
final class _AuthRedirectState {
  ///------------------------
  _AuthRedirectState();

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

  /// 👁️ Read helpers
  AuthSnapshot? get current => authSnapshotVN.value;
  bool get resolvedOnce => resolvedOnceVN.value;
}
