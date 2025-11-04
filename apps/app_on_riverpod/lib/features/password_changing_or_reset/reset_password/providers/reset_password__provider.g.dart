// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reset_password__provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$resetPasswordHash() => r'7efb6f2f850c32c3558771d9faf9320ac3debe0c';

/// 🔐 [resetPasswordProvider] — Handles reset-password submission & side-effects.
/// 🧰 Uses shared [SubmissionFlowStateModel].
/// 🔁 Symmetric to BLoC 'ResetPasswordCubit' (Initial → Loading → Success/Error).
///
/// Copied from [ResetPassword].
@ProviderFor(ResetPassword)
final resetPasswordProvider =
    AutoDisposeNotifierProvider<
      ResetPassword,
      SubmissionFlowStateModel
    >.internal(
      ResetPassword.new,
      name: r'resetPasswordProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$resetPasswordHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$ResetPassword = AutoDisposeNotifier<SubmissionFlowStateModel>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
