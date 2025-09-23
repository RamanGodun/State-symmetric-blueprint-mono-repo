// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'change_password__provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$changePasswordSubmitIsLoadingHash() =>
    r'71091cad1f65d7abdbaaf529ca1657e7ecf037ea'; ////
////
////
////
/// ⏳ Returns loading state for submission (primitive bool)
///
/// Copied from [changePasswordSubmitIsLoading].
@ProviderFor(changePasswordSubmitIsLoading)
final changePasswordSubmitIsLoadingProvider =
    AutoDisposeProvider<bool>.internal(
      changePasswordSubmitIsLoading,
      name: r'changePasswordSubmitIsLoadingProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$changePasswordSubmitIsLoadingHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef ChangePasswordSubmitIsLoadingRef = AutoDisposeProviderRef<bool>;
String _$changePasswordHash() => r'918fa6cc583af87d43d5900e897672ae41ad23ff';

/// 🧩 [changePasswordProvider] — Riverpod Notifier with shared ButtonSubmissionState
/// ✅ Mirrors BLoC semantics (Initial → Loading → Success / Error / RequiresReauth)
///
/// Copied from [ChangePassword].
@ProviderFor(ChangePassword)
final changePasswordProvider =
    AutoDisposeNotifierProvider<ChangePassword, ButtonSubmissionState>.internal(
      ChangePassword.new,
      name: r'changePasswordProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$changePasswordHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$ChangePassword = AutoDisposeNotifier<ButtonSubmissionState>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
