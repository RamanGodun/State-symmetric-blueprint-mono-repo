import 'package:firebase_bootstrap_config/firebase_constants.dart';
import 'package:firebase_bootstrap_config/firebase_types.dart'
    show FirebaseAuth, UsersCollection;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'firebase_providers.g.dart';

///
@riverpod
FirebaseAuth firebaseAuth(Ref ref) => FirebaseConstants.fbAuthInstance;

///
@riverpod
UsersCollection usersCollection(Ref ref) => FirebaseConstants.usersCollection;
