import 'package:adapters_for_firebase/adapters_for_firebase.dart'
    show FirebaseAuthGateway, FirebaseRefs;
import 'package:adapters_for_riverpod/adapters_for_riverpod.dart'
    show
        IDIConfig,
        ProviderDebugObserver,
        RiverpodOverlayActivityPort,
        ThemeConfigNotifier,
        authGatewayProvider,
        firebaseAuthProvider,
        overlayDispatcherProvider,
        themeProvider,
        themeStorageProvider,
        usersCollectionProvider;
import 'package:app_on_riverpod/core/base_modules/navigation/go_router_factory.dart'
    show buildGoRouter;
import 'package:app_on_riverpod/core/base_modules/navigation/router_provider.dart'
    show goRouter;
import 'package:flutter_riverpod/flutter_riverpod.dart'
    show Override, ProviderObserver;
import 'package:get_storage/get_storage.dart' show GetStorage;
import 'package:shared_core_modules/public_api/base_modules/overlays.dart'
    show OverlayDispatcher;

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
  List<ProviderObserver> get observers => [const ProviderDebugObserver()];

  //
}
