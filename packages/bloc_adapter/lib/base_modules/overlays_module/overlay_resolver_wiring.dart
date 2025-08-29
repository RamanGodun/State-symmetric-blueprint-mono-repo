import 'package:core/base_modules/overlays/core/enums_for_overlay_module.dart'
    show OverlayWiringScope;
import 'package:core/base_modules/overlays/overlays_dispatcher/overlay_dispatcher.dart';
import 'package:core/base_modules/overlays/utils/ports/overlay_dispatcher_locator.dart'
    show setGlobalOverlayDispatcherResolver, setOverlayDispatcherResolver;
import 'package:get_it/get_it.dart' show GetIt;

/// 🔌 Centralized overlay resolvers wiring for GetIt/BLoC apps
/// ✅ Mirrors Riverpod wiring API for consistency
//
final class OverlayResolverWiringBloc {
  ///-------------------------------
  const OverlayResolverWiringBloc._();

  /// Wires resolvers depending on [scope]
  static void wire({
    required GetIt container,
    OverlayWiringScope scope = OverlayWiringScope.both,
  }) {
    if (scope == OverlayWiringScope.contextOnly ||
        scope == OverlayWiringScope.both) {
      // 🔗 Context-aware resolver (BuildContext-based calls)
      setOverlayDispatcherResolver((_) => container<OverlayDispatcher>());
    }

    if (scope == OverlayWiringScope.globalOnly ||
        scope == OverlayWiringScope.both) {
      // 🌐 Global resolver (background tasks, infra, isolates)
      setGlobalOverlayDispatcherResolver(
        () => container<OverlayDispatcher>(),
      );
    }
  }

  //
}
