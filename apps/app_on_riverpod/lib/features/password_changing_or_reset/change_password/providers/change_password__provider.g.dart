// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'change_password__provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$changePasswordHash() => r'd6d19417cba916a0045556940df80de45659da0e';

/// 🔐 [changePasswordProvider] — Handles password-change submission & side-effects.
/// 🧰 Uses shared [SubmissionFlowStateModel].
/// 🔁 Symmetric to BLoC 'ChangePasswordCubit' (Initial → Loading → Success/Error/RequiresReauth).
///
/// Copied from [ChangePassword].
@ProviderFor(ChangePassword)
final changePasswordProvider =
    AutoDisposeNotifierProvider<
      ChangePassword,
      SubmissionFlowStateModel
    >.internal(
      ChangePassword.new,
      name: r'changePasswordProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$changePasswordHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$ChangePassword = AutoDisposeNotifier<SubmissionFlowStateModel>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
