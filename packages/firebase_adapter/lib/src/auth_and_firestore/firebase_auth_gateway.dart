import 'package:core/utils.dart'
    show
        AuthFailure,
        AuthGateway,
        AuthLoading,
        AuthReady,
        AuthSession,
        AuthSnapshot;
import 'package:firebase_auth/firebase_auth.dart' as fb;
import 'package:rxdart/rxdart.dart';

/// 🔐 [FirebaseAuthGateway] — Firebase-based implementation of [AuthGateway]
/// ✅ Normalizes FirebaseAuth state into [AuthSnapshot]
/// ✅ Provides both a reactive stream and synchronous snapshot access
///
final class FirebaseAuthGateway implements AuthGateway {
  ///------------------------------------------------
  /// 🔑 Underlying FirebaseAuth instance (injected from DI)
  FirebaseAuthGateway(this._auth);
  final fb.FirebaseAuth _auth;

  /// 🔁 Manual "tick" stream for forcing refresh after reload
  final _tick$ = PublishSubject<void>();

  /// 🌊 Stream of normalized [AuthSnapshot] values
  /// - Merges FirebaseAuth userChanges + manual refresh signals
  /// - Starts with [AuthLoading] before the first resolution
  /// - Distinct to prevent unnecessary rebuilds
  /// - Converts any errors into [AuthFailure]
  @override
  Stream<AuthSnapshot> get snapshots$ =>
      Rx.merge(<Stream<void>>[
            _auth.userChanges().map((_) {}), // provider-driven changes
            _tick$.map((_) {}), // manual refresh signal
          ])
          .map<AuthSnapshot>((_) => _buildSnapshot())
          .distinct(_equal)
          .onErrorReturnWith(AuthFailure.new)
          .startWith(const AuthLoading());

  /// 📊 Current synchronous snapshot of authentication state
  @override
  AuthSnapshot get currentSnapshot => _buildSnapshot();

  /// 🔎 Internal helper — build [AuthSnapshot] from current Firebase user
  AuthSnapshot _buildSnapshot() {
    final u = _auth.currentUser;
    return AuthReady(
      AuthSession(
        uid: u?.uid,
        email: u?.email,
        emailVerified: u?.emailVerified ?? false,
        isAnonymous: u?.isAnonymous ?? false,
      ),
    );
  }

  /// ⚖️ Equality check used by 'distinct' to minimize rebuilds
  static bool _equal(AuthSnapshot a, AuthSnapshot b) {
    if (a is AuthReady && b is AuthReady) {
      final x = a.session;
      final y = b.session;
      return x.uid == y.uid &&
          x.email == y.email &&
          x.emailVerified == y.emailVerified &&
          x.isAnonymous == y.isAnonymous;
    }
    return a.runtimeType == b.runtimeType;
  }

  /// 🔄 Reloads current user and emits a manual refresh signal
  @override
  Future<void> refresh() async {
    await _auth.currentUser?.reload();
    _tick$.add(null);
  }

  /// 🧹 Dispose internal streams to avoid memory leaks
  void dispose() => _tick$.close();

  //
}
