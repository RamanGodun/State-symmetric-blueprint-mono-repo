// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sign_up__provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$signUpHash() => r'577c549a46a3a1457c3a00a016129b0521a8a0fa';

/// 🔐 [signUpProvider] — Handles sign-up submission & side-effects.
/// 🧰 Uses shared [SubmissionFlowStateModel].
/// 🔁 Symmetric to BLoC 'SignUpCubit' (Initial → Loading → Success/Error).
///
/// Copied from [SignUp].
@ProviderFor(SignUp)
final signUpProvider =
    AutoDisposeNotifierProvider<SignUp, SubmissionFlowStateModel>.internal(
      SignUp.new,
      name: r'signUpProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$signUpHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$SignUp = AutoDisposeNotifier<SubmissionFlowStateModel>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
