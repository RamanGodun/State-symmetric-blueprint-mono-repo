import 'package:features/password_changing_or_reset/data/remote_database_contract.dart';
import 'package:firebase_bootstrap_config/firebase_config/auth_user_utils.dart';
import 'package:firebase_bootstrap_config/firebase_config/firebase_constants.dart';

/// 🧩 [PasswordRemoteDatabaseImpl] — Firebase-based implementation of [IPasswordRemoteDatabase]
/// ✅ Handles actual communication with [FirebaseConstants]
//
final class PasswordRemoteDatabaseImpl implements IPasswordRemoteDatabase {
  ///-----------------------------------------------------------------------
  //

  @override
  Future<void> changePassword(String newPassword) async {
    final user = AuthUserUtils.currentUserOrThrow;
    await user.updatePassword(newPassword);
  }

  @override
  Future<void> sendResetLink(String email) async {
    await FirebaseConstants.fbAuth.sendPasswordResetEmail(email: email);
  }

  //
}
