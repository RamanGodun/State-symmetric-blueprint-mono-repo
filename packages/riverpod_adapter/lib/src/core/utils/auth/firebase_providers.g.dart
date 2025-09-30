// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'firebase_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$firebaseAuthHash() => r'53ac60fd2b217bd05f92df15b56fd6e30c769d9c';

/// 🔑 [firebaseAuthProvider] — global binding to FirebaseAuth
/// ✅ Provides the environment-specific FirebaseAuth instance
///
/// Copied from [firebaseAuth].
@ProviderFor(firebaseAuth)
final firebaseAuthProvider = Provider<FirebaseAuth>.internal(
  firebaseAuth,
  name: r'firebaseAuthProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$firebaseAuthHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef FirebaseAuthRef = ProviderRef<FirebaseAuth>;
String _$usersCollectionHash() =>
    r'6af4c8c8d2acce9770c896a68ceb93c0749499aa'; ////
////
/// 🗃️ [usersCollectionProvider] — global binding to Firestore users collection
/// ✅ Provides the environment-specific Firestore users collection reference
///
/// Copied from [usersCollection].
@ProviderFor(usersCollection)
final usersCollectionProvider = Provider<UsersCollection>.internal(
  usersCollection,
  name: r'usersCollectionProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$usersCollectionHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef UsersCollectionRef = ProviderRef<UsersCollection>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
