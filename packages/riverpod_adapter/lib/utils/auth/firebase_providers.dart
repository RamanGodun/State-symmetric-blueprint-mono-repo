import 'package:firebase_adapter/constants/firebase_constants.dart';
import 'package:firebase_adapter/firebase_typedefs.dart'
    show FirebaseAuth, UsersCollection;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'firebase_providers.g.dart';

/// 🔑 [firebaseAuthProvider] — global binding to FirebaseAuth
/// ✅ Provides the environment-specific FirebaseAuth instance
//
@Riverpod(keepAlive: true)
FirebaseAuth firebaseAuth(Ref ref) => FirebaseConstants.fbAuthInstance;

////
////

/// 🗃️ [usersCollectionProvider] — global binding to Firestore users collection
/// ✅ Provides the environment-specific Firestore users collection reference
//
@Riverpod(keepAlive: true)
UsersCollection usersCollection(Ref ref) => FirebaseConstants.usersCollection;
