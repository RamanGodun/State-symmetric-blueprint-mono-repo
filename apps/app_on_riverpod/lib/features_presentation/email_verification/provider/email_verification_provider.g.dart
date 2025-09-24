// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'email_verification_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$emailVerificationNotifierHash() =>
    r'b635db7daed1d4098a28c7c613f7e9dd8c79dc53';

/// 📧 [EmailVerificationNotifier] — Orchestrates the email-verification flow (Riverpod).
/// 🧰 Uses shared async state: [AsyncValue<void>] via [SafeAsyncState].
/// 🔁 Symmetric to BLoC 'EmailVerificationCubit' (bootstrap → polling → success/timeout).
///
/// Copied from [EmailVerificationNotifier].
@ProviderFor(EmailVerificationNotifier)
final emailVerificationNotifierProvider =
    AutoDisposeAsyncNotifierProvider<EmailVerificationNotifier, void>.internal(
      EmailVerificationNotifier.new,
      name: r'emailVerificationNotifierProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$emailVerificationNotifierHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$EmailVerificationNotifier = AutoDisposeAsyncNotifier<void>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
