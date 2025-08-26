// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'data_layer_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$profileRepoHash() => r'401cce60527da4575ca5d6e916b799202bc1a583';

/// 🧩 [profileRepoProvider] — provides instance of [ProfileRepoImpl]
/// 🧠 Injects [IProfileRemoteDatabase] from [profileRemoteDataSourceProvider]
/// ✅ Adds caching, failure mapping, and DTO → Entity conversion
///
/// Copied from [profileRepo].
@ProviderFor(profileRepo)
final profileRepoProvider = AutoDisposeProvider<IProfileRepo>.internal(
  profileRepo,
  name: r'profileRepoProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$profileRepoHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef ProfileRepoRef = AutoDisposeProviderRef<IProfileRepo>;
String _$profileRemoteDataSourceHash() =>
    r'04da4fc25a82a3cedb36647385035adec5526823'; ////
////
/// 🔌 [profileRemoteDataSourceProvider] — provides instance of [ProfileRemoteDatabaseImpl]
/// 🧱 Handles direct Firestore access for fetching or creating user profile
///
/// Copied from [profileRemoteDataSource].
@ProviderFor(profileRemoteDataSource)
final profileRemoteDataSourceProvider =
    AutoDisposeProvider<IProfileRemoteDatabase>.internal(
      profileRemoteDataSource,
      name: r'profileRemoteDataSourceProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$profileRemoteDataSourceHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef ProfileRemoteDataSourceRef =
    AutoDisposeProviderRef<IProfileRemoteDatabase>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
