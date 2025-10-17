// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sign_up__provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$signUpHash() => r'0d497dddc83755fe5fa774a4d4132c55c4cb6999';

/// 🔐 [signUpProvider] — Handles sign-up submission & side-effects.
/// 🧰 Uses shared [SubmissionFlowState].
/// 🔁 Symmetric to BLoC 'SignUpCubit' (Initial → Loading → Success/Error).
///
/// Copied from [SignUp].
@ProviderFor(SignUp)
final signUpProvider =
    AutoDisposeNotifierProvider<SignUp, SubmissionFlowState>.internal(
      SignUp.new,
      name: r'signUpProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$signUpHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$SignUp = AutoDisposeNotifier<SubmissionFlowState>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
