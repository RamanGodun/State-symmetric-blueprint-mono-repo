import 'package:bloc_adapter/utils/user_auth_cubit/auth_stream_cubit.dart';
import 'package:blueprint_on_cubit/core/base_modules/navigation/module_core/resolve_once_cache.dart';
import 'package:blueprint_on_cubit/core/base_modules/navigation/routes/app_routes.dart';
import 'package:blueprint_on_cubit/core/shared_presentation/pages/page_not_found.dart'
    show PageNotFound;
import 'package:core/base_modules/overlays/utils/overlays_cleaner_within_navigation.dart'
    show OverlaysCleanerWithinNavigation;
import 'package:core/utils_shared/auth/auth_snapshot.dart';
import 'package:go_router/go_router.dart';

part 'routes_redirection_service.dart';

/// 🧭🚦[buildGoRouter] — GoRouter factory. Returns fully constructed [GoRouter] instance
/// ✅ Declaratively creates router in dependence of [AuthCubit].
//
GoRouter buildGoRouter(AuthCubit authCubit) {
  final resolvedOnce = ResolvedOnceCache(authCubit.stream);
  //
  return GoRouter(
    /// 👁️ Observers — navigation side-effects (e.g., dismissing overlays)
    observers: [OverlaysCleanerWithinNavigation()],

    /// 🐞 Enable verbose logging for GoRouter (only active in debug mode)
    debugLogDiagnostics: true,

    ////

    /// ⏳ Initial route shown on app launch (Splash Screen)
    initialLocation: RoutesPaths.splash,

    /// 🗺️ Route definitions used across the app
    routes: AppRoutes.all,

    /// ❌ Fallback UI for unknown/unmatched routes
    errorBuilder: (context, state) =>
        PageNotFound(errorMessage: state.error.toString()),
    //

    /// 🧭 Global redirect handler — routes user depending on auth state
    redirect: (context, state) {
      final snap = switch (authCubit.state) {
        AuthViewLoading() => const AuthLoading(),
        AuthViewError(:final error) => AuthFailure(error),
        AuthViewReady(:final session) => AuthReady(session),
      };

      final currentPath = state.matchedLocation.isNotEmpty
          ? state.matchedLocation
          : state.uri.toString();

      return computeRedirect(
        currentPath: currentPath,
        snapshot: snap,
        hasResolvedOnce: resolvedOnce.value,
      );
    },
  );

  //
}
