// packages/firebase_bootstrap_config/lib/firebase_auth_gateway.dart
//
// ignore_for_file: public_member_api_docs

import 'package:core/utils_shared/auth/auth_gateway.dart';
import 'package:core/utils_shared/auth/auth_snapshot.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb;
import 'package:rxdart/rxdart.dart';

final class FirebaseAuthGateway implements AuthGateway {
  FirebaseAuthGateway(this._auth);
  final fb.FirebaseAuth _auth;

  // тригер для ручного оновлення (після reload)
  final _tick$ = PublishSubject<void>();

  @override
  Stream<AuthSnapshot> get snapshots$ =>
      Rx.merge([
            _auth.userChanges().map((_) => null),
            _tick$.map((_) => null),
          ])
          .map<AuthSnapshot>((_) {
            final u = _auth.currentUser;
            return AuthReady(
              AuthSession(
                uid: u?.uid,
                email: u?.email,
                emailVerified: u?.emailVerified ?? false,
                isAnonymous: u?.isAnonymous ?? false,
              ),
            );
          })
          .distinct((prev, next) {
            if (prev is AuthReady && next is AuthReady) {
              final a = prev.session;
              final b = next.session;
              return a.uid == b.uid &&
                  a.emailVerified == b.emailVerified &&
                  a.isAnonymous == b.isAnonymous;
            }
            return false;
          })
          .onErrorReturnWith(AuthFailure.new)
          .startWith(const AuthLoading());

  // @override
  // Future<void> refresh() async {
  //   await _auth.currentUser?.reload();
  //   _tick$.add(null);
  // }
}
