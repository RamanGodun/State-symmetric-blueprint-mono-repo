import 'package:core/base_modules/overlays.dart'
    show
        OverlayWiringScope,
        setGlobalOverlayDispatcherResolver,
        setOverlayDispatcherResolver;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_adapter/src/base_modules/overlays_module/overlay_adapters_providers.dart';
import 'package:riverpod_adapter/src/di/global_di_container.dart'
    show GlobalDIContainer;

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
