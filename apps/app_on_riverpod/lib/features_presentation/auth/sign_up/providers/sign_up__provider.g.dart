// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sign_up__provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$signUpHash() => r'a72617d1bff67ad446d3972a0ad7c33f09985021';

/// 🔐 [signUpProvider] — Handles sign-up submission & side-effects.
/// 🧰 Uses shared [ButtonSubmissionState].
/// 🔁 Symmetric to BLoC 'SignUpCubit' (Initial → Loading → Success/Error).
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
