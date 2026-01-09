import 'package:adapters_for_firebase/adapters_for_firebase.dart'
    show FirebaseAuth;
import 'package:features_dd_layers/src/password_changing_or_reset/data/remote_database_contract.dart'
    show IPasswordRemoteDatabase;

/// 🧩 [PasswordRemoteDatabaseImpl] — low-level Firebase access (Auth only)
/// ⛓️ Dependencies are injected to keep `features` backend-agnostic.
/// 🚫 No failure mapping here — infra only; repo maps errors upstream.
//
final class PasswordRemoteDatabaseImpl implements IPasswordRemoteDatabase {
  ///-------------------------------------------------------------------
  PasswordRemoteDatabaseImpl(this._auth);
  final FirebaseAuth _auth;
  //

  /// 🔁 Updates password of the currently signed-in user
  @override
  Future<void> changePassword(String newPassword) async {
    final user = _auth.currentUser;
    if (user == null) throw StateError('No authorized user');
    await user.updatePassword(newPassword);
  }

  /// 📩 Sends reset password link to the provided email
  @override
  Future<void> sendResetLink(String email) async {
    await _auth.sendPasswordResetEmail(email: email);
  }

  //
}
