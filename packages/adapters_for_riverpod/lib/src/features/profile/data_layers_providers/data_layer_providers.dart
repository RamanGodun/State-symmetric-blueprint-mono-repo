import 'package:adapters_for_riverpod/src/features/auth/for_firebase/firebase_providers.dart'
    show firebaseAuthProvider, usersCollectionProvider;
import 'package:features_dd_layers/public_api/profile/profile.dart'
    show IProfileRepo;
import 'package:features_dd_layers/public_api/profile/profile_infra.dart'
    show IProfileRemoteDatabase, ProfileRemoteDatabaseImpl, ProfileRepoImpl;
import 'package:flutter_riverpod/flutter_riverpod.dart' show Ref;
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'data_layer_providers.g.dart';

/// 🧩 [profileRepoProvider] — provides instance of [ProfileRepoImpl]
/// 🧠 Injects [IProfileRemoteDatabase] from [profileRemoteDataSourceProvider]
/// ✅ Adds caching, failure mapping, and DTO → Entity conversion
//
@riverpod
IProfileRepo profileRepo(Ref ref) {
  final remote = ref.watch(profileRemoteDataSourceProvider);
  return ProfileRepoImpl(remote);
}

////
////

/// 🔌 [profileRemoteDataSourceProvider] — provides instance of [ProfileRemoteDatabaseImpl]
/// 🧱 Handles direct Firestore access for fetching or creating user profile
//
@riverpod
IProfileRemoteDatabase profileRemoteDataSource(Ref ref) {
  final usersCollection = ref.watch(usersCollectionProvider);
  final fbAuth = ref.watch(firebaseAuthProvider);
  return ProfileRemoteDatabaseImpl(usersCollection, fbAuth);
}
