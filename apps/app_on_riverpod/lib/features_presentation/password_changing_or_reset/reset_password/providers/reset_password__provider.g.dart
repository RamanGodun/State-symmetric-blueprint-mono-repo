// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reset_password__provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$resetPasswordHash() => r'b290a4c7f61b3bf32a41cb74246ed76af06a6e8d';

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
