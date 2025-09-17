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
String _$resetPasswordHash() => r'c0ca7dcb5c187aaf0bf32aebea4db47a20280db8';

/// 🧩 [resetPasswordProvider] — async notifier that handles password reset
/// 🧼 Uses [SafeAsyncState] to prevent post-dispose state updates
/// 🧼 Wraps logic in [AsyncValue.guard] for robust error handling
///
/// Copied from [ResetPassword].
@ProviderFor(ResetPassword)
final resetPasswordProvider =
    AutoDisposeAsyncNotifierProvider<ResetPassword, void>.internal(
      ResetPassword.new,
      name: r'resetPasswordProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$resetPasswordHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$ResetPassword = AutoDisposeAsyncNotifier<void>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
