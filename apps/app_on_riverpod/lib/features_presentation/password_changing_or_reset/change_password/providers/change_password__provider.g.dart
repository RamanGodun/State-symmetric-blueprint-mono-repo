// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'change_password__provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$changePasswordHash() => r'cc70ecbe17fd117379cdc9807db903754b4a2463';

/// 🔐 [changePasswordProvider] — Handles password-change submission & side-effects.
/// 🧰 Uses shared [ButtonSubmissionState].
/// 🔁 Symmetric to BLoC 'ChangePasswordCubit' (Initial → Loading → Success/Error/RequiresReauth).
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
