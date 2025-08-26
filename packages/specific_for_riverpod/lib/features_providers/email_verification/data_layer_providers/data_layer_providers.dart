import 'package:features/email_verification/data/email_verification_repo_impl.dart';
import 'package:features/email_verification/data/remote_database_contract.dart';
import 'package:features/email_verification/data/remote_database_impl.dart';
import 'package:features/email_verification/domain/repo_contract.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:specific_for_riverpod/auth/firebase_providers.dart'
    show firebaseAuthProvider;

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
