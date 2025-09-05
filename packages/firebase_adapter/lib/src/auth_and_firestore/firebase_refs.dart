import 'package:cloud_firestore/cloud_firestore.dart'
    show CollectionReference, FirebaseFirestore;
import 'package:firebase_auth/firebase_auth.dart' show FirebaseAuth;

/// 🗃️ [FirebaseRefs] — Centralized Firestore collection names
/// ✅ Use to avoid hardcoded strings throughout data layer
//
abstract final class FirebaseRefs {
  ///--------------------------------
  //
  @pragma('vm:prefer-inline')
  const FirebaseRefs._();

  /// 🧩 [usersCollectionRef] — Firestore reference to the `users` collection
  /// 📦 Used for fetching and storing user-specific data
  static final CollectionReference<Map<String, dynamic>> usersCollectionRef =
      FirebaseFirestore.instance.collection(
        'users',
      );

  /// 🧩 [auth] — Firebase Authentication instance
  /// 📦 Provides access to Firebase user-related auth methods
  static final FirebaseAuth auth = FirebaseAuth.instance;

  // 🧩 Extend with more collections as needed (e.g., 'tasks', 'chats', etc.)
}
