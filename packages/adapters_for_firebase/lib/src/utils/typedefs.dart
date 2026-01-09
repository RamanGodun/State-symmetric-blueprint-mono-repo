import 'package:cloud_firestore/cloud_firestore.dart'
    show CollectionReference, FirebaseException;
import 'package:firebase_auth/firebase_auth.dart' show User;

/// ✅ Expose base Firebase types for DI and features
/// Import this file instead of `firebase_auth` or `cloud_firestore`
export 'package:cloud_firestore/cloud_firestore.dart' show CollectionReference;
export 'package:firebase_auth/firebase_auth.dart' show FirebaseAuth, User;

/// ✅ Firestore collection reference with `Map<String, dynamic>` payload
typedef UsersCollection = CollectionReference<Map<String, dynamic>>;

////

/// ✅ Firebase user entity from FirebaseAuth
typedef FirebaseUser = User;

////

/// 🔄 [FBException] — shorthand typedef for [FirebaseException]
/// 💡 Use everywhere instead of importing `FirebaseException` directly
typedef FBException = FirebaseException;
