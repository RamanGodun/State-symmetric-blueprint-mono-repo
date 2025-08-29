import 'package:blueprint_on_riverpod/core/base_modules/navigation/routes/app_routes.dart';
import 'package:blueprint_on_riverpod/core/shared_presentation/pages/page_not_found.dart';
import 'package:core/base_modules/overlays/utils/overlays_cleaner_within_navigation.dart';
import 'package:core/utils_shared/auth/auth_snapshot.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_adapter/base_modules/navigation_module/redirect_state.dart';
import 'package:riverpod_adapter/utils/auth/auth_stream_adapter.dart'
    show authSnapshotsProvider;

part 'routes_redirection_service.dart';

/// 🧭🚦[buildGoRouter] — GoRouter factory. Returns fully constructed [GoRouter] instance
/// ✅ Declaratively creates router in dependence of actual [authSnapshotsProvider].
//
GoRouter buildGoRouter(Ref ref) {
  // 🧩 Local state holder (no rebuilds for GoRouter)
  final redirectState = AuthRedirectState()..attach(ref);
  ////

  return GoRouter(
    //
    /// 👁️ Observers — navigation side-effects (e.g., dismissing overlays)
    observers: [OverlaysCleanerWithinNavigation()],

    /// 🐞 Enable verbose logging for GoRouter (only active in debug mode)
    debugLogDiagnostics: true,

    /// ⏳ Initial route shown on app launch (Splash Screen)
    initialLocation: RoutesPaths.splash,

    /// 🗺️ Route definitions used across the app
    routes: AppRoutes.all,

    /// ❌ Fallback UI for unknown/unmatched routes
    errorBuilder: (context, state) =>
        PageNotFound(errorMessage: state.error.toString()),

    ////

    /// 🧭 Global redirect handler — routes user depending on auth state (reads cached values only)
    redirect: (context, state) {
      //
      final s = redirectState.current;
      if (s == null) return null;
      final currentPath = state.matchedLocation.isNotEmpty
          ? state.matchedLocation
          : state.uri.toString();

      return computeRedirect(
        currentPath: currentPath,
        snapshot: s,
        hasResolvedOnce: redirectState.resolvedOnce,
      );
    },
  );

  //
}
