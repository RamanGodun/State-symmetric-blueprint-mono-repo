import 'package:equatable/equatable.dart' show Equatable;

/// 🔐 [AuthSnapshot] — sealed union representing the authentication state
//
sealed class AuthSnapshot extends Equatable {
  ///-------------------------------------
  const AuthSnapshot();
}

////
////

/// ⏳ Loading — while session/user resolution is in progress
//
final class AuthLoading extends AuthSnapshot {
  ///--------------------------------------
  const AuthLoading();
  @override
  List<Object?> get props => const [];
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
  //
  @override
  List<Object?> get props => <Object?>[
    error.runtimeType,
    error.toString(),
    // stackTrace — miss to avoid noise
  ];
}

////
////

/// ✅ Ready — resolved session with a valid user state
final class AuthReady extends AuthSnapshot {
  ///--------------------------------------
  const AuthReady(this._session);
  final AuthSession _session;
  //
  ///
  AuthSession get session => _session;
  //
  @override
  List<Object?> get props => [session];
}

////
////

/// 👤 [AuthSession] — normalized user session (UID/email/flags)
final class AuthSession extends Equatable {
  ///-----------------------------------
  const AuthSession({
    required this.emailVerified,
    required this.isAnonymous,
    this.uid,
    this.email,
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
  //
  @override
  List<Object?> get props => [uid, email, emailVerified, isAnonymous];
  //
}
