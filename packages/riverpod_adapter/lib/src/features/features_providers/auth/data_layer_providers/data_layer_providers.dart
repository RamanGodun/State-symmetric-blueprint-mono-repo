import 'package:features/features_barrels/auth/auth.dart';
import 'package:features/features_barrels/auth/auth_infra.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_adapter/src/core/utils/auth/firebase_providers.dart'
    show firebaseAuthProvider, usersCollectionProvider;
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'data_layer_providers.g.dart';

/// 🔌 [authRemoteDatabaseProvider] — provides instance of [AuthRemoteDatabaseImpl],
///    injected infra (Auth + Users collection)
//
@riverpod
IAuthRemoteDatabase authRemoteDatabase(Ref ref) {
  final auth = ref.watch(firebaseAuthProvider);
  final users = ref.watch(usersCollectionProvider);
  return AuthRemoteDatabaseImpl(auth, users);
}

////

////

/// 🧩 [signInRepoProvider] — provides instance of [SignInRepoImpl],
///    injects [IAuthRemoteDatabase] from [authRemoteDatabaseProvider]
//
@Riverpod(keepAlive: false)
ISignInRepo signInRepo(Ref ref) {
  final remote = ref.watch(authRemoteDatabaseProvider);
  return SignInRepoImpl(remote);
}

////

////

/// 🧩 [signOutRepoProvider] — provides instance of [SignOutRepoImpl],
///    injects [IAuthRemoteDatabase]
//
@riverpod
ISignOutRepo signOutRepo(Ref ref) {
  final remote = ref.watch(authRemoteDatabaseProvider);
  return SignOutRepoImpl(remote);
}

////

////

/// 🧩 [signUpRepoProvider] — provides instance of [SignUpRepoImpl],
///    injects [IAuthRemoteDatabase]
//
@riverpod
ISignUpRepo signUpRepo(Ref ref) {
  final remote = ref.watch(authRemoteDatabaseProvider);
  return SignUpRepoImpl(remote);
}
