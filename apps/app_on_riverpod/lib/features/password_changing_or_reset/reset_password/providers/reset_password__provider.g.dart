// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reset_password__provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$resetPasswordHash() => r'99231fd9767e737ea16e6d3610361a991e2af0bf';

/// 🔐 [resetPasswordProvider] — Handles reset-password submission & side-effects.
/// 🧰 Uses shared [SubmissionFlowState].
/// 🔁 Symmetric to BLoC 'ResetPasswordCubit' (Initial → Loading → Success/Error).
///
/// Copied from [ResetPassword].
@ProviderFor(ResetPassword)
final resetPasswordProvider =
    AutoDisposeNotifierProvider<ResetPassword, SubmissionFlowState>.internal(
      ResetPassword.new,
      name: r'resetPasswordProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$resetPasswordHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$ResetPassword = AutoDisposeNotifier<SubmissionFlowState>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
