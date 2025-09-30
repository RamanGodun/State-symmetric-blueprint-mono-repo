import 'package:features/features_barrels/email_verification/email_verification.dart';
import 'package:features/features_barrels/email_verification/email_verification_infra.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_adapter/src/core/utils/auth/firebase_providers.dart'
    show firebaseAuthProvider;
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
