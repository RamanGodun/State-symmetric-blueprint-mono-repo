// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reset_password__provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$resetPasswordIsLoadingHash() =>
    r'13553231324e681fa4fc4532557084237a820250'; ////
////
/// ⏳ Returns loading state for submission (primitive bool)
///
/// Copied from [resetPasswordIsLoading].
@ProviderFor(resetPasswordIsLoading)
final resetPasswordIsLoadingProvider = AutoDisposeProvider<bool>.internal(
  resetPasswordIsLoading,
  name: r'resetPasswordIsLoadingProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$resetPasswordIsLoadingHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef ResetPasswordIsLoadingRef = AutoDisposeProviderRef<bool>;
String _$resetPasswordHash() => r'10cb0dab7b0399222f852659e11ef818e238b099';

/// 🧩 [resetPasswordProvider] — Riverpod Notifier with shared ButtonSubmissionState
/// ✅ Mirrors BLoC submit Cubit semantics (Initial → Loading → Success/Error)
///
/// Copied from [ResetPassword].
@ProviderFor(ResetPassword)
final resetPasswordProvider =
    AutoDisposeNotifierProvider<ResetPassword, ButtonSubmissionState>.internal(
      ResetPassword.new,
      name: r'resetPasswordProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$resetPasswordHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$ResetPassword = AutoDisposeNotifier<ButtonSubmissionState>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
