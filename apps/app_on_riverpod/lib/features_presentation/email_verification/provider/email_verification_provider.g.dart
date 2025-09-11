// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'email_verification_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$emailVerificationNotifierHash() =>
    r'20fb9aa6757c2d6e823adb28752b3b3eb5720917';

/// 🧩 [EmailVerificationNotifier] — orchestrates email verification flow
/// - Immediately sends a verification email on creation
/// - Polls every 3s for up to 1min until the email is verified
/// - On success: reloads Firebase user + triggers [AuthGateway.refresh]
/// - Exposes async state for UI feedback
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
