// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_stream_adapter.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$authGatewayHash() => r'84f5efe5052acf2fbce30330ae706739f294365b';

/// 🔌 [authGatewayProvider] — DI token for [AuthGateway]
/// ✅ Overridden in the application layer with a concrete implementation (e.g. FirebaseAuthGateway)
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
/// 🌐 [authSnapshotsProvider] — stream of [AuthSnapshot] from the gateway
/// ✅ Can be consumed directly in widgets to react to authentication changes
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
String _$authUidHash() => r'4811d591e8fe184609f5cd547cb06d794032b3d2'; ////
////
/// ✅ Будуємо стрім UID зі справжнього стріму AuthGateway (а не з AsyncValue)
///
/// Copied from [authUid].
@ProviderFor(authUid)
final authUidProvider = StreamProvider<String?>.internal(
  authUid,
  name: r'authUidProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$authUidHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef AuthUidRef = StreamProviderRef<String?>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
