/*


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


 */
