//
// ignore_for_file: public_member_api_docs

/// 🔐 [AuthSnapshot] — sealed union, що описує поточний стан автентифікації
//
sealed class AuthSnapshot {
  const AuthSnapshot();
}

/// ⏳ Loading — поки резолвиться сесія/користувач
final class AuthLoading extends AuthSnapshot {
  const AuthLoading();
}

/// ❌ Failure — помилка в auth-флоу (мережа/токен/…)
final class AuthFailure extends AuthSnapshot {
  //----------------------------------------
  const AuthFailure(this.error, [this.stackTrace]);

  final Object error;
  final StackTrace? stackTrace;
}

/// ✅ Ready — сесія успішно зібрана
final class AuthReady extends AuthSnapshot {
  const AuthReady(this._session);

  AuthSession get session => _session;
  final AuthSession _session;
}

/// 👤 [AuthSession] — нормалізована сесія користувача (UID/e-mail/флаги)
//
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

  /// 🟢 Автентифікований, якщо є UID
  bool get isAuthenticated => uid != null;
}
