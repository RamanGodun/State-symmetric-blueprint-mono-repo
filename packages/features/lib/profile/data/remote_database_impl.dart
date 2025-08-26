import 'package:features/profile/data/remote_database_contract.dart';
import 'package:firebase_adapter/firebase_typedefs.dart'
    show CollectionReference, FirebaseAuth;

/// 🛠️ [ProfileRemoteDatabaseImpl] — Firestore implementation of [IProfileRemoteDatabase]
/// ✅ Only low-level calls to Firestore/Auth, no business logic, no DTO<->Entity mapping
//
final class ProfileRemoteDatabaseImpl implements IProfileRemoteDatabase {
  ///-----------------------------------------------------------------
  ProfileRemoteDatabaseImpl(this._usersCollection, this._fbAuth);
  //
  final CollectionReference<Map<String, dynamic>> _usersCollection;
  final FirebaseAuth _fbAuth;
  //

  /// 📥 Fetches user document by [uid], returns map or null if not found
  @override
  Future<Map<String, dynamic>?> fetchUserMap(String uid) async {
    final doc = await _usersCollection.doc(uid).get();
    return doc.data();
  }

  /// 🆕 Creates/updates user map in Firestore for given [uid]
  @override
  Future<void> createUserMap(String uid, Map<String, dynamic> data) async {
    await _usersCollection.doc(uid).set(data);
  }

  /// 🔐 Retrieves current authenticated user's basic info (for profile creation)
  @override
  Future<Map<String, dynamic>?> getCurrentUserAuthData() async {
    final user = _fbAuth.currentUser;
    if (user == null) return null;
    return {
      'uid': user.uid,
      'name': user.displayName ?? '',
      'email': user.email ?? '',
    };
  }

  //
}
