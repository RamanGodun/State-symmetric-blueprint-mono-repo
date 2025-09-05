/// 🔐 [AuthSnapshot] — sealed union representing the authentication state
//
sealed class AuthSnapshot {
  const AuthSnapshot();
}

////
////

/// ⏳ Loading — while session/user resolution is in progress
//
final class AuthLoading extends AuthSnapshot {
  ///--------------------------------------
  const AuthLoading();
}

////
////

/// ❌ Failure — error occurred in the auth flow (network/token/other)
//
final class AuthFailure extends AuthSnapshot {
  ///--------------------------------------
  const AuthFailure(this.error, [this.stackTrace]);
  //
  ///
  final Object error;
  //
  ///
  final StackTrace? stackTrace;
}

////
////

/// ✅ Ready — resolved session with a valid user state
final class AuthReady extends AuthSnapshot {
  ///--------------------------------------
  const AuthReady(this._session);
  //
  ///
  AuthSession get session => _session;
  final AuthSession _session;
}

////
////

/// 👤 [AuthSession] — normalized user session (UID/email/flags)
final class AuthSession {
  ///-----------------
  const AuthSession({
    required this.uid,
    required this.email,
    required this.emailVerified,
    required this.isAnonymous,
  });
  //
  ///
  final String? uid;
  //
  ///
  final String? email;
  //
  ///
  final bool emailVerified;
  //
  ///
  final bool isAnonymous;
  //
  /// 🟢 User is considered authenticated if UID is non-null
  bool get isAuthenticated => uid != null;
}
