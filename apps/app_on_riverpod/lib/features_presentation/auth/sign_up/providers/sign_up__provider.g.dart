// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sign_up__provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$signUpFormIsValidHash() =>
    r'fd8a73b4f8c703fbd8c1e7e3bee50d6111a18a37'; ////
////
/// ✅ Returns form validity as primitive bool (minimal rebuilds)
///
/// Copied from [signUpFormIsValid].
@ProviderFor(signUpFormIsValid)
final signUpFormIsValidProvider = AutoDisposeProvider<bool>.internal(
  signUpFormIsValid,
  name: r'signUpFormIsValidProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$signUpFormIsValidHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef SignUpFormIsValidRef = AutoDisposeProviderRef<bool>;
String _$signUpSubmitIsLoadingHash() =>
    r'c28ec61ea8934eb2f173dcb74d1f5275595296fb'; ////
////
/// ⏳ Returns loading state for submission (primitive bool)
///
/// Copied from [signUpSubmitIsLoading].
@ProviderFor(signUpSubmitIsLoading)
final signUpSubmitIsLoadingProvider = AutoDisposeProvider<bool>.internal(
  signUpSubmitIsLoading,
  name: r'signUpSubmitIsLoadingProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$signUpSubmitIsLoadingHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef SignUpSubmitIsLoadingRef = AutoDisposeProviderRef<bool>;
String _$signUpHash() => r'b158641aeb729a6d84863207a28d6f5acfccdfc3';

/// 🧩 [signUpProvider] — async notifier for user registration
/// 🧼 Uses [SafeAsyncState] to prevent post-dispose state updates
/// 🧼 Wraps logic in [AsyncValue.guard] for robust error handling
///
/// Copied from [SignUp].
@ProviderFor(SignUp)
final signUpProvider = AutoDisposeAsyncNotifierProvider<SignUp, void>.internal(
  SignUp.new,
  name: r'signUpProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$signUpHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$SignUp = AutoDisposeAsyncNotifier<void>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
