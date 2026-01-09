// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'use_cases_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$signInUseCaseHash() => r'ad7e9c64e03d4c09b499be096595ae263a50971d';

/// 🧩 [signInUseCaseProvider] — provides instance of [SignInUseCase]
/// 🧼 Depends on [signInRepoProvider] to inject repository
///
/// Copied from [signInUseCase].
@ProviderFor(signInUseCase)
final signInUseCaseProvider = AutoDisposeProvider<SignInUseCase>.internal(
  signInUseCase,
  name: r'signInUseCaseProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$signInUseCaseHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef SignInUseCaseRef = AutoDisposeProviderRef<SignInUseCase>;
String _$signOutUseCaseHash() =>
    r'b6cc3daa44285da84bd61df6d714c68e789b7d51'; ////
////
/// 🧩 Provides [SignOutUseCase] via injected repo
///
/// Copied from [signOutUseCase].
@ProviderFor(signOutUseCase)
final signOutUseCaseProvider = AutoDisposeProvider<SignOutUseCase>.internal(
  signOutUseCase,
  name: r'signOutUseCaseProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$signOutUseCaseHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef SignOutUseCaseRef = AutoDisposeProviderRef<SignOutUseCase>;
String _$signUpUseCaseHash() =>
    r'b13a0dd4b844899ee0b91193fdc0816f8dc60719'; ////
////
/// 🧩 Provides [SignUpUseCase] via injected repo
///
/// Copied from [signUpUseCase].
@ProviderFor(signUpUseCase)
final signUpUseCaseProvider = AutoDisposeProvider<SignUpUseCase>.internal(
  signUpUseCase,
  name: r'signUpUseCaseProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$signUpUseCaseHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef SignUpUseCaseRef = AutoDisposeProviderRef<SignUpUseCase>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
