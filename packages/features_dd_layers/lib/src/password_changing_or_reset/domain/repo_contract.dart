import 'package:shared_core_modules/public_api/base_modules/errors_management.dart'
    show ResultFuture;

/// 🧼 Contract for password-related operations with user account
//
abstract interface class IPasswordRepo {
  ///---------------------------------
  //
  /// 📩 Sends password reset link to the given email
  ResultFuture<void> sendResetLink(String email);
  //
  /// 🔁 Changes the password for the currently signed-in user
  ResultFuture<void> changePassword(String newPassword);
  //
}
