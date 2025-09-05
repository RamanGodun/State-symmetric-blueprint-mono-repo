import 'package:app_on_riverpod/core/base_modules/navigation/module_core/go_router_factory.dart'
    show buildGoRouter;
import 'package:app_on_riverpod/core/base_modules/navigation/module_core/router_provider.dart'
    show goRouter;
import 'package:core/base_modules/overlays/overlays_dispatcher/overlay_dispatcher.dart';
import 'package:firebase_adapter/firebase_adapter.dart'
    show FirebaseAuthGateway, FirebaseRefs;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_storage/get_storage.dart' show GetStorage;
import 'package:riverpod_adapter/base_modules/observing/riverpod_observer.dart';
import 'package:riverpod_adapter/base_modules/overlays_module/overlay_adapters_providers.dart'
    show RiverpodOverlayActivityPort, overlayDispatcherProvider;
import 'package:riverpod_adapter/base_modules/theme_module/theme_provider.dart';
import 'package:riverpod_adapter/di/i_di_config.dart';
import 'package:riverpod_adapter/utils/auth/auth_stream_adapter.dart';
import 'package:riverpod_adapter/utils/auth/firebase_providers.dart'
    show firebaseAuthProvider, usersCollectionProvider;

/// 🛠️ [DIConfiguration] — default DI setup for the app runtime
/// Wires core subsystems (theme, routing, overlays) and feature stacks (auth/profile).
/// Exported as a set of Riverpod overrides + observers for a single source of truth.
//
final class DIConfiguration implements IDIConfig {
  ///-------------------------------------------------
  //
  /// 🔁 Aggregated overrides exposed to the app
  /// Order matters: later lists may rely on earlier core wiring.
  @override
  List<Override> get overrides => [
    ...coreOverrides,
    ...authProfileOverrides,
    ...otherOverrides, // placeholder
  ];

  ////
  ////

  /// 🌐 Core system-wide overrides (theme, routing, overlays)
  /// Keep these minimal and framework-agnostic; feature-specific pieces live elsewhere.
  //
  List<Override> get coreOverrides => [
    //
    /// 🎨 Theme: persistent storage + notifier
    themeStorageProvider.overrideWith((ref) => GetStorage()),
    themeProvider.overrideWith(
      (ref) => ThemeConfigNotifier(ref.watch(themeStorageProvider)),
    ),
    //
    /// 🧭 Routing: provide a configured GoRouter
    goRouter.overrideWith(buildGoRouter),
    //
    /// 📤 Overlays: DI-bound dispatcher with Riverpod-backed activity port
    overlayDispatcherProvider.overrideWith((ref) {
      final port = RiverpodOverlayActivityPort(ref);
      return OverlayDispatcher(activityPort: port);
    }),

    //
  ];

  ////

  /// 👤 Auth/Profile feature overrides
  /// Wraps Firebase primitives with lifecycle-safe gateways and collections.
  //
  List<Override> get authProfileOverrides => [
    //
    // 🔐 Auth gateway: ensure proper disposal on provider teardown
    authGatewayProvider.overrideWith((ref) {
      final auth = FirebaseAuthGateway(FirebaseRefs.auth);
      ref.onDispose(auth.dispose);
      return auth;
    }),
    //
    /// 🔐 FirebaseAuth instance
    firebaseAuthProvider.overrideWith(
      (ref) => FirebaseRefs.auth,
    ),
    //
    /// 🗃️ Users collection (Firestore)
    usersCollectionProvider.overrideWith(
      (ref) => FirebaseRefs.usersCollectionRef,
    ),
  ];

  ////

  /// ➕ Extension point for additional overrides
  /// Use for cross-cutting concerns that must be available in/out of widget tree.
  //
  List<Override> get otherOverrides => [
    /// add more overrides here when needed
  ];

  ////
  ////

  /// 🧭 Observability — logs provider lifecycle/events in dev
  /// Keep the list small to avoid noisy logs.
  @override
  List<ProviderObserver> get observers => [RiverpodLogger()];

  //
}
