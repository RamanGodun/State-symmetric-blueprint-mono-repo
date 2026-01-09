/// 🛰️ [IUserValidationRemoteDataSource] — abstract contract for remote data base
/// 🧱 Defines low-level user auth operations
//
abstract interface class IUserValidationRemoteDataSource {
  ///--------------------------------------------------
  //
  /// 📧 Sends verification email to current user
  Future<void> sendVerificationEmail();

  /// 🔁 Reloads current user from FirebaseAuth
  Future<void> reloadUser();

  /// ✅ Returns whether current user's email is verified
  bool isEmailVerified();
  //
}
