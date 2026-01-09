import 'package:adapters_for_riverpod/src/features/auth/for_firebase/firebase_providers.dart'
    show firebaseAuthProvider;
import 'package:features_dd_layers/features_dd_layers.dart'
    show
        IUserValidationRemoteDataSource,
        IUserValidationRemoteDataSourceImpl,
        IUserValidationRepo,
        IUserValidationRepoImpl;
import 'package:flutter_riverpod/flutter_riverpod.dart' show Ref;
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'data_layer_providers.g.dart';

/// 📦 [emailVerificationRepoProvider] — provides validated domain repo
/// 🔁 Combines error mapping with remote data source delegation
//
@riverpod
IUserValidationRepo emailVerificationRepo(Ref ref) {
  final remote = ref.watch(userValidationRemoteDataSourceProvider);
  return IUserValidationRepoImpl(remote);
}

/// 🔌 [userValidationRemoteDataSourceProvider] — Remote DS for email verification
/// 🧠 Injects FirebaseAuth via [firebaseAuthProvider]
//
@riverpod
IUserValidationRemoteDataSource userValidationRemoteDataSource(Ref ref) {
  final fbAuth = ref.watch(firebaseAuthProvider);
  return IUserValidationRemoteDataSourceImpl(fbAuth);
}
