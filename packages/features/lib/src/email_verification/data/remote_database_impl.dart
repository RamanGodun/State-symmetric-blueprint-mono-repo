import 'package:features/src/email_verification/data/remote_database_contract.dart';
import 'package:firebase_adapter/firebase_adapter.dart' show FirebaseAuth;
import 'package:flutter/foundation.dart' show debugPrint;

/// 🛠️ [IUserValidationRemoteDataSourceImpl] — low-level Firebase access (Auth only)
/// ⛓️ Dependencies are injected to keep `features` backend-agnostic.
/// 🚫 No failure mapping here — infra only; upstream repo maps errors.
//
final class IUserValidationRemoteDataSourceImpl
    implements IUserValidationRemoteDataSource {
  ///------------------------------------------------------------------------------------
  IUserValidationRemoteDataSourceImpl(this._auth);
  final FirebaseAuth _auth;
  //

  /// 📧 Sends verification email to the current user
  @override
  Future<void> sendVerificationEmail() async {
    final user = _auth.currentUser;
    if (user == null) throw StateError('No authorized user');
    debugPrint('Sending verification email to: ${user.email}');
    await user.sendEmailVerification();
    debugPrint('Verification email sent!');
  }

  /// 🔁 Reloads current user from FirebaseAuth
  @override
  Future<void> reloadUser() async {
    final user = _auth.currentUser;
    if (user == null) throw StateError('No authorized user');
    await user.reload();
  }

  /// ✅ Returns whether current user's email is verified
  @override
  bool isEmailVerified() {
    final user = _auth.currentUser;
    if (user == null) return false; // keep it non-throwing for sync read
    return user.emailVerified;
  }

  //
}
