// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_stream_adapter.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$authGatewayHash() => r'84f5efe5052acf2fbce30330ae706739f294365b';

/// 🔌 [authGatewayProvider] — DI token for [AuthGateway] (overridden in app layer)
///
/// Copied from [authGateway].
@ProviderFor(authGateway)
final authGatewayProvider = Provider<AuthGateway>.internal(
  authGateway,
  name: r'authGatewayProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$authGatewayHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef AuthGatewayRef = ProviderRef<AuthGateway>;
String _$authSnapshotsHash() =>
    r'bb6883de9b6f9c9ef93480dbb2411365fd60f29e'; ////
////
/// 🌐 [authSnapshotsProvider] — reactive stream of [AuthSnapshot] from [AuthGateway]
///
/// Copied from [authSnapshots].
@ProviderFor(authSnapshots)
final authSnapshotsProvider = StreamProvider<AuthSnapshot>.internal(
  authSnapshots,
  name: r'authSnapshotsProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$authSnapshotsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef AuthSnapshotsRef = StreamProviderRef<AuthSnapshot>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
