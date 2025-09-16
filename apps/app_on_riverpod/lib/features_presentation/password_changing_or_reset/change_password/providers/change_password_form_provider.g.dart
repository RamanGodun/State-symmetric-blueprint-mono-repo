// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'change_password_form_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$changePasswordFormIsValidHash() =>
    r'be7ac9e5b5ecdafca92b787a36c0ddb0214cdea2'; ////
////
/// ✅ Returns form validity as primitive bool (minimal rebuilds)
///
/// Copied from [changePasswordFormIsValid].
@ProviderFor(changePasswordFormIsValid)
final changePasswordFormIsValidProvider = AutoDisposeProvider<bool>.internal(
  changePasswordFormIsValid,
  name: r'changePasswordFormIsValidProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$changePasswordFormIsValidHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef ChangePasswordFormIsValidRef = AutoDisposeProviderRef<bool>;
String _$changePasswordFormHash() =>
    r'ad653ecfa111f43c1fad14641a21b23e83e07f73';

/// 🧩 [ChangePasswordForm] — Manages the state of the change password form using [StateNotifier].
/// Handles input updates, validation, and visibility toggling for password field.
///
/// Copied from [ChangePasswordForm].
@ProviderFor(ChangePasswordForm)
final changePasswordFormProvider =
    AutoDisposeNotifierProvider<
      ChangePasswordForm,
      ChangePasswordFormState
    >.internal(
      ChangePasswordForm.new,
      name: r'changePasswordFormProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$changePasswordFormHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$ChangePasswordForm = AutoDisposeNotifier<ChangePasswordFormState>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
