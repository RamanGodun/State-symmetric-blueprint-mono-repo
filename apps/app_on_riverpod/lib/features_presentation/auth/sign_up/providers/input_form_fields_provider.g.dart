// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'input_form_fields_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$signUpFormIsValidHash() =>
    r'fd8a73b4f8c703fbd8c1e7e3bee50d6111a18a37'; ////
////
/// ✅ Returns form validity as primitive bool (minimal rebuilds)
///
/// Copied from [signUpFormIsValid].
@ProviderFor(signUpFormIsValid)
final signUpFormIsValidProvider = AutoDisposeProvider<bool>.internal(
  signUpFormIsValid,
  name: r'signUpFormIsValidProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$signUpFormIsValidHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef SignUpFormIsValidRef = AutoDisposeProviderRef<bool>;
String _$signUpFormHash() => r'88708ccc13082b31645f69df983dfd9232541210';

/// 🧩 [SignUpForm] — Manages the state of the sign-up form using [StateNotifier].
/// Handles input updates, validation, and visibility toggling for password fields.
///
/// Copied from [SignUpForm].
@ProviderFor(SignUpForm)
final signUpFormProvider =
    AutoDisposeNotifierProvider<SignUpForm, SignUpFormState>.internal(
      SignUpForm.new,
      name: r'signUpFormProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$signUpFormHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$SignUpForm = AutoDisposeNotifier<SignUpFormState>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
