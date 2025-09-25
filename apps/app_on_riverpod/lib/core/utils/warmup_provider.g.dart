// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'warmup_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$warmupHash() => r'61c5628deb0694ad7ac17145d047965fe2a1174a';

///
/// ✅ Current behavior:
/// - Listens to [authUidProvider].
/// - 👤 When a `uid` appears → primes the [profileProvider] (fetch without clearing UI).
/// - 🚪 When `uid` disappears → resets the profile state.
///
/// Copied from [warmup].
@ProviderFor(warmup)
final warmupProvider = Provider<void>.internal(
  warmup,
  name: r'warmupProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$warmupHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef WarmupRef = ProviderRef<void>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
