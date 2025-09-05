import 'package:app_on_riverpod/core/base_modules/navigation/routes/app_routes.dart';
import 'package:app_on_riverpod/core/shared_presentation/pages/page_not_found.dart';
import 'package:core/base_modules/overlays.dart'
    show OverlaysCleanerWithinNavigation;
import 'package:core/utils.dart'
    show
        AuthFailure,
        AuthLoading,
        AuthReady,
        AuthSnapshot,
        StreamChangeNotifier;
import 'package:flutter/foundation.dart' show debugPrint, kDebugMode;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_adapter/riverpod_adapter.dart'
    show authGatewayProvider;

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
        PageNotFound(errorMessage: state.error.toString()),

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
