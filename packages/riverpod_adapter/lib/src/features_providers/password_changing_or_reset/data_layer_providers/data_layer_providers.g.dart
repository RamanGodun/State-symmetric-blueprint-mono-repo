// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'data_layer_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$passwordRemoteDatabaseHash() =>
    r'5cf2ccb169962ff6d183c89d4ea7c6987d0ec9bb';

/// 🔌 [passwordRemoteDatabaseProvider] — low-level remote access (FirebaseAuth injected)
/// ⛓️ Keeps `features` backend-agnostic.
///
/// Copied from [passwordRemoteDatabase].
@ProviderFor(passwordRemoteDatabase)
final passwordRemoteDatabaseProvider =
    AutoDisposeProvider<IPasswordRemoteDatabase>.internal(
      passwordRemoteDatabase,
      name: r'passwordRemoteDatabaseProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$passwordRemoteDatabaseHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef PasswordRemoteDatabaseRef =
    AutoDisposeProviderRef<IPasswordRemoteDatabase>;
String _$passwordRepoHash() => r'338ba4c9638bafeb73dc156b6376fa113f6e209e';

/// 🧩 [passwordRepoProvider] — adds failure mapping and domain boundary
///
/// Copied from [passwordRepo].
@ProviderFor(passwordRepo)
final passwordRepoProvider = AutoDisposeProvider<IPasswordRepo>.internal(
  passwordRepo,
  name: r'passwordRepoProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$passwordRepoHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef PasswordRepoRef = AutoDisposeProviderRef<IPasswordRepo>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
