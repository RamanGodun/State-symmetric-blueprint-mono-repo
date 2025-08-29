import 'package:core/utils_shared/auth/auth_gateway.dart';
import 'package:core/utils_shared/auth/auth_snapshot.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb;
import 'package:rxdart/rxdart.dart';

/// 🔐 [FirebaseAuthGateway] — Firebase-backed implementation of [AuthGateway]
//
final class FirebaseAuthGateway implements AuthGateway {
  ///------------------------------------------------
  /// Initializes with a FirebaseAuth instance
  FirebaseAuthGateway(this._auth);
  final fb.FirebaseAuth _auth;

  // 🔁 Manual tick to force re-evaluation after explicit reload()
  final _tick$ = PublishSubject<void>();

  /// 🌐 Stream of normalized auth snapshots (loading/failure/ready)
  @override
  Stream<AuthSnapshot> get snapshots$ =>
      Rx.merge([
            _auth.userChanges().map((_) => null), // provider-driven changes
            _tick$.map((_) => null), // manual refresh
          ])
          .map<AuthSnapshot>((_) => _current())
          .distinct(_equal) // avoid redundant UI rebuilds
          .onErrorReturnWith(AuthFailure.new)
          .startWith(_current()); // instant seed

  /// 🔎 Returns current auth state as [AuthSnapshot]
  AuthSnapshot _current() {
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

  /// ⚖️ Equality comparator for distinct snapshot emissions
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

  /// 🔄 Reloads user and triggers snapshot refresh
  @override
  Future<void> refresh() async {
    await _auth.currentUser?.reload();
    _tick$.add(null);
  }

  /// 🧹 Closes internal streams to prevent leaks
  void dispose() => _tick$.close();

  //
}
