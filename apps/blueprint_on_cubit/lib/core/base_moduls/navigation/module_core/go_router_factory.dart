import 'package:blueprint_on_cubit/core/base_moduls/navigation/module_core/routes_redirection_service.dart';
import 'package:blueprint_on_cubit/core/base_moduls/navigation/routes/app_routes.dart';
import 'package:blueprint_on_cubit/core/shared_presentation/pages/page_not_found.dart'
    show PageNotFound;
import 'package:core/base_modules/overlays/utils/overlays_cleaner_within_navigation.dart'
    show OverlaysCleanerWithinNavigation;
import 'package:core/utils_shared/auth/auth_snapshot.dart';
import 'package:go_router/go_router.dart';
import 'package:specific_for_bloc/user_auth_cubit/auth_stream_cubit.dart';

/// 🧭🚦[buildGoRouter] — GoRouter factory. Returns fully constructed [GoRouter] instance
/// ✅ Declaratively creates router in dependence of actual [authState].
//
// GoRouter buildGoRouter(AuthState authState) {
GoRouter buildGoRouter(AuthViewState authState) {
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
      // RoutesRedirectionService.from(context, state, authState);
      final snapshot = switch (authState) {
        AuthViewLoading() => const AuthLoading(),
        AuthViewError(:final error) => AuthFailure(error),
        AuthViewReady(:final session) => AuthReady(session),
      };
      return computeRedirect(
        currentPath: state.matchedLocation.isNotEmpty
            ? state.matchedLocation
            : state.uri.toString(),
        snapshot: snapshot,
      );
    },
  );
}
