//
// ignore_for_file: public_member_api_docs

sealed class AuthSnapshot {
  const AuthSnapshot();
}

final class AuthLoading extends AuthSnapshot {
  const AuthLoading();
}

final class AuthFailure extends AuthSnapshot {
  const AuthFailure(this.error, [this.stackTrace]);
  final Object error;
  final StackTrace? stackTrace;
}

final class AuthReady extends AuthSnapshot {
  const AuthReady(this._session);
  AuthSession get session => _session;
  final AuthSession _session;
}

final class AuthSession {
  const AuthSession({
    required this.uid,
    required this.email,
    required this.emailVerified,
    required this.isAnonymous,
  });

  final String? uid;
  final String? email;
  final bool emailVerified;
  final bool isAnonymous;

  bool get isAuthenticated => uid != null;
}
