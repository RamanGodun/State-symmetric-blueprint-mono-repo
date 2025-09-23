// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sign_up__provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

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
String _$signUpHash() => r'0411b269c5c7b3f12a40c0b833f64a422178dbea';

/// 🧩 [signUpProvider] — Riverpod Notifier with shared ButtonSubmissionState
/// ✅ Mirrors BLoC submit Cubit semantics (Initial → Loading → Success/Error)
///
/// Copied from [SignUp].
@ProviderFor(SignUp)
final signUpProvider =
    AutoDisposeNotifierProvider<SignUp, ButtonSubmissionState>.internal(
      SignUp.new,
      name: r'signUpProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$signUpHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$SignUp = AutoDisposeNotifier<ButtonSubmissionState>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
