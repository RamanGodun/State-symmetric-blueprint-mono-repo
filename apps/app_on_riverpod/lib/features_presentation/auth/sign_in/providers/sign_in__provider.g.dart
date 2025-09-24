// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sign_in__provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$signInHash() => r'81c475ac19b4728ae002ae7176353d86f13aad26';

/// 🧩 [signInProvider] — async notifier that handles user sign-in
/// 🧼 Uses [SafeAsyncState] to prevent post-dispose state updates
/// 🧼 Wraps logic in [AsyncValue.guard] for robust error handling
/// 🧩 [signInProvider] — Riverpod Notifier with shared ButtonSubmissionState
/// ✅ Mirrors BLoC Submit Cubit semantics (Initial → Loading → Success/Error)
///
/// Copied from [SignIn].
@ProviderFor(SignIn)
final signInProvider =
    AutoDisposeNotifierProvider<SignIn, ButtonSubmissionState>.internal(
      SignIn.new,
      name: r'signInProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$signInHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$SignIn = AutoDisposeNotifier<ButtonSubmissionState>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
