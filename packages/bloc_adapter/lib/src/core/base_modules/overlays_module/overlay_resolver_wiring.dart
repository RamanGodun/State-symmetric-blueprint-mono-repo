import 'package:core/public_api/base_modules/overlays.dart'
    show
        OverlayDispatcher,
        OverlayWiringScope,
        setGlobalOverlayDispatcherResolver,
        setOverlayDispatcherResolver;
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
