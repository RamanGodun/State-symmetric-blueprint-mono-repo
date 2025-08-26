// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sign_out_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$signOutHash() => r'30edd0f5597c031080b341d62264522b4f5ba0d2';

/// 🔓 [signOutProvider] — async notifier for user sign-out
/// 🧼 Uses [SafeAsyncState] for lifecycle safety and cache cleanup
/// 🧼 Wraps result in [AsyncValue.guard]-like error propagation
///
/// Copied from [SignOut].
@ProviderFor(SignOut)
final signOutProvider =
    AutoDisposeAsyncNotifierProvider<SignOut, void>.internal(
      SignOut.new,
      name: r'signOutProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$signOutHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$SignOut = AutoDisposeAsyncNotifier<void>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
