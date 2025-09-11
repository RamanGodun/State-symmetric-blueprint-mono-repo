// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'overlay_adapters_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$overlayDispatcherHash() =>
    r'52c43d0ab7935a92a7b6a14e542b41c788b6ee19'; ////
////
/// 🧩 DI binding: provides a process-wide [OverlayDispatcher].
///
/// Copied from [overlayDispatcher].
@ProviderFor(overlayDispatcher)
final overlayDispatcherProvider = Provider<OverlayDispatcher>.internal(
  overlayDispatcher,
  name: r'overlayDispatcherProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$overlayDispatcherHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef OverlayDispatcherRef = ProviderRef<OverlayDispatcher>;
String _$overlayStatusHash() =>
    r'a2c032f1d8177479af99a98e31584334af6a2a8f'; ////
////
/// 🧠 Global overlay activity flag (default: false).
///
/// Copied from [OverlayStatus].
@ProviderFor(OverlayStatus)
final overlayStatusProvider = NotifierProvider<OverlayStatus, bool>.internal(
  OverlayStatus.new,
  name: r'overlayStatusProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$overlayStatusHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$OverlayStatus = Notifier<bool>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
