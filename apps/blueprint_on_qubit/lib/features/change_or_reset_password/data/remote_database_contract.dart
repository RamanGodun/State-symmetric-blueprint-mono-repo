/// 📡 [IPasswordRemoteDatabase] — contract for low-level password operations
/// ✅ Abstracts infrastructure layer (e.g., Firebase)
//
abstract interface class IPasswordRemoteDatabase {
  ///--------------------------------------------
  //
  /// 🔁 Updates password of the currently signed-in user
  Future<void> changePassword(String newPassword);

  /// 📩 Sends reset link to given email
  Future<void> sendResetLink(String email);
}
