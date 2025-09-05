import 'package:core/utils_shared/auth/auth_gateway.dart';
import 'package:core/utils_shared/auth/auth_snapshot.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb;
import 'package:rxdart/rxdart.dart';

/// 🔐 [FirebaseAuthGateway] — реалізація [AuthGateway] поверх Firebase
//
final class FirebaseAuthGateway implements AuthGateway {
  ///----------------------------------------------
  FirebaseAuthGateway(this._auth);
  final fb.FirebaseAuth _auth;

  // 🔁 Ручний “тик” для форс-оновлення після reload/refresh
  final _tick$ = PublishSubject<void>();

  /// 🌊 Стрім нормалізованих snapshot-ів (із початковим Loading)
  @override
  Stream<AuthSnapshot> get snapshots$ =>
      Rx.merge(<Stream<void>>[
            _auth.userChanges().map((_) {}), // provider-driven changes
            _tick$.map((_) {}), // manual refresh signal
          ])
          .map<AuthSnapshot>((_) => _buildSnapshot())
          .distinct(_equal) // фільтр зайвих емісій
          .onErrorReturnWith(AuthFailure.new) // any error -> Failure
          // ⏳ Починаємо з Loading, наступна емісія — реальний стан
          .startWith(const AuthLoading());

  /// 📊 Синхронний знімок поточного стану
  @override
  AuthSnapshot get currentSnapshot => _buildSnapshot();

  /// 🔎 Збір поточного стану у [AuthSnapshot]
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

  /// ⚖️ Порівняння для distinct: мінімізує зайві rebuild-и
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

  /// 🔄 Reload юзера + повідомити слухачів
  @override
  Future<void> refresh() async {
    await _auth.currentUser?.reload();
    _tick$.add(null);
  }

  /// 🧹 Закриття внутр. стрімів
  void dispose() => _tick$.close();
}
