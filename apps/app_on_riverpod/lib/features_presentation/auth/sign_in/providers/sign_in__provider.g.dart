// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sign_in__provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$signInSubmitIsLoadingHash() =>
    r'd1c273730f5810e42bf3ad7238ac67592a793ece'; ////
////
/// ⏳ Returns loading state for submission (primitive bool)
///
/// Copied from [signInSubmitIsLoading].
@ProviderFor(signInSubmitIsLoading)
final signInSubmitIsLoadingProvider = AutoDisposeProvider<bool>.internal(
  signInSubmitIsLoading,
  name: r'signInSubmitIsLoadingProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$signInSubmitIsLoadingHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef SignInSubmitIsLoadingRef = AutoDisposeProviderRef<bool>;
String _$signInHash() => r'ac8118ffb0d7c46432fa6b62f9df502c4c85c885';

/// 🧩 [signInProvider] — async notifier that handles user sign-in
/// 🧼 Uses [SafeAsyncState] to prevent post-dispose state updates
/// 🧼 Wraps logic in [AsyncValue.guard] for robust error handling
///
/// Copied from [SignIn].
@ProviderFor(SignIn)
final signInProvider = AutoDisposeAsyncNotifierProvider<SignIn, void>.internal(
  SignIn.new,
  name: r'signInProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$signInHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$SignIn = AutoDisposeAsyncNotifier<void>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
