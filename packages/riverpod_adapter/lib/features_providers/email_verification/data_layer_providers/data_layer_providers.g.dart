// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'data_layer_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$emailVerificationRepoHash() =>
    r'06a8efc141aecf31f67130380578a18112a03bd2';

/// 📦 [emailVerificationRepoProvider] — provides validated domain repo
/// 🔁 Combines error mapping with remote data source delegation
///
/// Copied from [emailVerificationRepo].
@ProviderFor(emailVerificationRepo)
final emailVerificationRepoProvider =
    AutoDisposeProvider<IUserValidationRepo>.internal(
      emailVerificationRepo,
      name: r'emailVerificationRepoProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$emailVerificationRepoHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef EmailVerificationRepoRef = AutoDisposeProviderRef<IUserValidationRepo>;
String _$userValidationRemoteDataSourceHash() =>
    r'd2193022a401cccff4ebbb2813ae532f857c4c4d';

/// 🛰️ [userValidationRemoteDataSourceProvider] — provides Firebase-based remote source
///
/// Copied from [userValidationRemoteDataSource].
@ProviderFor(userValidationRemoteDataSource)
final userValidationRemoteDataSourceProvider =
    AutoDisposeProvider<IUserValidationRemoteDataSource>.internal(
      userValidationRemoteDataSource,
      name: r'userValidationRemoteDataSourceProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$userValidationRemoteDataSourceHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef UserValidationRemoteDataSourceRef =
    AutoDisposeProviderRef<IUserValidationRemoteDataSource>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
