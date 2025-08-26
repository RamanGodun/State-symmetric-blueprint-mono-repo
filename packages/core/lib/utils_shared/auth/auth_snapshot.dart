/// 🔐 [AuthSnapshot] — sealed union describing current authentication state
/// - Base class for all auth state variants (loading/failure/ready)
//
sealed class AuthSnapshot {
  ///---------------------
  const AuthSnapshot();
}

////

////

/// ⏳ Loading state — emitted while auth session is being resolved
final class AuthLoading extends AuthSnapshot {
  ///----------------------------------------
  const AuthLoading();
}

////
////

/// ❌ Failure state — emitted when auth flow fails (network/error)
final class AuthFailure extends AuthSnapshot {
  ///----------------------------------------
  const AuthFailure(this.error, [this.stackTrace]);

  /// Root cause of failure (network, invalid token, etc.)
  final Object error;

  /// Optional stack trace for debugging/logging
  final StackTrace? stackTrace;
}

////
////

/// ✅ Ready state — emitted when user session is successfully resolved
final class AuthReady extends AuthSnapshot {
  ///--------------------------------------
  const AuthReady(this._session);
  //
  /// Current authenticated session
  AuthSession get session => _session;
  final AuthSession _session;
}

////
////

/// 👤 [AuthSession] — normalized, platform-agnostic user session model
/// - Encapsulates uid/email/flags from provider (Firebase/Auth0/etc)
///
final class AuthSession {
  ///-------------------
  const AuthSession({
    required this.uid,
    required this.email,
    required this.emailVerified,
    required this.isAnonymous,
  });

  /// Unique user ID (null if guest or unauthenticated)
  final String? uid;

  /// Primary email (nullable if provider doesn’t supply)
  final String? email;

  /// Whether email is verified
  final bool emailVerified;

  /// Whether session is anonymous (guest login)
  final bool isAnonymous;

  /// 🟢 True if user is signed in (uid != null)
  bool get isAuthenticated => uid != null;

  //
}
