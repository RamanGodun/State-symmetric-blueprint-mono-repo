// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'input_form_fields_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$signUpFormHash() => r'7d487158b22fa36a65330ccee32e90469526a27e';

/// 📝 [signUpFormProvider] — Handles sign-up form fields & validation (StateNotifier).
/// 🧰 Uses shared [SignUpFormState].
/// 🔁 Symmetric to BLoC 'SignUpFormFieldCubit' (Form only).
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
