import 'package:adapters_for_riverpod/adapters_for_riverpod.dart'
    show overlayDispatcherProvider;
import 'package:adapters_for_riverpod/src/app_bootstrap/di/global_di_container.dart'
    show GlobalDIContainer;
import 'package:flutter_riverpod/flutter_riverpod.dart' show ProviderContainer;
import 'package:shared_core_modules/public_api/base_modules/overlays.dart'
    show
        OverlayWiringScope,
        setGlobalOverlayDispatcherResolver,
        setOverlayDispatcherResolver;

/// 🔌 [OverlayResolverWiring] — utility class to centralize resolver wiring.
/// - `wire(container: ...)` attaches resolvers for the given container
/// - `wireFromGlobalDI()` is a shortcut for already initialized [GlobalDIContainer]
//
final class OverlayResolverWiring {
  ///----------------------------
  const OverlayResolverWiring._();

  /// Wires resolvers depending on [scope]
  static void install({
    required ProviderContainer container,
    OverlayWiringScope scope = OverlayWiringScope.both,
  }) {
    if (scope == OverlayWiringScope.contextOnly ||
        scope == OverlayWiringScope.both) {
      // 🔗 Context-aware resolver (BuildContext-based calls)
      setOverlayDispatcherResolver((_) {
        return container.read(overlayDispatcherProvider);
      });
    }

    if (scope == OverlayWiringScope.globalOnly ||
        scope == OverlayWiringScope.both) {
      // 🌐 Global resolver (background tasks, isolates, infra code)
      setGlobalOverlayDispatcherResolver(() {
        return container.read(overlayDispatcherProvider);
      });
    }
  }

  /// Shortcut: wires resolvers using [GlobalDIContainer.instance]
  static void installFromGlobalDI({
    OverlayWiringScope scope = OverlayWiringScope.both,
  }) {
    final container = GlobalDIContainer.instance; // throws if not initialized
    install(container: container, scope: scope);
  }
}
