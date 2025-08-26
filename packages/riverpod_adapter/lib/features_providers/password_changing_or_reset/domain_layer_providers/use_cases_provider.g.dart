// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'use_cases_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$passwordUseCasesHash() => r'd74e6883305977b0584d9c1ce30a7656b84ee7e5';

/// 🧩 [passwordUseCasesProvider] — provides instance of [PasswordRelatedUseCases]
/// 🧼 Depends on [passwordRepoProvider] for implementation
///
/// Copied from [passwordUseCases].
@ProviderFor(passwordUseCases)
final passwordUseCasesProvider =
    AutoDisposeProvider<PasswordRelatedUseCases>.internal(
      passwordUseCases,
      name: r'passwordUseCasesProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$passwordUseCasesHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef PasswordUseCasesRef = AutoDisposeProviderRef<PasswordRelatedUseCases>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
