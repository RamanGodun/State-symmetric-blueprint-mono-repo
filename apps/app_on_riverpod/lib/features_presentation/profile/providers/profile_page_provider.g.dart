// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile_page_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$profileHash() => r'9d0a9731851c61fc5d896b4b0f28b1ba7c4473b6';

/// 👤 [profileProvider] — keeps the authenticated user's profile.
/// ✅ Mirrors the BLoC counterpart ['ProfileCubit'] API (prime / refresh / reset).
/// 🎯 UX: preserves existing UI on background updates (no full-screen loader).
///
/// Copied from [Profile].
@ProviderFor(Profile)
final profileProvider = AsyncNotifierProvider<Profile, UserEntity>.internal(
  Profile.new,
  name: r'profileProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$profileHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$Profile = AsyncNotifier<UserEntity>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
