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
