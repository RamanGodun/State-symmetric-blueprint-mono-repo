import 'package:adapters_for_firebase/adapters_for_firebase.dart'
    show FirebaseAuth, FirebaseRefs, UsersCollection;
import 'package:flutter_riverpod/flutter_riverpod.dart' show Ref;
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'firebase_providers.g.dart';

/// 🔑 [firebaseAuthProvider] — global binding to FirebaseAuth
/// ✅ Provides the environment-specific FirebaseAuth instance
//
@Riverpod(keepAlive: true)
FirebaseAuth firebaseAuth(Ref ref) => FirebaseRefs.auth;

////
////

/// 🗃️ [usersCollectionProvider] — global binding to Firestore users collection
/// ✅ Provides the environment-specific Firestore users collection reference
//
@Riverpod(keepAlive: true)
UsersCollection usersCollection(Ref ref) => FirebaseRefs.usersCollectionRef;
