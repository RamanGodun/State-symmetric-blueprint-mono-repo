import 'package:firebase_bootstrap_config/firebase_constants.dart';
import 'package:firebase_bootstrap_config/firebase_types.dart'
    show CollectionReference, FirebaseAuth, UsersCollection;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

/*
import 'package:firebase_auth/firebase_auth.dart' show FirebaseAuth, User;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'firebase_auth_providers.g.dart';

/// 🔐 [firebaseAuthProvider] — Firebase Auth singleton instance
/// ✅ Exposes Firebase authentication for current user/session access
//
@riverpod
FirebaseAuth firebaseAuth(Ref ref) => FirebaseAuth.instance;

////
////

/// 🧩 [authStateStreamProvider] — Riverpod [StreamProvider] for Firebase user changes
/// ✅ Emits a new [User?] on every authentication state change
/// 🧼 Used for reactive auth flows and route protection

final authStateStreamProvider = StreamProvider<User?>((ref) {
  return FirebaseAuth.instance.userChanges();
});

 */

// specific_for_riverpod/user_auth_provider/firebase_auth_providers.dart

/// ⚠️ Токен-провайдер без дефолтної реалізації — має бути overridden у DI
// Базові провайдери (дефолт беруться зі статичних констант)
final firebaseAuthProvider = Provider<FirebaseAuth>(
  (ref) => FirebaseConstants.fbAuthInstance,
);

////
////

/// 🗃️ [usersCollectionProviderManual] — Firestore users collection reference
/// ✅ Provides access to the `users` collection for remote profile operations
//
@riverpod
CollectionReference<Map<String, dynamic>> usersCollection(Ref ref) =>
    FirebaseConstants.usersCollection;

////
////

///
final usersCollectionProviderManual = Provider<UsersCollection>(
  (ref) => FirebaseConstants.usersCollection,
);
