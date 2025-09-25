// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sign_in__provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$signInHash() => r'fbddeea9e5b268e06f73e053598b85202c0a4a46';

/// 🔐 [signInProvider] — Handles sign-in submission & side-effects.
/// 🧰 Uses shared [ButtonSubmissionState].
/// 🔁 Symmetric to BLoC 'SignInCubit' (Initial → Loading → Success/Error).
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
