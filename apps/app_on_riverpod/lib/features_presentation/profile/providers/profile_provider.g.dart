// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$profileHash() => r'3e38d79092f18446d07d2bfc639abc519d7a6d3c';

/// 👤 [profileProvider] — async notifier that fetches user profile
/// 🧼 Declarative-only approach, throws [Failure] and is handled in `.listenFailure(...)`
/// 🧼 Compatible with `.family` and avoids breaking [SafeAsyncState] limitations
///
/// Copied from [Profile].
@ProviderFor(Profile)
final profileProvider =
    AutoDisposeAsyncNotifierProvider<Profile, UserEntity>.internal(
      Profile.new,
      name: r'profileProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$profileHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$Profile = AutoDisposeAsyncNotifier<UserEntity>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
