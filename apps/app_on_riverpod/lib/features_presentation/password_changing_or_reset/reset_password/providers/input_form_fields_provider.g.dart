// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'input_form_fields_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$resetPasswordFormIsValidHash() =>
    r'711cdc8f0ef97e963bea8f06aa611d0bd58219be'; ////
////
/// ✅ Returns form validity as primitive bool (minimal rebuilds)
///
/// Copied from [resetPasswordFormIsValid].
@ProviderFor(resetPasswordFormIsValid)
final resetPasswordFormIsValidProvider = AutoDisposeProvider<bool>.internal(
  resetPasswordFormIsValid,
  name: r'resetPasswordFormIsValidProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$resetPasswordFormIsValidHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef ResetPasswordFormIsValidRef = AutoDisposeProviderRef<bool>;
String _$resetPasswordFormHash() => r'07ad82f8b916d54b911fc767b856143ae7d4fcbc';

/// 🧩 [ResetPasswordForm] — Manages the state of the reset password form using [StateNotifier].
/// Handles input updates, validation, and future extensibility.
///
/// Copied from [ResetPasswordForm].
@ProviderFor(ResetPasswordForm)
final resetPasswordFormProvider =
    AutoDisposeNotifierProvider<
      ResetPasswordForm,
      ResetPasswordFormState
    >.internal(
      ResetPasswordForm.new,
      name: r'resetPasswordFormProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$resetPasswordFormHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$ResetPasswordForm = AutoDisposeNotifier<ResetPasswordFormState>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
