import 'package:bloc_adapter/utils/user_auth_cubit/auth_stream_cubit.dart';
import 'package:blueprint_on_cubit/core/base_modules/navigation/module_core/resolve_once_cache.dart';
import 'package:blueprint_on_cubit/core/base_modules/navigation/routes/app_routes.dart';
import 'package:blueprint_on_cubit/core/shared_presentation/pages/page_not_found.dart'
    show PageNotFound;
import 'package:core/base_modules/overlays/utils/overlays_cleaner_within_navigation.dart'
    show OverlaysCleanerWithinNavigation;
import 'package:core/utils_shared/auth/auth_snapshot.dart';
import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:go_router/go_router.dart';

part 'routes_redirection_service.dart';

/// 🧭🚦 [buildGoRouter] — central GoRouter factory
/// ✅ Builds router declaratively with auth-driven redirect logic
/// ✅ Plugs in overlays cleaner and 404 fallback
//
GoRouter buildGoRouter(AuthCubit authCubit) {
  ///
  final resolvedOnce = ResolvedOnceCache(authCubit.stream);
  //
  return GoRouter(
    //
    /// 👁️ Navigation observers (side effects like overlay cleanup)
    observers: [OverlaysCleanerWithinNavigation()],
    //
    /// 🐞 Verbose GoRouter logging in debug mode only
    debugLogDiagnostics: kDebugMode,

    ////

    /// ⏳ Splash as initial route
    initialLocation: RoutesPaths.splash,

    /// 🗺️ Full route table
    routes: AppRoutes.all,

    /// ❌ Fallback for unknown routes
    errorBuilder: (context, state) =>
        PageNotFound(errorMessage: state.error.toString()),
    //

    ////

    /// 🧭 Global redirect hook
    redirect: (context, state) {
      //
      /// Normalize Cubit state → AuthSnapshot
      final snap = switch (authCubit.state) {
        AuthViewLoading() => const AuthLoading(),
        AuthViewError(:final error) => AuthFailure(error),
        AuthViewReady(:final session) => AuthReady(session),
      };

      final currentPath = state.matchedLocation.isNotEmpty
          ? state.matchedLocation
          : state.uri.toString();

      // Pure, idempotent redirect logic
      return computeRedirect(
        currentPath: currentPath,
        snapshot: snap,
        hasResolvedOnce: resolvedOnce.value,
      );
    },
  );

  //
}
