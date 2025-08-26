import 'package:features/auth/data/auth_repo_implementations/sign_in_repo_impl.dart';
import 'package:features/auth/data/auth_repo_implementations/sign_out_repo_impl.dart';
import 'package:features/auth/data/auth_repo_implementations/sign_up_repo_impl.dart';
import 'package:features/auth/data/remote_database_contract.dart';
import 'package:features/auth/data/remote_database_impl.dart';
import 'package:features/auth/domain/repo_contracts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:specific_for_riverpod/auth/firebase_providers.dart'
    show firebaseAuthProvider, usersCollectionProvider;

part 'data_layer_providers.g.dart';

/// 🔌 [authRemoteDatabaseProvider] — provides instance of [AuthRemoteDatabaseImpl]
/// with injected infra (Auth + Users collection)
//
@riverpod
IAuthRemoteDatabase authRemoteDatabase(Ref ref) {
  final auth = ref.watch(firebaseAuthProvider);
  final users = ref.watch(usersCollectionProvider);
  return AuthRemoteDatabaseImpl(auth, users);
}

////

////

/// 🧩 [signInRepoProvider] — provides instance of [SignInRepoImpl], injects [IAuthRemoteDatabase] from [authRemoteDatabaseProvider]
//
@Riverpod(keepAlive: false)
ISignInRepo signInRepo(Ref ref) {
  final remote = ref.watch(authRemoteDatabaseProvider);
  return SignInRepoImpl(remote);
}

////

////

/// 🧩 [signOutRepoProvider] — provides instance of [SignOutRepoImpl], injects [IAuthRemoteDatabase]
//
@riverpod
ISignOutRepo signOutRepo(Ref ref) {
  final remote = ref.watch(authRemoteDatabaseProvider);
  return SignOutRepoImpl(remote);
}

////

////

/// 🧩 [signUpRepoProvider] — provides instance of [SignUpRepoImpl], injects [IAuthRemoteDatabase]
//
@riverpod
ISignUpRepo signUpRepo(Ref ref) {
  final remote = ref.watch(authRemoteDatabaseProvider);
  return SignUpRepoImpl(remote);
}
