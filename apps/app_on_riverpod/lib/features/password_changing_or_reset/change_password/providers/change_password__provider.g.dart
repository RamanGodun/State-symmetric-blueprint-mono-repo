// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'change_password__provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$changePasswordHash() => r'0e7493e33c871e0a05aae8629c07bebc374554f5';

/// 🔐 [changePasswordProvider] — Handles password-change submission & side-effects.
/// 🧰 Uses shared [SubmissionFlowState].
/// 🔁 Symmetric to BLoC 'ChangePasswordCubit' (Initial → Loading → Success/Error/RequiresReauth).
///
/// Copied from [ChangePassword].
@ProviderFor(ChangePassword)
final changePasswordProvider =
    AutoDisposeNotifierProvider<ChangePassword, SubmissionFlowState>.internal(
      ChangePassword.new,
      name: r'changePasswordProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$changePasswordHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$ChangePassword = AutoDisposeNotifier<SubmissionFlowState>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
