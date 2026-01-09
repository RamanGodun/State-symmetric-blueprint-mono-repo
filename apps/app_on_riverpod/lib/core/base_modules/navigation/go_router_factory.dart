import 'package:adapters_for_riverpod/adapters_for_riverpod.dart'
    show authGatewayProvider;
import 'package:app_on_riverpod/core/base_modules/navigation/routes/app_routes.dart'
    show AppRoutes, RoutesNames, RoutesPaths;
import 'package:flutter/foundation.dart' show debugPrint, kDebugMode;
import 'package:flutter_riverpod/flutter_riverpod.dart' show Ref;
import 'package:go_router/go_router.dart' show GoRouter;
import 'package:shared_core_modules/public_api/base_modules/navigation.dart'
    show NavigationX;
import 'package:shared_core_modules/public_api/base_modules/overlays.dart'
    show OverlaysCleanerWithinNavigation;
import 'package:shared_core_modules/public_api/core_contracts/auth.dart'
    show AuthFailure, AuthLoading, AuthReady, AuthSnapshot;
import 'package:shared_layers/public_api/presentation_layer_shared.dart'
    show PageNotFound;
import 'package:shared_utils/public_api/general_utils.dart'
    show StreamChangeNotifier;

part 'routes_redirection_service.dart';

/// 🧭🚦 [buildGoRouter] — central GoRouter factory (Riverpod edition)
/// ✅ Exposes a single GoRouter instance in DI
/// ✅ Reactivity is driven via 'refreshListenable' bound to auth state changes
/// ✅ Redirect logic relies on synchronous `gateway.currentSnapshot`
//
GoRouter buildGoRouter(Ref ref) {
  //
  /// 🔒 Important: use `read` instead of `watch` so router instance is stable (not rebuilt)
  final gateway = ref.read(authGatewayProvider);

  /// 🔔 Bridge auth stream → ChangeNotifier for GoRouter refresh
  final authChange = StreamChangeNotifier<AuthSnapshot>(gateway.snapshots$);
  ref.onDispose(authChange.dispose);

  /// ⛳️ Hysteresis: once resolved (not loading), avoid splash loop
  var hasResolvedOnce = false;

  ////

  return GoRouter(
    //
    /// 👁️ Navigation observers (overlay cleanup, logging, etc.)
    observers: [OverlaysCleanerWithinNavigation()],

    /// 🐞 Verbose diagnostics only in debug mode
    debugLogDiagnostics: kDebugMode,

    /// ⏳ Initial splash route
    initialLocation: RoutesPaths.splash,

    /// 🗺️ Full route table
    routes: AppRoutes.all,

    /// ❌ Fallback for unknown routes
    errorBuilder: (context, state) =>
        PageNotFound(onGoHome: () => context.goTo(RoutesNames.home)),

    ////

    // ♻️ Trigger re-checks on every auth stream event
    refreshListenable: authChange,

    ////

    /// 🧭 Global redirect hook
    redirect: (context, state) {
      //
      /// 📊 Read latest synchronous snapshot
      final snap = gateway.currentSnapshot;
      //
      /// ✅ Mark that resolution happened (skip splash on next cycle)
      if (snap is! AuthLoading) hasResolvedOnce = true;
      //
      /// 📍 Current navigation path
      final currentPath = state.matchedLocation.isNotEmpty
          ? state.matchedLocation
          : state.uri.toString();
      //
      /// Pure, testable redirect function
      final target = computeRedirect(
        currentPath: currentPath,
        snapshot: snap,
        hasResolvedOnce: hasResolvedOnce,
      );
      //
      if (kDebugMode && target != null) {
        debugPrint('🧭 Redirect: $currentPath → $target (${snap.runtimeType})');
      }
      //
      return target;
    },
  );

  //
}
