/// 📡 [IProfileRemoteDatabase] — abstraction for remote user profile access
/// 🧼 Defines contract for reading or creating user profile from database
//
abstract interface class IProfileRemoteDatabase {
  ///---------------------------------------------
  //
  /// 📥 Fetches user document by [uid], returns map or null if not found
  Future<Map<String, dynamic>?> fetchUserMap(String uid);
  //
  /// 🆕 Creates/updates user map in Firestore for given [uid]
  Future<void> createUserMap(String uid, Map<String, dynamic> data);
  //
  /// 🔐 Retrieves current authenticated user's basic info (for profile creation)
  Future<Map<String, dynamic>?> getCurrentUserAuthData();

  //
}
