import 'package:firebase_adapter/constants/firebase_constants.dart';
import 'package:firebase_adapter/firebase_typedefs.dart'
    show FirebaseAuth, UsersCollection;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'firebase_providers.g.dart';

/// 🔑 FirebaseAuth handle (env binding)
//
@Riverpod(keepAlive: true)
FirebaseAuth firebaseAuth(Ref ref) => FirebaseConstants.fbAuthInstance;

////
////

/// 🗃️ Firestore users collection (env binding)
//
@Riverpod(keepAlive: true)
UsersCollection usersCollection(Ref ref) => FirebaseConstants.usersCollection;
