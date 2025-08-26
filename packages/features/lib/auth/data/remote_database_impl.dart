import 'package:features/auth/data/remote_database_contract.dart';
import 'package:firebase_adapter/firebase_typedefs.dart'
    show FirebaseAuth, UsersCollection;

/// 🛠️ [AuthRemoteDatabaseImpl] — low-level Firebase access (Auth + users collection)
/// ⛓️ Dependencies are injected to keep `features` package backend-agnostic.
//
final class AuthRemoteDatabaseImpl implements IAuthRemoteDatabase {
  ///-----------------------------------------------------------
  AuthRemoteDatabaseImpl(this._auth, this._users);

  final FirebaseAuth _auth;
  final UsersCollection _users;

  /// 🔐 Firebase sign-in
  @override
  Future<void> signIn({required String email, required String password}) async {
    await _auth.signInWithEmailAndPassword(email: email, password: password);
  }

  /// 🆕 Sign up → returns UID only
  @override
  Future<String> signUp({
    required String email,
    required String password,
  }) async {
    final cred = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    return cred.user?.uid ?? '';
  }

  /// 💾 Save user document in `users` collection
  @override
  Future<void> saveUserData(String uid, Map<String, dynamic> userData) async {
    await _users.doc(uid).set(userData);
  }

  /// 🔓 Sign out
  @override
  Future<void> signOut() async {
    await _auth.signOut();
  }

  //
}
