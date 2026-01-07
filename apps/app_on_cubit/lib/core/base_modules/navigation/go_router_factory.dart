import 'package:app_on_cubit/core/base_modules/navigation/routes/app_routes.dart';
import 'package:core/public_api/core.dart';
import 'package:flutter/foundation.dart' show debugPrint, kDebugMode;
import 'package:go_router/go_router.dart';

part 'routes_redirection_service.dart';

/// 🧭🚦 [buildGoRouter] — central GoRouter factory (Bloc edition)
/// ✅ Exposes a single GoRouter instance in DI
/// ✅ Reactivity enabled via 'refreshListenable' bound to auth stream
/// ✅ Redirect logic relies on synchronous `gateway.currentSnapshot`
//
GoRouter buildGoRouter(AuthGateway gateway) {
  //
  /// 🔔 Bridge auth stream → ChangeNotifier for GoRouter refresh
  final listenable = StreamChangeNotifier<AuthSnapshot>(gateway.snapshots$);

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

    /// ♻️ Trigger re-checks on every auth stream event
    refreshListenable: listenable,

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

      if (kDebugMode && target != null) {
        debugPrint('🧭 Redirect: $currentPath → $target (${snap.runtimeType})');
      }
      return target;
    },
  );

  //
}
