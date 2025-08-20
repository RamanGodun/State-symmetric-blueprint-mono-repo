// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'data_layer_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$authRemoteDatabaseHash() =>
    r'0a1ee8f7ee2e4d62bb3d5aac62ba46576eaf61e3';

/// 🔌 [authRemoteDataSourceProvider] — provides instance of [AuthRemoteDatabaseImpl]
/// 🧼 Dependency injection for Firebase Auth access
///
/// Copied from [authRemoteDatabase].
@ProviderFor(authRemoteDatabase)
final authRemoteDatabaseProvider =
    AutoDisposeProvider<IAuthRemoteDatabase>.internal(
      authRemoteDatabase,
      name: r'authRemoteDatabaseProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$authRemoteDatabaseHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef AuthRemoteDatabaseRef = AutoDisposeProviderRef<IAuthRemoteDatabase>;
String _$signInRepoHash() => r'117f3a17f3e7837901155515a6910c34d4aa7150'; ////
////
/// 🧩 [signInRepoProvider] — provides instance of [SignInRepoImpl], injects [IAuthRemoteDatabase] from [authRemoteDataSourceProvider]
///
/// Copied from [signInRepo].
@ProviderFor(signInRepo)
final signInRepoProvider = AutoDisposeProvider<ISignInRepo>.internal(
  signInRepo,
  name: r'signInRepoProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$signInRepoHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef SignInRepoRef = AutoDisposeProviderRef<ISignInRepo>;
String _$signOutRepoHash() => r'd046e96785d2f3cc5926ef731a55340e5cf9cebc'; ////
////
/// 🧩 [signOutRepoProvider] — provides instance of [SignOutRepoImpl], injects [IAuthRemoteDatabase]
///
/// Copied from [signOutRepo].
@ProviderFor(signOutRepo)
final signOutRepoProvider = AutoDisposeProvider<ISignOutRepo>.internal(
  signOutRepo,
  name: r'signOutRepoProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$signOutRepoHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef SignOutRepoRef = AutoDisposeProviderRef<ISignOutRepo>;
String _$signUpRepoHash() => r'd9f16483f051d722293a924734170361ab7a702a'; ////
////
/// 🧩 [signUpRepoProvider] — provides instance of [SignUpRepoImpl], injects [IAuthRemoteDatabase]
///
/// Copied from [signUpRepo].
@ProviderFor(signUpRepo)
final signUpRepoProvider = AutoDisposeProvider<ISignUpRepo>.internal(
  signUpRepo,
  name: r'signUpRepoProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$signUpRepoHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef SignUpRepoRef = AutoDisposeProviderRef<ISignUpRepo>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
