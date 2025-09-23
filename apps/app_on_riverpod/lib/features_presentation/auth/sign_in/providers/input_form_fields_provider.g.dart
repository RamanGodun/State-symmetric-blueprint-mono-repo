// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'input_form_fields_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$signInFormIsValidHash() =>
    r'62ac3ce6b9db063b0825fc31d06b9b98a70226a2'; ////
////
/// ✅ Returns form validity as primitive bool (minimal rebuilds)
///
/// Copied from [signInFormIsValid].
@ProviderFor(signInFormIsValid)
final signInFormIsValidProvider = AutoDisposeProvider<bool>.internal(
  signInFormIsValid,
  name: r'signInFormIsValidProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$signInFormIsValidHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef SignInFormIsValidRef = AutoDisposeProviderRef<bool>;
String _$signInFormHash() => r'f667f50d1a0d69468e1556fa6628a7eedadc78c4';

/// 🧩 [SignInForm] — Manages the state of the sign-in form using [StateNotifier].
/// Handles input updates, validation, and visibility toggling for password field.
///
/// Copied from [SignInForm].
@ProviderFor(SignInForm)
final signInFormProvider =
    AutoDisposeNotifierProvider<SignInForm, SignInFormState>.internal(
      SignInForm.new,
      name: r'signInFormProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$signInFormHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$SignInForm = AutoDisposeNotifier<SignInFormState>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
