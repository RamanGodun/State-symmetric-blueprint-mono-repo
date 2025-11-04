// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sign_in__provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$signInHash() => r'0b63308928f24d56b0b8a7d5baefeef8d599bd36';

/// 🔐 [signInProvider] — Handles sign-in submission & side-effects.
/// 🧰 Uses shared [SubmissionFlowStateModel].
/// 🔁 Symmetric to BLoC 'SignInCubit' (Initial → Loading → Success/Error).
///
/// Copied from [SignIn].
@ProviderFor(SignIn)
final signInProvider =
    AutoDisposeNotifierProvider<SignIn, SubmissionFlowStateModel>.internal(
      SignIn.new,
      name: r'signInProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$signInHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$SignIn = AutoDisposeNotifier<SubmissionFlowStateModel>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
