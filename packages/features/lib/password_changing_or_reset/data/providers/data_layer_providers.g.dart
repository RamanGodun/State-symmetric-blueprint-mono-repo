// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'data_layer_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$passwordRemoteDatabaseHash() =>
    r'66171cb14415dd20c6f7d93ccfc1fb62ed12047c';

/// 🧩 [passwordRemoteDataSourceProvider] — provides implementation of [IPasswordRemoteDatabase]
/// ✅ Low-level data access for password-related Firebase actions
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

/// 🧩 [passwordRepoProvider] — provides implementation of [IPasswordRepo]
/// 🧼 Adds failure mapping on top of remote data source
/// ✅ Used by domain layer use cases
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
